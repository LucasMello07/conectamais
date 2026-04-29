package conecta.controladores;

import conecta.dto.RankingProfissionalDTO;
import conecta.entidades.Usuario;
import conecta.jdbc.ConnectionFactory;
import conecta.service.RankingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

/** @author Sebas */
@WebServlet("/ranking")
public class RankingServlet extends HttpServlet {

    private final RankingService service = new RankingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String acao  = param(req, "acao", "listarTop");
        int page     = parseInt(param(req, "page", "1"), 1);
        int limit    = parseInt(param(req, "limit", "50"), 50);
        int offset   = Math.max(0, (page - 1) * limit);

        try {
            switch (acao) {
                case "listarTop" -> {
                    // Ranking geral (para ambos)
                    req.setAttribute("listaRanking", service.top(limit, offset));
                    req.setAttribute("page", page);
                    req.setAttribute("limit", limit);

                    // Roteamento por tipo de usuário
                    Usuario u = (Usuario) req.getSession().getAttribute("usuarioLogado");
                    String destino;
                        if (u != null && "Profissional".equalsIgnoreCase(u.getTipoUsuario())) {
                        long idProf = u.getIdUsuario();                 // << direto
                        RankingProfissionalDTO meu = service.doProfissional(idProf);
                        req.setAttribute("meuRanking", meu);

                    destino = "/pages/dashboard-Profissional/UC-23-Listar-Ranking-Profissional/ranking-Profissional.jsp";
                } else {
                    destino = "/pages/dashboard-Cliente/UC-23-Listar-Ranking-Profissional/ranking-Cliente.jsp";
                }

                    req.getRequestDispatcher(destino).forward(req, resp);
                }
                default -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
            }
        } catch (SQLException e) {
            throw new ServletException("Erro ao carregar ranking", e);
        }
    }


    private String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v == null || v.isBlank()) ? def : v.trim();
    }
    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}
