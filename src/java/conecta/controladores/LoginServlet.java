package conecta.controladores;

import conecta.entidades.Usuario;
import conecta.service.LoginService;
import conecta.service.LoginService.LoginVioladoException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private LoginService loginService;

    @Override
    public void init() throws ServletException {
        loginService = new LoginService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        try {
            Usuario usuario;
            try {
                usuario = loginService.autenticar(email, senha);
            } catch (LoginVioladoException bloqueado) {
                request.setAttribute("erro", bloqueado.getMessage());
                request.getRequestDispatcher("/pages/landing-Page/login.jsp").forward(request, response);
                return;
            }

            if (usuario == null) {
                boolean existeEmail = loginService.existeEmail(email);
                request.setAttribute("erro", existeEmail ? "Senha incorreta!" : "Usuário não cadastrado!");
                request.getRequestDispatcher("/pages/landing-Page/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioLogado", usuario);

            if ("Cliente".equalsIgnoreCase(usuario.getTipoUsuario())) {
                response.sendRedirect(request.getContextPath() + "/agendamentos?acao=listarCliente");
            } else if ("Profissional".equalsIgnoreCase(usuario.getTipoUsuario())) {
                response.sendRedirect(request.getContextPath() + "/agendamentos?acao=listarProfissional");
            } else if ("Administrador".equalsIgnoreCase(usuario.getTipoUsuario())) {
                response.sendRedirect(request.getContextPath() + "/denuncias?acao=listar");
            } else {
                request.setAttribute("erro", "Perfil de usuário desconhecido.");
                request.getRequestDispatcher("/pages/landing-Page/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Erro no login", e);
        }
    }
}
