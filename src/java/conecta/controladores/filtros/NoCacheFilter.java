package conecta.controladores.filtros;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(urlPatterns = { "/*" })
public class NoCacheFilter implements Filter {

    private static boolean isStatic(String uri) {
        return uri.contains("/assets/") || uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png")
                || uri.endsWith(".jpg") || uri.endsWith(".jpeg") || uri.endsWith(".gif") || uri.endsWith(".svg")
                || uri.endsWith(".ico") || uri.contains("/img") || uri.contains("/fonts");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        var req = (jakarta.servlet.http.HttpServletRequest) request;
        var resp = (HttpServletResponse) response;

        // Não aplicar em arquivos estáticos
        if (!isStatic(req.getRequestURI())) {
            resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            resp.setHeader("Pragma", "no-cache");
            resp.setDateHeader("Expires", 0);
        }

        chain.doFilter(request, response);
    }
}
