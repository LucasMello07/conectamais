package conecta.controladores;

import conecta.service.RecuperarSenhaService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 *
 * @author Sebas
 */
@WebServlet("/nova-senha")
public class NovaSenhaServlet extends HttpServlet {

    private RecuperarSenhaService recuperarSenhaService;

    @Override
    public void init() throws ServletException {
        recuperarSenhaService = new RecuperarSenhaService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");

        if (token == null || token.isBlank()) {
            request.setAttribute("erro", "Token inválido!");
            request.getRequestDispatcher("/pages/landing-Page/nova-senha.jsp").forward(request, response);
            return;
        }

        if (senha == null || confirmarSenha == null || !senha.equals(confirmarSenha)) {
            request.setAttribute("erro", "As senhas não coincidem!");
            request.setAttribute("token", token); // mantém o token
            request.getRequestDispatcher("/pages/landing-Page/nova-senha.jsp").forward(request, response);
            return;
        }

        try {
            boolean valido = recuperarSenhaService.validarToken(token);

            if (!valido) {
                request.setAttribute("erro", "Token inválido ou expirado!");
                request.getRequestDispatcher("/pages/landing-Page/nova-senha.jsp").forward(request, response);
                return;
            }

            // Atualiza a senha e marca o token como usado
            recuperarSenhaService.atualizarSenha(token, senha);

            request.setAttribute("mensagem", "Senha alterada com sucesso! Faça login.");
            request.getRequestDispatcher("/pages/landing-Page/login.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Erro ao redefinir senha", e);
        }
    }
}
