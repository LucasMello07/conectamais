package conecta.controladores;

import conecta.dao.AgendamentoDAO;
import conecta.dao.UsuarioDAO;
import conecta.entidades.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/** 
 *
 * @author Sebas
 */
@WebServlet("/perfil-cliente")
public class VisitarPerfilClienteServlet extends HttpServlet {

    private final AgendamentoDAO agDao = new AgendamentoDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO(); // precisa ter um DAO simples para puxar dados do cliente

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Usuario prof = getUsuario(req);
        if (prof == null || !"Profissional".equalsIgnoreCase(prof.getTipoUsuario())) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        long idCliente = parseLongSafe(req.getParameter("id"), 0L);
        if (idCliente <= 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cliente inválido");
            return;
        }

        try {
            // Gate: só entra se houver vínculo (agendamento)
            boolean vinculo = agDao.existeVinculo(prof.getIdUsuario(), idCliente);
            if (!vinculo) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Sem vínculo com este cliente.");
                return;
            }

            Usuario cliente = usuarioDAO.buscarPorId(idCliente);
            if (cliente == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Cliente não encontrado");
                return;
            }

            req.setAttribute("cliente", cliente);
            // Opcional: carregar avaliações que este cliente fez a outros profissionais
            // List<Avaliacao> avals = avaliacaoDAO.listarPorClienteDetalhado(idCliente);
            // req.setAttribute("avaliacoes", avals);

            req.getRequestDispatcher("/pages/dashboard-Profissional/UC-35-Gerenciar-Perfil-Profissional/visitar-Perfil-cliente.jsp")
               .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // helpers
    private Usuario getUsuario(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (Usuario) s.getAttribute("usuarioLogado") : null;
    }
    private long parseLongSafe(String s, long def) {
        try { return (s == null || s.isBlank()) ? def : Long.parseLong(s.trim()); }
        catch (NumberFormatException e) { return def; }
    }
}