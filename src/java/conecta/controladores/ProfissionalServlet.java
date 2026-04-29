package conecta.controladores;

import conecta.dao.FavoritoDAO;
import conecta.dto.HabilidadeDTO;
import conecta.entidades.Avaliacao;
import conecta.entidades.Profissional;
import conecta.entidades.Usuario;
import conecta.service.AvaliacaoService;
import conecta.service.ProfissionalService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

/** @author Sebas */
@WebServlet("/profissionais")
public class ProfissionalServlet extends HttpServlet {

    private final ProfissionalService service = new ProfissionalService();
    private final AvaliacaoService avaliacaoService = new AvaliacaoService(); // << novo
    private final FavoritoDAO favoritoDAO = new FavoritoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = param(req, "acao", "perfil");
        try {
            switch (acao) {
                case "perfil": {
                    long idProf = parseLongSafe(req.getParameter("id"), 0L);
                    if (idProf <= 0) {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Profissional inválido");
                        return;
                    }

                    // BLINDAGEM: se for um profissional tentando abrir o próprio perfil público, redireciona para "Meu Perfil".
                    Usuario u = getUsuario(req);
                    if (u != null
                            && "Profissional".equalsIgnoreCase(u.getTipoUsuario())
                            && u.getIdUsuario() != null
                            && idProf == u.getIdUsuario()) {
                        resp.sendRedirect(req.getContextPath() + "/perfil?acao=ver");
                        return;
                    }

                    // carrega dados do profissional e habilidades ativas
                    Profissional prof = service.buscarPorId(idProf);
                    if (prof == null) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Profissional não encontrado");
                        return;
                    }
                    List<HabilidadeDTO> habs = service.listarHabilidadesAtivas(idProf);

                    // NOVO: avaliações recebidas por este profissional
                    List<Avaliacao> avaliacoes = avaliacaoService.listarRecebidasPorProfissional(idProf);
                    req.setAttribute("avaliacoes", avaliacoes);

                    // calcula se já é favorito (quando cliente estiver logado)
                    boolean favoritado = false;
                    if (u != null
                            && "Cliente".equalsIgnoreCase(u.getTipoUsuario())
                            && u.getIdUsuario() != null) {
                        long idClienteOuUsuario = u.getIdUsuario();
                        try {
                            favoritado = favoritoDAO.isFavorito(idClienteOuUsuario, idProf);
                        } catch (SQLException ignore) {
                            // mantém false se der erro
                        }
                    }

                    // atributos para a JSP
                    req.setAttribute("profissional", prof);
                    req.setAttribute("habilidadesAtivas", habs);
                    req.setAttribute("favoritado", favoritado);

                    if ("1".equals(req.getParameter("hideAgendar"))) {
                        req.setAttribute("hideAgendar", true);
                    }

                    req.getRequestDispatcher("/pages/dashboard-Cliente/UC10-Listar-Agendamentos-Cliente/visitar-Perfil-profissional.jsp")
                            .forward(req, resp);
                    return;
                }

                case "buscar": {
                    String termo = param(req, "termo", "");
                    String encoded = URLEncoder.encode(termo, StandardCharsets.UTF_8);
                    resp.sendRedirect(req.getContextPath() + "/buscar-profissionais?termo=" + encoded);
                    return;
                }

                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // helpers
    private String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v == null || v.isBlank()) ? def : v.trim();
    }

    private long parseLongSafe(String s, long def) {
        try { return (s == null || s.isBlank()) ? def : Long.parseLong(s.trim()); }
        catch (NumberFormatException e) { return def; }
    }

    private Usuario getUsuario(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (Usuario) s.getAttribute("usuarioLogado") : null;
    }
}
