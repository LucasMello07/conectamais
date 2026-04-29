package conecta.controladores;

import conecta.entidades.Usuario;
import conecta.service.UsuarioService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * /perfil-senha
 *  - GET  -> exibe o formulário de troca de senha
 *  - POST -> valida e atualiza a senha do usuário logado
 *
 * Obs.: Implementação usa senha em texto conforme seu schema atual (USUARIOS.senha).
 *       Futuramente, podemos trocar para hash (BCrypt) sem mexer no fluxo.
 */
@WebServlet("/perfil-senha")
public class TrocarSenhaServlet extends HttpServlet {

    private final UsuarioService usuarioService = new UsuarioService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Usuario logado = (Usuario) req.getSession().getAttribute("usuarioLogado");
        if (logado == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }
        req.getRequestDispatcher("/pages/landing-Page/perfil-trocar-senha.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Usuario logado = (Usuario) req.getSession().getAttribute("usuarioLogado");
        if (logado == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        String senhaAtual = trim(req.getParameter("senha_atual"));
        String novaSenha  = trim(req.getParameter("nova_senha"));
        String confirma   = trim(req.getParameter("confirma_senha"));

        try {
            usuarioService.trocarSenha(logado.getIdUsuario(), senhaAtual, novaSenha, confirma);
            req.getSession().setAttribute("flash", "Senha alterada com sucesso!");
            resp.sendRedirect(req.getContextPath() + "/perfil?acao=ver");
        } catch (IllegalArgumentException e) {
            req.getSession().setAttribute("flashErro", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/perfil-senha");
        } catch (SQLException e) {
            throw new ServletException("Erro ao trocar senha", e);
        }
    }

    private String trim(String s) { return s == null ? null : s.trim(); }
}
