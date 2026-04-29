package conecta.controladores;

import conecta.dto.ModeracaoUsuarioDTO;
import conecta.entidades.Usuario;
import conecta.service.ModeracaoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/usuarios")
public class ModeracaoServlet extends HttpServlet {

    private final ModeracaoService service = new ModeracaoService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Usuario u = (Usuario) req.getSession().getAttribute("usuarioLogado");
        if (u == null || !"Administrador".equalsIgnoreCase(u.getTipoUsuario())) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        try {
            List<ModeracaoUsuarioDTO> moderacoes = service.listarUsuariosModerados();
            req.setAttribute("moderacoes", moderacoes);
            req.setAttribute("qtdSuspensos", service.contarSuspensos());
            req.setAttribute("qtdBanidos", service.contarBanidos());
            req.setAttribute("qtdInvalidas", service.contarInvalidas()); // contar em DENUNCIAS (status INVALIDADA), conforme seu DAO/Service
            req.getRequestDispatcher("/pages/dashboard-Administrador/listagem-USUARIOS-ADM.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Usuario u = (Usuario) req.getSession().getAttribute("usuarioLogado");
        if (u == null || !"Administrador".equalsIgnoreCase(u.getTipoUsuario())) {
            resp.sendRedirect(req.getContextPath() + "/pages/landing-Page/index.jsp");
            return;
        }

        String acao = req.getParameter("acao");
        try {
            if ("desbloquear".equalsIgnoreCase(acao)) {
                int idUsuario;
                try {
                    idUsuario = Integer.parseInt(req.getParameter("id"));
                } catch (Exception ex) {
                    resp.sendRedirect(req.getContextPath() + "/usuarios?err=ID%20inv%C3%A1lido");
                    return;
                }
                service.desbloquearUsuario(idUsuario);
                resp.sendRedirect(req.getContextPath() + "/usuarios?ok=1");
                return;
            }
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
