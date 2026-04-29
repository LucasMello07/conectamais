package conecta.controladores;

import conecta.dto.ClientePerfilDTO;
import conecta.dto.AvaliacaoResumoDTO;
import conecta.dto.ProfissionalFavoritoDTO;
import conecta.service.ClienteService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * @author Sebas
 */
@WebServlet("/clientes")
public class ClienteServlet extends HttpServlet {

    private final ClienteService service = new ClienteService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String acao = param(req, "acao", "perfil");
        try {
            switch (acao) {
                case "perfil": {
                    long idCliente = parseLongSafe(req.getParameter("id"), 0L);
                    if (idCliente <= 0) {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cliente inválido");
                        return;
                    }

                    ClientePerfilDTO cliente = service.buscarPerfilCliente(idCliente);
                    if (cliente == null) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Cliente não encontrado");
                        return;
                    }

                    List<ProfissionalFavoritoDTO> favoritos = service.listarFavoritos(idCliente);
                    List<AvaliacaoResumoDTO> avaliacoes = service.listarAvaliacoesFeitas(idCliente);

                    req.setAttribute("cliente", cliente);
                    req.setAttribute("favoritos", favoritos);
                    req.setAttribute("avaliacoes", avaliacoes);

                    // ajuste o caminho se sua JSP estiver em outra pasta
                    req.getRequestDispatcher("/pages/dashboard-Profissional/UC13-Listar-Agendamentos-Profissional/visitar-Perfil-cliente.jsp")
                       .forward(req, resp);
                    return;
                }
                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
            }
        } catch (SQLException e) {
            throw new ServletException("Erro ao carregar perfil do cliente", e);
        }
    }

    // utils
    private static String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v == null || v.isBlank()) ? def : v.trim();
    }
    private static long parseLongSafe(String s, long def) {
        try { return (s == null || s.isBlank()) ? def : Long.parseLong(s.trim()); }
        catch (NumberFormatException e) { return def; }
    }
}
