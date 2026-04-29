package conecta.service;

import conecta.dao.UsuarioDAO;
import conecta.dao.UsuarioDAO.ModeracaoUltima;
import conecta.entidades.Usuario;
import conecta.jdbc.ConnectionFactory;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Regras de login com bloqueio para BANIDO/SUSPENSO e auto-reativação pós-suspensão.
 * Mantém sua assinatura/uso atuais.
 */
public class LoginService {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");

    // Autentica por email + senha. Retorna Usuario ou null se não bater.
    // Se BANIDO/SUSPENSO vigente, lança LoginVioladoException com mensagem amigável.
    public Usuario autenticar(String email, String senha) throws SQLException, LoginVioladoException {
        // buscamos o usuário com o SQL existente (sem status)
        final String sql = """
            SELECT id_usuario, nome_completo, data_nascimento, genero, celular, email, senha,
                   cpf_cnpj, endereco_rua, bairro, cidade, estado, tipo_usuario, status_usuario
              FROM USUARIOS
             WHERE email = ? AND senha = ?
            LIMIT 1
        """;

        Usuario u = null;
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, senha);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = mapearUsuario(rs);
                }
            }
        }

        if (u == null) return null; // email/senha não conferem

        // Lê status_usuario direto do banco
        String status = usuarioDAO.obterStatusUsuario(u.getIdUsuario());
        if (status == null || status.isBlank()) {
            // Se não existir a coluna no banco, não bloqueia (mantém compatibilidade)
            return u;
        }

        if ("BANIDO".equalsIgnoreCase(status)) {
            throw new LoginVioladoException("Usuário banido. Entre em contato com o suporte.");
        }

        if ("SUSPENSO".equalsIgnoreCase(status)) {
            ModeracaoUltima m = usuarioDAO.obterUltimaModeracao(u.getIdUsuario());
            Date hoje = zerarHora(new Date());
            if (m != null && "SUSPENDER".equalsIgnoreCase(m.tipoAcao) && m.fim != null) {
                Date fim = zerarHora(m.fim);
                if (!fim.before(hoje)) {
                    // ainda suspenso
                    throw new LoginVioladoException("Usuário suspenso até " + df.format(fim) + ".");
                }
            } else {
                // sem data fim -> bloqueia por segurança
                throw new LoginVioladoException("Usuário suspenso. Acesse novamente mais tarde.");
            }
        }

        return u;
    }

    // Verifica existência de email (para diferenciar "não cadastrado" de "senha incorreta")
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

    // Opcional: buscar usuário completo apenas pelo email (mantido p/ compatibilidade)
    public Usuario buscarPorEmail(String email) throws SQLException {
        final String sql = """
            SELECT id_usuario, nome_completo, data_nascimento, genero, celular, email, senha,
                   cpf_cnpj, endereco_rua, bairro, cidade, estado, tipo_usuario, status_usuario
              FROM USUARIOS
             WHERE email = ?
             LIMIT 1
        """;
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapearUsuario(rs);
            }
        }
        return null;
    }

    // ====== helpers ======
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getLong("id_usuario"));
        u.setNomeCompleto(rs.getString("nome_completo"));

        java.sql.Date dn = rs.getDate("data_nascimento");
        if (dn != null) u.setDataNascimento(new java.util.Date(dn.getTime()));

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
        u.setStatusUsuario(rs.getString("status_usuario"));
        return u;
    }

    private Date zerarHora(Date d) {
        if (d == null) return null;
        java.util.Calendar c = java.util.Calendar.getInstance();
        c.setTime(d);
        c.set(java.util.Calendar.HOUR_OF_DAY, 0);
        c.set(java.util.Calendar.MINUTE, 0);
        c.set(java.util.Calendar.SECOND, 0);
        c.set(java.util.Calendar.MILLISECOND, 0);
        return c.getTime();
    }


    /** Exceção específica para bloquear login por moderação */
    public static class LoginVioladoException extends Exception {
        public LoginVioladoException(String message) { super(message); }
    }
}
