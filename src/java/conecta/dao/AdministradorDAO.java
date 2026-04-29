package conecta.dao;

import conecta.entidades.Administrador;
import conecta.entidades.Usuario;
import conecta.jdbc.ConnectionFactory;
import java.sql.*;

/**
 *
 * @author Sebas
 */
public class AdministradorDAO {

    public void cadastrar(Administrador admin) throws SQLException {
        String sql = "INSERT INTO ADMINISTRADOR (id_admin) VALUES (?)";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, admin.getUsuario().getIdUsuario());
            stmt.executeUpdate();
        }
    }

    public Administrador buscarPorId(Long idAdmin) throws SQLException {
        String sql = "SELECT * FROM ADMINISTRADOR a "
                   + "INNER JOIN USUARIOS u ON a.id_admin = u.id_usuario "
                   + "WHERE a.id_admin = ?";
        
        Administrador admin = null;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, idAdmin);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                admin = new Administrador();
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getLong("id_usuario"));
                usuario.setNomeCompleto(rs.getString("nome_completo"));
                usuario.setDataNascimento(rs.getDate("data_nascimento"));
                usuario.setGenero(rs.getString("genero"));
                usuario.setCelular(rs.getString("celular"));
                usuario.setEmail(rs.getString("email"));
                usuario.setSenha(rs.getString("senha"));
                usuario.setCpfCnpj(rs.getString("cpf_cnpj"));
                usuario.setEnderecoRua(rs.getString("endereco_rua"));
                usuario.setBairro(rs.getString("bairro"));
                usuario.setCidade(rs.getString("cidade"));
                usuario.setEstado(rs.getString("estado"));
                usuario.setTipoUsuario(rs.getString("tipo_usuario"));

                admin.setIdAdmin(rs.getLong("id_admin"));
                admin.setUsuario(usuario);
            }
        }
        return admin;
    }
}
