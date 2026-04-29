package conecta.controladores;

import conecta.entidades.Cliente;
import conecta.entidades.Favorito;
import conecta.entidades.Profissional;
import conecta.entidades.Usuario;
import conecta.service.FavoritoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Sebas
 */
@WebServlet("/favoritos")
public class FavoritoServlet extends HttpServlet {

    private final FavoritoService service = new FavoritoService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = param(req, "acao", "listar");
        try {
            switch (acao) {
                case "listar", "buscar" -> {
                    long idCliente = getIdClienteLogado(req);
                    if (idCliente <= 0) {
                        resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
                        return;
                    }
                    String termo = "buscar".equals(acao) ? req.getParameter("termo") : null;
                    List<Favorito> lista = service.listarDetalhado(idCliente, termo);

                    req.setAttribute("favoritos", lista);
                    req.setAttribute("termo", termo);
                    req.getRequestDispatcher("/pages/dashboard-Cliente/UC-25-Listar-Profissionais-Favoritos/favoritos.jsp")
                            .forward(req, resp);
                }
                case "remover" -> {
                    long idCliente = getIdClienteLogado(req);
                    if (idCliente <= 0) {
                        resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
                        return;
                    }
                    long idProf = parseLongSafe(req.getParameter("id_profissional"), 0L);
                    if (idProf <= 0) {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Profissional inválido");
                        return;
                    }
                    service.desfavoritar(idCliente, idProf);
                    resp.sendRedirect(req.getContextPath() + "/favoritos?acao=listar");
                }
                default ->
                    resp.sendRedirect(req.getContextPath() + "/favoritos?acao=listar");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = param(req, "acao", "");
        try {
            if ("adicionar".equals(acao)) {
                long idCliente = getIdClienteLogado(req);
                if (idCliente <= 0) {
                    resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
                    return;
                }
                long idProf = parseLongSafe(req.getParameter("id_profissional"), 0L);
                if (idProf <= 0) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Profissional inválido");
                    return;
                }

                Favorito f = new Favorito();
                Cliente c = new Cliente();
                c.setIdCliente(idCliente);
                f.setCliente(c);
                Profissional p = new Profissional();
                p.setIdProfissional(idProf);
                f.setProfissional(p);

                service.favoritar(f);
                resp.sendRedirect(req.getContextPath() + "/favoritos?acao=listar");
                return;
            }
            doGet(req, resp);
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
        try {
            return (s == null || s.isBlank()) ? def : Long.parseLong(s.trim());
        } catch (NumberFormatException e) {
            return def;
        }
    }

    private long getIdClienteLogado(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) {
            return 0L;
        }
        Object o = s.getAttribute("usuarioLogado");
        if (o instanceof Usuario u && "Cliente".equalsIgnoreCase(u.getTipoUsuario())) {
            // Usuario.idUsuario é Long; evita NPE
            return (u.getIdUsuario() != null) ? u.getIdUsuario() : 0L;
        }
        return 0L;
    }
}
