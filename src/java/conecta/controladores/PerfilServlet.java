package conecta.controladores;

import conecta.entidades.Usuario;
import conecta.entidades.Cliente;
import conecta.entidades.Profissional;
import conecta.service.UsuarioService;
import conecta.service.ClienteService;
import conecta.service.ProfissionalService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * atualização apenas nos campos de USUARIOS.
 *
 * @author Sebas
 */
@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {

    private final UsuarioService usuarioService = new UsuarioService();
    private final ClienteService clienteService = new ClienteService();
    private final ProfissionalService profissionalService = new ProfissionalService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Usuario logado = (Usuario) req.getSession().getAttribute("usuarioLogado");
        if (logado == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        String acao = param(req, "acao", "ver");
        try {
            if ("ver".equalsIgnoreCase(acao)) {
                Usuario usuario = usuarioService.buscarPorId(logado.getIdUsuario());
                req.setAttribute("usuario", usuario);

                if ("Cliente".equalsIgnoreCase(logado.getTipoUsuario())) {
                    Cliente cli = clienteService.buscarPorUsuarioId(logado.getIdUsuario());
                    req.setAttribute("cliente", cli);
                    req.getRequestDispatcher("/pages/dashboard-Cliente/UC-22-Gerenciar-Perfil-Cliente/perfil-Cliente.jsp")
                       .forward(req, resp);
                } else if ("Profissional".equalsIgnoreCase(logado.getTipoUsuario())) {
                    Profissional prof = profissionalService.buscarPorUsuarioId(logado.getIdUsuario());
                    req.setAttribute("profissional", prof);
                    req.getRequestDispatcher("/pages/dashboard-Profissional/UC-35-Gerenciar-Perfil-Profissional/perfil-Profissional.jsp")
                       .forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Tipo de usuário não suportado");
                }
                return;
            }

            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
        } catch (SQLException e) {
            throw new ServletException("Erro ao carregar perfil", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Usuario logado = (Usuario) req.getSession().getAttribute("usuarioLogado");
        if (logado == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        String acao = param(req, "acao", "atualizar");
        if (!"atualizar".equalsIgnoreCase(acao)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
            return;
        }

        String nome = req.getParameter("nome_completo");
        String celular = req.getParameter("celular");
        String email = req.getParameter("email");
        String genero = req.getParameter("genero");
        String rua = req.getParameter("endereco_rua");
        String bairro = req.getParameter("bairro");
        String cidade = req.getParameter("cidade");
        String estado = req.getParameter("estado");

        try {
            usuarioService.atualizarBasico(
                logado.getIdUsuario(),
                nome, celular, email, genero,
                rua, bairro, cidade, estado
            );

            req.getSession().setAttribute("flash", "Perfil atualizado com sucesso!");
            resp.sendRedirect(req.getContextPath() + "/perfil?acao=ver");
        } catch (IllegalArgumentException ex) {
            req.getSession().setAttribute("flashErro", ex.getMessage());
            resp.sendRedirect(req.getContextPath() + "/perfil?acao=ver");
        } catch (SQLException e) {
            throw new ServletException("Erro ao atualizar perfil", e);
        }
    }

    private String param(HttpServletRequest req, String k, String def) {
        String v = req.getParameter(k);
        return v == null || v.isBlank() ? def : v.trim();
    }
}
