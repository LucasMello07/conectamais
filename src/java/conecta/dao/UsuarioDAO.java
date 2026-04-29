package conecta.dao;

import conecta.entidades.Usuario;
import conecta.jdbc.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author Sebas
 */
public class UsuarioDAO {

    public void cadastrar(Usuario usuario) throws SQLException {
        String sql = """
                INSERT INTO USUARIOS 
                (nome_completo, data_nascimento, genero, celular, email, senha, 
                 cpf_cnpj, endereco_rua, bairro, cidade, estado, tipo_usuario)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, usuario.getNomeCompleto());
            stmt.setDate(2, new java.sql.Date(usuario.getDataNascimento().getTime()));
            stmt.setString(3, usuario.getGenero());
            stmt.setString(4, usuario.getCelular());
            stmt.setString(5, usuario.getEmail());
            stmt.setString(6, usuario.getSenha());
            stmt.setString(7, usuario.getCpfCnpj());
            stmt.setString(8, usuario.getEnderecoRua());
            stmt.setString(9, usuario.getBairro());
            stmt.setString(10, usuario.getCidade());
            stmt.setString(11, usuario.getEstado());
            stmt.setString(12, usuario.getTipoUsuario());

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    usuario.setIdUsuario(rs.getLong(1));
                }
            }
        }
    }

    public Usuario buscarPorId(Long idUsuario) throws SQLException {
        String sql = "SELECT * FROM USUARIOS WHERE id_usuario = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapearUsuario(rs);
            }
        }
        return null;
    }

    public Usuario buscarPorEmail(String email) throws SQLException {
        String sql = "SELECT * FROM USUARIOS WHERE email = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapearUsuario(rs);
            }
        }
        return null;
    }

    public List<Usuario> listarTodos() throws SQLException {
        String sql = "SELECT * FROM USUARIOS";
        List<Usuario> usuarios = new ArrayList<>();
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                usuarios.add(mapearUsuario(rs));
            }
        }
        return usuarios;
    }

    public void atualizar(Usuario usuario) throws SQLException {
        String sql = """
                UPDATE USUARIOS SET 
                    nome_completo=?, data_nascimento=?, genero=?, celular=?, email=?, senha=?, 
                    cpf_cnpj=?, endereco_rua=?, bairro=?, cidade=?, estado=?, tipo_usuario=?
                WHERE id_usuario=?
                """;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNomeCompleto());
            stmt.setDate(2, new java.sql.Date(usuario.getDataNascimento().getTime()));
            stmt.setString(3, usuario.getGenero());
            stmt.setString(4, usuario.getCelular());
            stmt.setString(5, usuario.getEmail());
            stmt.setString(6, usuario.getSenha());
            stmt.setString(7, usuario.getCpfCnpj());
            stmt.setString(8, usuario.getEnderecoRua());
            stmt.setString(9, usuario.getBairro());
            stmt.setString(10, usuario.getCidade());
            stmt.setString(11, usuario.getEstado());
            stmt.setString(12, usuario.getTipoUsuario());
            stmt.setLong(13, usuario.getIdUsuario());

            stmt.executeUpdate();
        }
    }

    public void deletar(Long idUsuario) throws SQLException {
        String sql = "DELETE FROM USUARIOS WHERE id_usuario = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, idUsuario);
            stmt.executeUpdate();
        }
    }

    // Helpers existentes
    public boolean emailExiste(String email) throws SQLException {
        String sql = "SELECT 1 FROM USUARIOS WHERE email = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean cpfCnpjExiste(String cpfCnpj) throws SQLException {
        String sql = "SELECT 1 FROM USUARIOS WHERE cpf_cnpj = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, cpfCnpj);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Busca apenas a senha atual do usuário (texto, conforme seu schema)
    public String buscarSenhaPorId(long idUsuario) throws SQLException {
        final String sql = "SELECT senha FROM USUARIOS WHERE id_usuario = ?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("senha") : null;
            }
        }
    }

    // Atualiza a senha do usuário
    public void atualizarSenha(long idUsuario, String novaSenha) throws SQLException {
        final String sql = "UPDATE USUARIOS SET senha = ? WHERE id_usuario = ?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, novaSenha);
            ps.setLong(2, idUsuario);
            ps.executeUpdate();
        }
    }

    /* =========================
       NOVOS MÉTODOS p/ LOGIN
       ========================= */

    /** Lê status_usuario diretamente do banco (ATIVO|SUSPENSO|BANIDO). */
    public String obterStatusUsuario(long idUsuario) throws SQLException {
        String sql = "SELECT status_usuario FROM USUARIOS WHERE id_usuario = ?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString(1) : null;
            }
        }
    }

    /** Atualiza status_usuario. */
    public void atualizarStatusUsuario(long idUsuario, String novoStatus) throws SQLException {
        String sql = "UPDATE USUARIOS SET status_usuario=? WHERE id_usuario=?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, novoStatus);
            ps.setLong(2, idUsuario);
            ps.executeUpdate();
        }
    }

    /** Última moderação do usuário (para saber fim da suspensão). */
    public ModeracaoUltima obterUltimaModeracao(long idUsuario) throws SQLException {
        String sql = """
            SELECT tipo_acao, inicio, fim
              FROM MODERACOES_DENUNCIAS
             WHERE id_usuario = ?
          ORDER BY inicio DESC
             LIMIT 1
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ModeracaoUltima m = new ModeracaoUltima();
                    m.tipoAcao = rs.getString("tipo_acao"); // SUSPENDER|BANIR|INVALIDAR
                    Timestamp tin = rs.getTimestamp("inicio");
                    if (tin != null) m.inicio = new Date(tin.getTime());
                    Date df = (rs.getDate("fim") != null) ? new Date(rs.getDate("fim").getTime()) : null;
                    m.fim = df;
                    return m;
                }
            }
        }
        return null;
    }

    /** DTO simples p/ última moderação */
    public static class ModeracaoUltima {
        public String tipoAcao;
        public Date inicio;
        public Date fim;
    }

    // Mapper
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getLong("id_usuario"));
        u.setNomeCompleto(rs.getString("nome_completo"));
        u.setDataNascimento(rs.getDate("data_nascimento"));
        u.setGenero(rs.getString("genero"));
        u.setCelular(rs.getString("celular"));
        u.setEmail(rs.getString("email"));
        u.setSenha(rs.getString("senha"));
        u.setCpfCnpj(rs.getString("cpf_cnpj"));
        u.setEnderecoRua(rs.getString("endereco_rua"));
        u.setBairro(rs.getString("bairro"));
        u.setCidade(rs.getString("cidade"));
        u.setEstado(rs.getString("estado"));
        u.setTipoUsuario(rs.getString("tipo_usuario"));
        // se sua entidade tiver setStatusUsuario, podemos popular aqui:
        try {
            String status = rs.getString("status_usuario"); // só terá valor se o SELECT trouxer a coluna
            if (status != null) {
                u.getClass().getMethod("setStatusUsuario", String.class).invoke(u, status);
            }
        } catch (Exception ignore) { /* coluna pode não ter vindo / entidade pode não ter o setter */ }
        return u;
    }
    // UsuarioDAO.java
    public void atualizarStatusUsuario(int idUsuario, String status) throws SQLException {
        final String sql = "UPDATE USUARIOS SET status_usuario=? WHERE id_usuario=?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, idUsuario);
            ps.executeUpdate();
        }
    }
}
