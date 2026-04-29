package conecta.service;

import conecta.dao.UsuarioDAO;
import conecta.entidades.Usuario;
import java.sql.SQLException;

/**
 *
 * @author Sebas
 */
public class CadastroProfissionalService {

    private final UsuarioDAO usuarioDAO;

    public CadastroProfissionalService() {
        this.usuarioDAO = new UsuarioDAO();
    }

    public void cadastrarProfissional(Usuario usuario) throws SQLException {
        // força tipo
        usuario.setTipoUsuario("Profissional");

        // validações específicas
        if (usuario.getCpfCnpj() == null || (usuario.getCpfCnpj().length() != 11 && usuario.getCpfCnpj().length() != 14)) {
            throw new IllegalArgumentException("CPF ou CNPJ inválido para Profissional!");
        }

        if (usuarioDAO.emailExiste(usuario.getEmail())) {
            throw new IllegalArgumentException("Email já cadastrado!");
        }

        if (usuarioDAO.cpfCnpjExiste(usuario.getCpfCnpj())) {
            throw new IllegalArgumentException("CPF/CNPJ já cadastrado!");
        }

        usuarioDAO.cadastrar(usuario);
    }
}
