package conecta.service;

import conecta.jdbc.ConnectionFactory;
import java.sql.*;
import java.util.UUID;

/**
 *
 * @author Sebas
 */
public class RecuperarSenhaService {

    public boolean existeEmail(String email) throws SQLException {
        final String sql = "SELECT 1 FROM USUARIOS WHERE email = ? LIMIT 1";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public String gerarToken(String email) throws SQLException {
        String token = UUID.randomUUID().toString();

        int idUsuario;
        final String busca = "SELECT id_usuario FROM USUARIOS WHERE email = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(busca)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    idUsuario = rs.getInt("id_usuario");
                } else {
                    throw new SQLException("Usuário não encontrado para email " + email);
                }
            }
        }

        final String ins = """
            INSERT INTO RECUPERAR_SENHA (id_usuario, token, data_expiracao, usado)
            VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 MINUTE), false)
        """;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(ins)) {

            ps.setInt(1, idUsuario);
            ps.setString(2, token);
            ps.executeUpdate();
        }

        return token;
    }

    public boolean validarToken(String token) throws SQLException {
        final String sql = """
            SELECT 1 FROM RECUPERAR_SENHA
             WHERE token = ? AND usado = false AND data_expiracao > NOW()
        """;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void atualizarSenha(String token, String novaSenha) throws SQLException {
        final String sql = """
            UPDATE USUARIOS u
            JOIN RECUPERAR_SENHA r ON u.id_usuario = r.id_usuario
               SET u.senha = ?, r.usado = true
             WHERE r.token = ?
        """;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, novaSenha);
            ps.setString(2, token);
            ps.executeUpdate();
        }
    }
}
