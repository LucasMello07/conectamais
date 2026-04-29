package conecta.controladores;

import conecta.dao.AgendamentoDAO;
import conecta.entidades.Agendamento;
import conecta.entidades.Cliente;
import conecta.entidades.Profissional;
import conecta.entidades.Usuario;
import conecta.service.AgendamentoService;
import conecta.service.HabilidadeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Sebas
 */
@WebServlet(urlPatterns = "/agendamentos")
public class AgendamentoServlet extends HttpServlet {

    private AgendamentoService service;
    private AgendamentoDAO dao;
    private HabilidadeService habilidadeService;

    @Override
    public void init() {
        this.service = new AgendamentoService();
        this.dao = new AgendamentoDAO();
        this.habilidadeService = new HabilidadeService();
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String acao = req.getParameter("acao");
        if ("cancelar".equalsIgnoreCase(acao)) {
            try {
                cancelar(req, resp);
            } catch (SQLException e) {
                throw new ServletException(e);
            }
            return;
        }
        if ("concluir".equalsIgnoreCase(acao)) {
            try {
                concluir(req, resp);
            } catch (SQLException e) {
                throw new ServletException(e);
            }
            return;
        }
        super.service(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String acao = nvl(req.getParameter("acao"), "listarCliente");
        try {
            service.autoConcluirExpirados();
            switch (acao) {
                case "novo" ->
                    novo(req, resp);
                case "listarCliente" ->
                    listarCliente(req, resp);
                case "listarProfissional" ->
                    listarProfissional(req, resp);
                default ->
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Ação inválida");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String acao = req.getParameter("acao");
        if (acao == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação é obrigatória");
            return;
        }
        try {
            switch (acao) {
                case "criar" ->
                    criar(req, resp);
                default ->
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Ação inválida");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void novo(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException, ServletException {
        Usuario u = getLogado(req);
        if (!isTipo(u, "Cliente")) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        Long idProfL = parseLongAny(req, "id_profissional");
        if (idProfL == null || idProfL <= 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "id_profissional é obrigatório");
            return;
        }
        int idProf = idProfL.intValue();

        var habilidadesAtivas = habilidadeService.listarAtivasPorProfissional(idProf);

        req.setAttribute("idProfissional", idProfL);
        req.setAttribute("habilidadesAtivasDoProfissional", habilidadesAtivas);
        req.setAttribute("habilidades", habilidadesAtivas);

        req.getRequestDispatcher("/pages/dashboard-Cliente/UC10-Listar-Agendamentos-Cliente/agendar-atendimento-Cliente.jsp")
                .forward(req, resp);
    }

    private void listarCliente(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException, ServletException {
        Usuario u = getLogado(req);
        if (!isTipo(u, "Cliente")) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        long idCliente = u.getIdUsuario();

        List<Agendamento> lista = dao.listarPorClienteComAvaliacao(idCliente);

        int qtdPendentes = service.contarCliente("Pendente", idCliente);
        int qtdConcluidos = service.contarCliente("Concluído", idCliente);

        req.setAttribute("agendamentos", lista);
        req.setAttribute("qtdPendentes", qtdPendentes);
        req.setAttribute("qtdConcluidos", qtdConcluidos);

        req.getRequestDispatcher("/pages/dashboard-Cliente/UC10-Listar-Agendamentos-Cliente/Listagem-agendamentos-cliente.jsp")
                .forward(req, resp);
    }

    private void listarProfissional(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException, ServletException {
        Usuario u = getLogado(req);
        if (!isTipo(u, "Profissional")) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        long idProf = u.getIdUsuario();
        List<Agendamento> lista = dao.listarPorProfissionalComCliente(idProf);

        int qtdPendentes = service.contarProf("Pendente", idProf);
        int qtdConcluidos = service.contarProf("Concluído", idProf);

        req.setAttribute("agendamentos", lista);
        req.setAttribute("qtdPendentes", qtdPendentes);
        req.setAttribute("qtdConcluidos", qtdConcluidos);
        req.setAttribute("idProfissional", idProf);

        req.getRequestDispatcher("/pages/dashboard-Profissional/UC13-Listar-Agendamentos-Profissional/Listagem-agendamentos-profissional.jsp")
                .forward(req, resp);
    }

    private void criar(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException, ServletException {
        Usuario logado = getLogado(req);
        if (!isTipo(logado, "Cliente")) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        Long idProf = parseLongAny(req, "id_profissional", "idProfissional", "profissional_id", "pro_id");
        String dataStr = any(req, "data", "data_agendamento", "dataAgendamento", "dt");
        String horaStr = any(req, "horario", "hora", "horario_agendamento", "horarioAgendamento", "hr");
        Long idHab = parseLongAny(req, "id_habilidade", "habilidade_id", "idHabilidade");

        if (idProf == null || isBlank(dataStr) || isBlank(horaStr)) {
            throw new IllegalArgumentException("Parâmetros obrigatórios ausentes (profissional, data, horário).");
        }

        Agendamento a = new Agendamento();

        Cliente c = new Cliente();
        c.setIdCliente(logado.getIdUsuario());
        Profissional p = new Profissional();
        p.setIdProfissional(idProf);

        a.setCliente(c);
        a.setProfissional(p);
        a.setDataAgendamento(java.sql.Date.valueOf(dataStr));
        a.setHorarioAgendamento(horaStr);
        if (idHab != null) {
            a.setIdHabilidade(idHab);
        }

        try {
            Long novoId = service.agendar(a, logado);
            resp.sendRedirect(req.getContextPath() + "/agendamentos?acao=listarCliente&ag_ok=" + novoId);
        } catch (IllegalArgumentException ex) {
            req.setAttribute("erroAgendar", ex.getMessage());
            req.setAttribute("idProfissional", idProf);
            req.setAttribute("data", dataStr);
            req.setAttribute("hora", horaStr);
            req.setAttribute("idHabilidade", idHab);

            var habilidadesAtivas = habilidadeService.listarAtivasPorProfissional(idProf.intValue());
            req.setAttribute("habilidadesAtivasDoProfissional", habilidadesAtivas);
            req.setAttribute("habilidades", habilidadesAtivas);

            req.getRequestDispatcher("/pages/dashboard-Cliente/UC10-Listar-Agendamentos-Cliente/agendar-atendimento-Cliente.jsp")
                    .forward(req, resp);
        }
    }

    private void cancelar(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        Usuario logado = getLogado(req);
        if (logado == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        long idAg = Long.parseLong(req.getParameter("id"));
        service.cancelar(idAg);

        String origem = nvl(req.getParameter("origem"), "cliente");
        if ("prof".equalsIgnoreCase(origem)) {
            resp.sendRedirect(req.getContextPath() + "/agendamentos?acao=listarProfissional&ag_cancel=" + idAg);
        } else {
            resp.sendRedirect(req.getContextPath() + "/agendamentos?acao=listarCliente&ag_cancel=" + idAg);
        }
    }

    private void concluir(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        Usuario logado = getLogado(req);
        if (logado == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        long idAg = Long.parseLong(req.getParameter("id"));
        service.concluir(idAg);

        resp.sendRedirect(req.getContextPath() + "/agendamentos?acao=listarProfissional&ag_conc=" + idAg);
    }

    private Usuario getLogado(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s == null) ? null : (Usuario) s.getAttribute("usuarioLogado");
    }

    private boolean isTipo(Usuario u, String tipo) {
        return u != null && tipo.equalsIgnoreCase(u.getTipoUsuario());
    }

    private static String any(HttpServletRequest req, String... names) {
        for (String n : names) {
            String v = req.getParameter(n);
            if (v != null && !v.trim().isEmpty()) {
                return v.trim();
            }
        }
        return null;
    }

    private static Long parseLongAny(HttpServletRequest req, String... names) {
        String s = any(req, names);
        if (s == null) {
            return null;
        }
        try {
            return Long.parseLong(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static String nvl(String s, String d) {
        return s == null ? d : s;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
