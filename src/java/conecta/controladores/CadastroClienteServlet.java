package conecta.controladores;

import conecta.entidades.Usuario;
import conecta.service.CadastroClienteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

/**
 *
 * @author Sebas
 */
@WebServlet("/CadastroClienteServlet")
public class CadastroClienteServlet extends HttpServlet {

    private CadastroClienteService cadastroClienteService;

    @Override
    public void init() throws ServletException {
        cadastroClienteService = new CadastroClienteService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuario = new Usuario();
        usuario.setNomeCompleto(request.getParameter("nomeCompleto"));
        usuario.setDataNascimento(Date.valueOf(request.getParameter("dataNascimento")));
        usuario.setGenero(request.getParameter("genero"));
        usuario.setCelular(request.getParameter("celular"));
        usuario.setEmail(request.getParameter("email"));
        usuario.setSenha(request.getParameter("senha"));
        usuario.setCpfCnpj(request.getParameter("cpf")); // campo do form precisa estar "cpf"
        usuario.setEnderecoRua(request.getParameter("enderecoRua"));
        usuario.setBairro(request.getParameter("bairro"));
        usuario.setCidade(request.getParameter("cidade"));
        usuario.setEstado(request.getParameter("estado"));
        usuario.setTipoUsuario("Cliente");

        try {
            cadastroClienteService.cadastrarCliente(usuario);
            request.setAttribute("sucesso", "Cadastro de cliente realizado com sucesso! Faça login.");
            request.getRequestDispatcher("/pages/landing-Page/login.jsp").forward(request, response);
        } catch (IllegalArgumentException | SQLException e) {
            request.setAttribute("erro", e.getMessage());
            request.getRequestDispatcher("/pages/tipo-Cadastro.jsp").forward(request, response);
        }
    }
}
