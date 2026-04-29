package conecta.controladores.filtros;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = "/*", dispatcherTypes = { DispatcherType.REQUEST })
public class AuthFilter implements Filter {
  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {
    HttpServletRequest req  = (HttpServletRequest) request;
    HttpServletResponse resp = (HttpServletResponse) response;

    if (req.getDispatcherType() != DispatcherType.REQUEST) {
      chain.doFilter(request, response);
      return;
    }

    String uri = req.getRequestURI();
    String ctx = req.getContextPath();

    boolean raiz = uri.equals(ctx) || uri.equals(ctx + "/");

    boolean recursoPublico =
        raiz ||
        uri.startsWith(ctx + "/pages/landing-Page/") ||
        uri.startsWith(ctx + "/assets/") ||
        uri.endsWith("/login") ||
        uri.endsWith("/logout") ||
        uri.equals(ctx + "/recuperar-senha") ||
        uri.startsWith(ctx + "/pages/landing-Page/recuperar-senha") ||
        uri.startsWith(ctx + "/pages/landing-Page/nova-senha") ||
        uri.contains("/css") || uri.contains("/js") || uri.contains("/img");

    HttpSession s = req.getSession(false);
    Object logado = (s == null) ? null : s.getAttribute("usuarioLogado");

    if (recursoPublico || logado != null) {
      chain.doFilter(request, response);
    } else {
      resp.sendRedirect(ctx + "/pages/landing-Page/login.jsp");
    }
  }
}
