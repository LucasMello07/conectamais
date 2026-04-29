package conecta.controladores;

import conecta.dao.AvaliacaoDAO;
import conecta.entidades.Avaliacao;
import conecta.entidades.Usuario;
import conecta.service.AvaliacaoService;
import conecta.service.ProfissionalService;
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
@WebServlet(urlPatterns = {"/avaliacoes"})
public class AvaliacaoServlet extends HttpServlet {

    private final AvaliacaoDAO dao = new AvaliacaoDAO();
    private final AvaliacaoService service = new AvaliacaoService();
    private final ProfissionalService profService = new ProfissionalService();

    private static final String JSP_LISTA_CLIENTE =
        "/pages/dashboard-Cliente/UC-26-Listar-Avaliacoes-Cliente/avaliacoes-Cliente.jsp";
    private static final String JSP_LISTA_PROF =
        "/pages/dashboard-Profissional/UC-34-Listar-Avaliacoes-Profissional/avaliacoes-Profissional.jsp";
    private static final String JSP_FORM_CLIENTE =
        "/pages/dashboard-Cliente/UC-26-Listar-Avaliacoes-Cliente/form-avaliacao.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = param(req, "acao", "listarCliente");
        try {
            switch (acao) {
                case "novo" -> abrirFormNovo(req, resp);
                case "ver"  -> verPorAgendamento(req, resp);
                case "detalhar" -> verPorAgendamento(req, resp); // alias para "ver"
                case "listarCliente" -> listarCliente(req, resp);
                case "listarProfissional" -> listarProfissional(req, resp);
                case "editar" -> abrirFormEditar(req, resp);
                case "excluir" -> excluir(req, resp);
                default -> listarCliente(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = param(req, "acao", "salvar");
        try {
            if ("salvarEdicao".equalsIgnoreCase(acao)) {
                salvarEdicao(req, resp);
            } else if ("salvarNovo".equalsIgnoreCase(acao)) {
                salvarNovo(req, resp);
            } else {
                long id = longParam(req, "id");
                if (id > 0) salvarEdicao(req, resp);
                else salvarNovo(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void abrirFormNovo(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        long idAg  = longParam(req, "id_agendamento");
        long idProf = longParam(req, "id_profissional");
        if (idAg <= 0 || idProf <= 0) { resp.sendError(400); return; }

        // Se já existe avaliação para o agendamento, vai para "ver"
        Avaliacao existente = dao.buscarPorAgendamento(idAg);
        if (existente != null) {
            resp.sendRedirect(req.getContextPath()+"/avaliacoes?acao=ver&id_agendamento="+idAg);
            return;
        }

        // Carregar dados para exibir nome do profissional no form (modo novo)
        try {
            conecta.entidades.Profissional prof = profService.buscarPorId(idProf);
            req.setAttribute("profissional", prof);
            req.setAttribute("profissionalNome", prof != null && prof.getUsuario()!=null ? prof.getUsuario().getNomeCompleto() : null);
        } catch (Exception ignore) {}

        req.setAttribute("id_agendamento", idAg);
        req.setAttribute("id_profissional", idProf);

        req.getRequestDispatcher(JSP_FORM_CLIENTE).forward(req, resp);
    }

    private void verPorAgendamento(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        long idAg = longParam(req, "id_agendamento");
        if (idAg <= 0) { resp.sendError(400); return; }
        Avaliacao a = dao.buscarPorAgendamento(idAg);
        if (a == null) { resp.sendRedirect(req.getContextPath()+"/agendamentos?acao=listarCliente"); return; }

        req.setAttribute("avaliacao", a);
        req.setAttribute("id_agendamento", idAg);
        req.setAttribute("id_profissional", a.getProfissional() != null ? a.getProfissional().getIdProfissional() : 0L);
        req.setAttribute("profissionalNome", a.getNomeProfissional());
        req.getRequestDispatcher(JSP_FORM_CLIENTE).forward(req, resp);
    }

    private void listarCliente(HttpServletRequest req, HttpServletResponse resp)
        throws SQLException, ServletException, IOException {

    long idCliente = getIdUsuario(req, "Cliente");
    if (idCliente <= 0) {
        resp.sendError(403);
        return;
    }

    // lista normal
    List<Avaliacao> list = service.listarCliente(idCliente);
    req.setAttribute("avaliacoes", list);

    // highlight por agendamento
    String highlightAgParam = req.getParameter("highlight_ag");
    if (highlightAgParam != null && !highlightAgParam.isBlank()) {
        try {
            long idAg = Long.parseLong(highlightAgParam);
            Long idAval = dao.buscarIdPorAgendamentoCliente(idAg, idCliente);
            if (idAval != null) {
                req.setAttribute("highlightId", idAval);
            }
        } catch (NumberFormatException ignore) { }
    }

    // highlight direto por avaliação (compatibilidade)
    String highlightParam = req.getParameter("highlight");
    if (highlightParam != null && !highlightParam.isBlank()) {
        try {
            req.setAttribute("highlightId", Long.parseLong(highlightParam));
        } catch (NumberFormatException ignore) { }
    }

    req.getRequestDispatcher(JSP_LISTA_CLIENTE).forward(req, resp);
}


    private void listarProfissional(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        long idProf = getIdUsuario(req, "Profissional");
        if (idProf <= 0) { resp.sendError(403); return; }
        List<Avaliacao> list = service.listarRecebidasPorProfissional(idProf);
        req.setAttribute("avaliacoes", list);
        req.getRequestDispatcher(JSP_LISTA_PROF).forward(req, resp);
    }

    private void abrirFormEditar(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        long idCli = getIdUsuario(req, "Cliente");
        long id   = longParam(req, "id");
        Avaliacao a = dao.buscarPorId(id);
        if (a == null || a.getCliente()==null || a.getCliente().getIdCliente()==null || a.getCliente().getIdCliente()!=idCli) {
            resp.sendError(404); return;
        }
        req.setAttribute("avaliacao", a);
        req.setAttribute("id_agendamento", a.getAgendamento().getIdAgendamento());
        req.setAttribute("id_profissional", a.getProfissional().getIdProfissional());
        req.setAttribute("profissionalNome", a.getNomeProfissional());
        req.getRequestDispatcher(JSP_FORM_CLIENTE).forward(req, resp);
    }

    private void salvarEdicao(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        long idCli = getIdUsuario(req, "Cliente");
        long id   = longParam(req, "id");
        String nota = req.getParameter("nota");
        String comentario = req.getParameter("comentario");

        try {
            service.editarAvaliacao(idCli, id, nota, comentario);
            resp.sendRedirect(req.getContextPath()+"/avaliacoes?acao=listarCliente");
        } catch (IllegalArgumentException ex) {
            req.setAttribute("erro", ex.getMessage());
            req.setAttribute("id", id);
            req.getRequestDispatcher(JSP_FORM_CLIENTE).forward(req, resp);
        }
    }

    private void excluir(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        long idCli = getIdUsuario(req, "Cliente");
        long id   = longParam(req, "id");
        service.excluirAvaliacao(idCli, id);
        resp.sendRedirect(req.getContextPath()+"/avaliacoes?acao=listarCliente");
    }

    private void salvarNovo(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        long idCliente = getIdUsuario(req, "Cliente");
        long idProf    = longParam(req, "id_profissional");
        long idAg      = longParam(req, "id_agendamento");
        String nota = req.getParameter("nota");
        String comentario = req.getParameter("comentario");

        try {
            service.salvarNovaAvaliacao(idCliente, idProf, idAg, nota, comentario);
            // após salvar novo, destacar pela âncora do agendamento
            resp.sendRedirect(req.getContextPath()+"/avaliacoes?acao=listarCliente&highlight_ag="+idAg);
        } catch (IllegalArgumentException ex) {
            req.setAttribute("erro", ex.getMessage());
            req.setAttribute("id_agendamento", idAg);
            req.setAttribute("id_profissional", idProf);
            req.getRequestDispatcher(JSP_FORM_CLIENTE).forward(req, resp);
        }
    }

    private String param(HttpServletRequest req, String n, String d){ String v=req.getParameter(n); return (v==null||v.isBlank())?d:v.trim(); }
    private long longParam(HttpServletRequest req, String n){ try { return Long.parseLong(param(req,n,"0")); }catch(Exception e){return 0L;} }
    private long getIdUsuario(HttpServletRequest req, String tipo) {
        HttpSession s=req.getSession(false);
        if (s==null) return 0;
        Usuario u=(Usuario)s.getAttribute("usuarioLogado");
        if (u!=null && tipo.equalsIgnoreCase(u.getTipoUsuario()) && u.getIdUsuario()!=null) return u.getIdUsuario();
        return 0;
    }
}
