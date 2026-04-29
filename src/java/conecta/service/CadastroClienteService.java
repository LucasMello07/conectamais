package conecta.service;

import conecta.dao.UsuarioDAO;
import conecta.entidades.Usuario;
import java.sql.SQLException;

/**
 *
 * @author Sebas
 */
public class CadastroClienteService {

    private final UsuarioDAO usuarioDAO;

    public CadastroClienteService() {
        this.usuarioDAO = new UsuarioDAO();
    }

    public void cadastrarCliente(Usuario usuario) throws SQLException {
        // força tipo
        usuario.setTipoUsuario("Cliente");

        // validações específicas
        if (usuario.getCpfCnpj() == null || usuario.getCpfCnpj().length() != 11) {
            throw new IllegalArgumentException("CPF inválido para Cliente!");
        }

        if (usuarioDAO.emailExiste(usuario.getEmail())) {
            throw new IllegalArgumentException("Email já cadastrado!");
        }

        if (usuarioDAO.cpfCnpjExiste(usuario.getCpfCnpj())) {
            throw new IllegalArgumentException("CPF já cadastrado!");
        }

        usuarioDAO.cadastrar(usuario);
    }
}
