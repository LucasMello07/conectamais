package conecta.dao;

import conecta.entidades.RecuperarSenha;
import conecta.entidades.Usuario;
import conecta.jdbc.ConnectionFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Sebas
 */
public class RecuperarSenhaDAO {

    public void cadastrar(RecuperarSenha rec) throws SQLException {
        String sql = "INSERT INTO RECUPERAR_SENHA (id_usuario, token, data_expiracao, usado) "
                   + "VALUES (?, ?, ?, ?)";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setLong(1, rec.getUsuario().getIdUsuario());
            stmt.setString(2, rec.getToken());
            stmt.setTimestamp(3, new java.sql.Timestamp(rec.getDataExpiracao().getTime()));
            stmt.setBoolean(4, rec.getUsado() != null ? rec.getUsado() : false);
            
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                rec.setIdRecuperacao(rs.getLong(1));
            }
        }
    }

    public RecuperarSenha buscarPorToken(String token) throws SQLException {
        String sql = "SELECT * FROM RECUPERAR_SENHA WHERE token = ?";
        RecuperarSenha rec = null;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                rec = mapResultSetToRecuperarSenha(rs);
            }
        }
        return rec;
    }

    public List<RecuperarSenha> listarPorUsuario(Long idUsuario) throws SQLException {
        String sql = "SELECT * FROM RECUPERAR_SENHA WHERE id_usuario = ?";
        List<RecuperarSenha> recuperacoes = new ArrayList<>();

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, idUsuario);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                recuperacoes.add(mapResultSetToRecuperarSenha(rs));
            }
        }
        return recuperacoes;
    }

    public void marcarComoUsado(Long idRecuperacao) throws SQLException {
        String sql = "UPDATE RECUPERAR_SENHA SET usado = true WHERE id_recuperacao = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, idRecuperacao);
            stmt.executeUpdate();
        }
    }

    public void deletar(Long idRecuperacao) throws SQLException {
        String sql = "DELETE FROM RECUPERAR_SENHA WHERE id_recuperacao = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, idRecuperacao);
            stmt.executeUpdate();
        }
    }

    // Mapper
    private RecuperarSenha mapResultSetToRecuperarSenha(ResultSet rs) throws SQLException {
        RecuperarSenha rec = new RecuperarSenha();
        rec.setIdRecuperacao(rs.getLong("id_recuperacao"));
        rec.setToken(rs.getString("token"));
        rec.setDataExpiracao(rs.getTimestamp("data_expiracao"));
        rec.setUsado(rs.getBoolean("usado"));

        Usuario u = new Usuario();
        u.setIdUsuario(rs.getLong("id_usuario"));
        rec.setUsuario(u);

        return rec;
    }
}
