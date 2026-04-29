
package conecta.controladores;

import conecta.entidades.Habilidade;
import conecta.entidades.Usuario;
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
@WebServlet("/habilidades")
public class HabilidadeServlet extends HttpServlet {
    private final HabilidadeService service = new HabilidadeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Evita cache (voltar do browser mostrando lista “antiga”)
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");

        String acao = param(req, "acao", "listar");
        try {
            switch (acao) {
                case "novo" -> {
                    int idProf = resolveIdProfissional(req); // passa sempre para o form
                    req.setAttribute("idProfissional", idProf);
                    req.getRequestDispatcher("/pages/dashboard-Profissional/UC-15-Listar-Habilidades-Profissional/form-habilidade.jsp")
                       .forward(req, resp);
                }
                case "editar" -> {
                    int id = parseIntSafe(req.getParameter("id"), 0);
                    if (id <= 0) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido"); return; }
                    Habilidade h = service.buscar(id);
                    req.setAttribute("habilidade", h);
                    req.setAttribute("idProfissional", h != null ? h.getIdProfissional() : 0);
                    req.getRequestDispatcher("/pages/dashboard-Profissional/UC-15-Listar-Habilidades-Profissional/form-habilidade.jsp")
                       .forward(req, resp);
                }
                case "excluir" -> {
                    int id = parseIntSafe(req.getParameter("id"), 0);
                    int idProf = resolveIdProfissional(req);
                    if (id <= 0 || idProf <= 0) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parâmetros inválidos"); return; }
                    service.excluir(id);
                    resp.sendRedirect(req.getContextPath() + "/habilidades?acao=listar&id_profissional=" + idProf);
                }
                default -> { // listar
                    int idProf = resolveIdProfissional(req);
                    if (idProf <= 0) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Profissional não informado"); return; }
                    List<Habilidade> habilidades = service.listarPorProfissional(idProf);
                    req.setAttribute("habilidades", habilidades);
                    req.setAttribute("idProfissional", idProf);
                    req.getRequestDispatcher("/pages/dashboard-Profissional/UC-15-Listar-Habilidades-Profissional/Listagem-Habilidades-profissional.jsp")
                       .forward(req, resp);
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Evita re-envio e cache
        resp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        resp.setHeader("Pragma", "no-cache");

        String acao = req.getParameter("acao");
        try {
            if ("salvar".equals(acao)) {
                int idProf = resolveIdProfissional(req);
                int id = parseIntSafe(req.getParameter("id"), 0);

                if (idProf <= 0) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Profissional não informado"); return; }

                Habilidade h = new Habilidade();
                h.setTitulo(param(req, "titulo", ""));
                h.setDescricao(param(req, "descricao", ""));
                h.setStatus(param(req, "status", "Ativo"));
                h.setIdProfissional(idProf);

                if (id > 0) {
                    h.setIdHabilidade(id);
                    service.editar(h);
                } else {
                    service.adicionar(h);
                }
                resp.sendRedirect(req.getContextPath() + "/habilidades?acao=listar&id_profissional=" + idProf);
                return;
            }
            int idProf = resolveIdProfissional(req);
            resp.sendRedirect(req.getContextPath() + "/habilidades?acao=listar&id_profissional=" + idProf);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // -------- Helpers --------
    private String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v == null || v.isBlank()) ? def : v.trim();
    }
    private int parseIntSafe(String s, int def) {
        try { return (s == null || s.isBlank()) ? def : Integer.parseInt(s.trim()); }
        catch (NumberFormatException e) { return def; }
    }

    private int resolveIdProfissional(HttpServletRequest req) {
        int idProfParam = parseIntSafe(req.getParameter("id_profissional"), 0);
        if (idProfParam > 0) return idProfParam;

        HttpSession s = req.getSession(false);
        if (s != null) {
            Object o = s.getAttribute("usuarioLogado");
            if (o instanceof Usuario u && "Profissional".equalsIgnoreCase(u.getTipoUsuario()) && u.getIdUsuario() != null) {
                return u.getIdUsuario().intValue();
            }
        }
        return 0;
    }
}
