package conecta.controladores;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 *
 * @author Sebas
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        String ctx = request.getContextPath();
        removeSessionCookie(response, "/");
        if (ctx != null && !ctx.isEmpty()) {
            removeSessionCookie(response, ctx);
        }

        response.sendRedirect(response.encodeRedirectURL(ctx + "/"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private static void removeSessionCookie(HttpServletResponse resp, String path) {
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JSESSIONID", "");
        cookie.setMaxAge(0);
        cookie.setPath((path == null || path.isEmpty()) ? "/" : path);
        cookie.setHttpOnly(true);
        resp.addCookie(cookie);
    }

}
