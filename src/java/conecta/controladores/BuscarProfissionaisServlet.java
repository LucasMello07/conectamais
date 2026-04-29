package conecta.controladores;

import conecta.dto.ProfissionalBuscaDTO;
import conecta.service.ProfissionalService;
import conecta.service.FavoritoService;
import conecta.entidades.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 *
 * @author Sebas
 */
@WebServlet("/buscar-profissionais")
public class BuscarProfissionaisServlet extends HttpServlet {

    private final ProfissionalService service = new ProfissionalService();
    private final FavoritoService favoritoService = new FavoritoService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Usuario u = getUsuario(req);
        if (u == null || !"Cliente".equalsIgnoreCase(u.getTipoUsuario())) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        String termo = param(req, "termo", "");
        int page = parseIntSafe(req.getParameter("page"), 1);
        int limit = parseIntSafe(req.getParameter("limit"), 10);
        int offset = Math.max(0, (page - 1) * limit);

        try {
            List<ProfissionalBuscaDTO> resultados = service.buscarPlano(termo, limit, offset);
            int total = service.contarPlano(termo);

            long idCliente = (u.getIdUsuario() != null) ? u.getIdUsuario() : 0L;
            List<Long> idsFavoritosList = favoritoService.buscarIdsFavoritosDoCliente(idCliente);

            Map<Long, Boolean> favMap = new HashMap<>();
            for (Long id : idsFavoritosList) {
                if (id != null) {
                    favMap.put(id, Boolean.TRUE);
                }
            }

            req.setAttribute("termo", termo);
            req.setAttribute("resultados", resultados);
            req.setAttribute("total", total);
            req.setAttribute("page", page);
            req.setAttribute("limit", limit);
            req.setAttribute("favMap", favMap);

            req.getRequestDispatcher(
                    "/pages/dashboard-Cliente/UC10-Listar-Agendamentos-Cliente/resultados-busca.jsp"
            ).forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Erro ao buscar profissionais", e);
        }
    }

    private Usuario getUsuario(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (Usuario) s.getAttribute("usuarioLogado") : null;
    }

    private String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v == null || v.isBlank()) ? def : v.trim();
    }

    private int parseIntSafe(String s, int def) {
        try {
            return (s == null || s.isBlank()) ? def : Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return def;
        }
    }
}
