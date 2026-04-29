package conecta.controladores;

import conecta.dto.DenunciaDetalheDTO;
import conecta.dto.DenunciaListaDTO;
import conecta.entidades.Usuario;
import conecta.service.DenunciaService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * @author Sebas
 */
@WebServlet("/denuncias")
public class DenunciaServlet extends HttpServlet {

    private final DenunciaService service = new DenunciaService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        Usuario u = (s == null) ? null : (Usuario) s.getAttribute("usuarioLogado");

        if (u == null || !"Administrador".equalsIgnoreCase(u.getTipoUsuario())) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        String acao = param(req, "acao", "listar");
        try {
            switch (acao) {
                case "ver" -> {
                    int id = parseInt(req.getParameter("id"), 0);
                    DenunciaDetalheDTO dto = service.buscarDetalheDTO(id);
                    if (dto == null) {
                        resp.sendRedirect(req.getContextPath() + "/denuncias?acao=listar&err="
                                + enc("Denúncia não encontrada"));
                        return;
                    }
                    req.setAttribute("denuncia", dto);
                    req.getRequestDispatcher("/pages/dashboard-Administrador/denuncia-detalhe-ADM.jsp").forward(req, resp);
                }
                default -> {
                    List<DenunciaListaDTO> lista = service.listarTodasJoin();
                    req.setAttribute("denuncias", lista);
                    req.getRequestDispatcher("/pages/dashboard-Administrador/listagem-Denuncias-ADM.jsp").forward(req, resp);
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = param(req, "acao", "");

        try {
            if ("moderar".equalsIgnoreCase(acao)) {
                HttpSession s = req.getSession(false);
                Usuario u = (s == null) ? null : (Usuario) s.getAttribute("usuarioLogado");
                if (u == null || !"Administrador".equalsIgnoreCase(u.getTipoUsuario())) {
                    resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
                    return;
                }

                int idDenuncia = parseInt(req.getParameter("id_denuncia"), 0);
                String tipoAcao  = param(req, "tipo_acao", "INVALIDAR"); // SUSPENDER | BANIR | INVALIDAR
                String observacao = param(req, "observacao", "");
                String aplicarEm  = param(req, "aplicar_em", "profissional"); // profissional | cliente
                boolean aplicarNoProf = !"cliente".equalsIgnoreCase(aplicarEm);

                Date prazo = null;
                String prazoStr = req.getParameter("prazo_suspensao");
                if (prazoStr != null && !prazoStr.isBlank()) {
                    prazo = new SimpleDateFormat("yyyy-MM-dd").parse(prazoStr);
                }

                service.moderar(idDenuncia, tipoAcao, observacao, prazo, u.getIdUsuario().intValue(), aplicarNoProf);
                resp.sendRedirect(req.getContextPath() + "/usuarios?ok=1");
                return;
            }

            if ("novo".equalsIgnoreCase(acao)) {
                HttpSession s = req.getSession(false);
                Usuario u = (s == null) ? null : (Usuario) s.getAttribute("usuarioLogado");

                if (u == null || !"Cliente".equalsIgnoreCase(u.getTipoUsuario())) {
                    resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
                    return;
                }

                long idAgendamento = parseLong(req.getParameter("id_agendamento"), 0L);
                long idProfissional = parseLong(req.getParameter("id_profissional"), 0L);
                String motivo = param(req, "motivo", "");
                String descricao = param(req, "descricao", "");

                if (idAgendamento <= 0 || idProfissional <= 0 || motivo.isBlank() || descricao.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + "/agendamentos?acao=listarCliente&denuncia_err="
                            + enc("Dados inválidos para denúncia"));
                    return;
                }

                boolean valido = service.validarAgendamentoDoCliente(idAgendamento, u.getIdUsuario());
                if (!valido) {
                    resp.sendRedirect(req.getContextPath() + "/agendamentos?acao=listarCliente&denuncia_err="
                            + enc("Agendamento não pertence ao cliente logado"));
                    return;
                }

                try {
                    service.criarDenunciaCliente(idAgendamento, u.getIdUsuario(), idProfissional, motivo, descricao);
                    // ag_ok permite pintar “Denunciado” no item respeitante
                    resp.sendRedirect(req.getContextPath() + "/agendamentos?acao=listarCliente&denuncia_ok=1&ag_ok=" + idAgendamento);
                } catch (Exception ex) {
                    String msg = ex.getMessage() != null ? ex.getMessage() : "Falha ao registrar denúncia";
                    resp.sendRedirect(req.getContextPath() + "/agendamentos?acao=listarCliente&denuncia_err=" + enc(msg));
                }
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/denuncias?acao=listar&err=" + enc("Ação inválida"));
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private static String param(HttpServletRequest req, String nome, String def) {
        String v = req.getParameter(nome);
        return (v == null || v.isBlank()) ? def : v.trim();
    }
    private static int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
    private static long parseLong(String s, long def) {
        try { return Long.parseLong(s); } catch (Exception e) { return def; }
    }
    private static String enc(String s) {
        return URLEncoder.encode(s == null ? "" : s, StandardCharsets.UTF_8);
    }
}
