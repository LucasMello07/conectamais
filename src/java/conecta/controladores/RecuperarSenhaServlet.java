package conecta.controladores;

import conecta.service.RecuperarSenhaService;
import conecta.service.EmailServiceSendGrid;
import conecta.service.EmailTemplates;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

@WebServlet("/recuperar-senha")
public class RecuperarSenhaServlet extends HttpServlet {

    private RecuperarSenhaService recuperarSenhaService;

    @Override
    public void init() throws ServletException {
        recuperarSenhaService = new RecuperarSenhaService();
        // Log útil para confirmar o JDK que o servidor está usando
        System.out.println("java.home = " + System.getProperty("java.home"));
    }

    // GET: mostra os formulários (com ou sem token)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        if (token != null && !token.isBlank()) {
            try {
                boolean valido = recuperarSenhaService.validarToken(token);
                if (!valido) {
                    request.setAttribute("erro", "Link inválido ou expirado.");
                    request.getRequestDispatcher("/pages/landing-Page/recuperar-senha.jsp")
                           .forward(request, response);
                    return;
                }
                // Encaminha para o formulário de nova senha com o token disponível no request
                request.setAttribute("token", token);
                request.getRequestDispatcher("/pages/landing-Page/nova-senha.jsp")
                       .forward(request, response);
                return;
            } catch (SQLException e) {
                throw new ServletException("Erro ao validar token", e);
            }
        }

        // Sem token → tela de solicitar recuperação
        request.getRequestDispatcher("/pages/landing-Page/recuperar-senha.jsp")
               .forward(request, response);
    }

    // POST: trata envio de e-mail OU definição de nova senha
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding(StandardCharsets.UTF_8.name());

        // 1) Fluxo de DEFINIR NOVA SENHA (token + senha)
        String tokenParam = request.getParameter("token");
        if (tokenParam != null && !tokenParam.isEmpty()) {
            String senha = request.getParameter("senha");
            String confirmar = request.getParameter("confirmarSenha");

            if (senha == null || confirmar == null || !senha.equals(confirmar)) {
                request.setAttribute("erro", "As senhas não conferem.");
                request.setAttribute("token", tokenParam);
                request.getRequestDispatcher("/pages/landing-Page/nova-senha.jsp")
                       .forward(request, response);
                return;
            }

            try {
                boolean valido = recuperarSenhaService.validarToken(tokenParam);
                if (!valido) {
                    request.setAttribute("erro", "Link inválido ou expirado.");
                    request.getRequestDispatcher("/pages/landing-Page/recuperar-senha.jsp")
                           .forward(request, response);
                    return;
                }

                recuperarSenhaService.atualizarSenha(tokenParam, senha); // ideal: invalidar token dentro desse método

                request.setAttribute("mensagem", "Senha alterada com sucesso. Faça login novamente.");
                request.getRequestDispatcher("/pages/landing-Page/login.jsp")
                       .forward(request, response);
                return;

            } catch (SQLException e) {
                throw new ServletException("Erro ao definir nova senha", e);
            }
        }

        // 2) Fluxo de SOLICITAR RECUPERAÇÃO (quando recebe e-mail)
        String email = request.getParameter("email");
        if (email == null || email.isBlank()) {
            request.setAttribute("erro", "Informe um e-mail válido.");
            request.getRequestDispatcher("/pages/landing-Page/recuperar-senha.jsp")
                   .forward(request, response);
            return;
        }

        try {
            boolean existe = recuperarSenhaService.existeEmail(email);
            if (!existe) {
                request.setAttribute("erro", "E-mail não cadastrado. Deseja criar uma conta?");
                request.getRequestDispatcher("/pages/landing-Page/recuperar-senha.jsp")
                       .forward(request, response);
                return;
            }

            String token = recuperarSenhaService.gerarToken(email);

            String baseUrl = resolveBaseUrl(request); // ex.: http://localhost:8080/CONECTA
            String link = baseUrl + "/recuperar-senha?token=" +
                    URLEncoder.encode(token, StandardCharsets.UTF_8.name());

            String html = EmailTemplates.resetPassword(null, link);

            EmailServiceSendGrid mailer = new EmailServiceSendGrid();
            boolean ok = mailer.enviarEmail(email, "Conecta+ • Redefinir senha", html);

            request.setAttribute(ok ? "mensagem" : "erro",
                ok ? "Enviamos um link de recuperação para o seu e-mail."
                   : "Não foi possível enviar o e-mail agora. Tente novamente em instantes.");

            request.getRequestDispatcher("/pages/landing-Page/recuperar-senha.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Erro ao recuperar senha", e);
        }
    }

    // Base URL absoluta para os links do e-mail
    private String resolveBaseUrl(HttpServletRequest request) {
        String fromProp = System.getProperty("APP_BASE_URL");
        String fromEnv  = System.getenv("APP_BASE_URL");
        String base = (fromProp != null && !fromProp.isBlank()) ? fromProp : fromEnv;
        if (base != null && !base.isBlank()) return trimTrailingSlash(base);

        String scheme = request.getScheme(); // http/https
        String server = request.getServerName();
        int port = request.getServerPort();
        String ctx = request.getContextPath();
        boolean isDefaultHttp = "http".equalsIgnoreCase(scheme) && port == 80;
        boolean isDefaultHttps = "https".equalsIgnoreCase(scheme) && port == 443;
        String portPart = (isDefaultHttp || isDefaultHttps) ? "" : (":" + port);
        return scheme + "://" + server + portPart + (ctx == null ? "" : ctx);
    }

    private String trimTrailingSlash(String s) {
        if (s == null) return "";
        return s.endsWith("/") ? s.substring(0, s.length() - 1) : s;
    }
}
