package conecta.dao;

import conecta.dto.ProfissionalBuscaDTO;
import conecta.dto.HabilidadeDTO;
import conecta.entidades.Profissional;
import conecta.entidades.Usuario;
import conecta.jdbc.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Sebas
 */
public class ProfissionalDAO {

    public boolean existsById(long idProf) throws SQLException {
        final String sql = "SELECT 1 FROM PROFISSIONAIS WHERE id_profissional = ? LIMIT 1";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idProf);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    public void createIfNotExists(long idProf) throws SQLException {
        if (existsById(idProf)) return;
        final String sql = """
            INSERT INTO PROFISSIONAIS (id_profissional, endereco_comercial, telefone_comercial)
            VALUES (?, NULL, '00000000000')
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idProf);
            ps.executeUpdate();
        }
    }

    public Profissional buscarPorId(long idProf) throws SQLException {
        final String sql = """
            SELECT p.id_profissional, p.endereco_comercial, p.telefone_comercial,
                   u.id_usuario, u.nome_completo, u.cidade, u.estado, u.email, u.celular
              FROM PROFISSIONAIS p
        INNER JOIN USUARIOS u ON u.id_usuario = p.id_profissional
             WHERE p.id_profissional = ?
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idProf);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                Profissional p = new Profissional();
                p.setIdProfissional(rs.getLong("id_profissional"));
                p.setEnderecoComercial(rs.getString("endereco_comercial"));
                p.setTelefoneComercial(rs.getString("telefone_comercial"));

                Usuario u = new Usuario();
                u.setIdUsuario(rs.getLong("id_usuario"));
                u.setNomeCompleto(rs.getString("nome_completo"));
                u.setCidade(rs.getString("cidade"));
                u.setEstado(rs.getString("estado"));
                u.setEmail(rs.getString("email"));
                u.setCelular(rs.getString("celular"));
                p.setUsuario(u);

                return p;
            }
        }
    }

    /** Método já existente; mantém compatibilidade. */
    public Profissional buscarPorUsuario(long idUsuario) throws SQLException {
        return buscarPorId(idUsuario);
    }

    /** 🔹 Novo: Conveniência com o mesmo nome usado no PerfilServlet. */
    public Profissional buscarPorUsuarioId(long idUsuario) throws SQLException {
        return buscarPorId(idUsuario);
    }

    public List<HabilidadeDTO> listarHabilidadesAtivas(long idProf) throws SQLException {
        final String sql = """
            SELECT id_habilidade, titulo, descricao, status
              FROM HABILIDADES
             WHERE id_profissional = ? AND status = 'Ativo'
             ORDER BY titulo ASC
        """;
        List<HabilidadeDTO> lista = new ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idProf);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HabilidadeDTO h = new HabilidadeDTO();
                    h.setIdHabilidade(rs.getLong("id_habilidade"));
                    h.setTitulo(rs.getString("titulo"));
                    h.setDescricao(rs.getString("descricao"));
                    h.setStatus(rs.getString("status"));
                    lista.add(h);
                }
            }
        }
        return lista;
    }

    public List<ProfissionalBuscaDTO> buscarProfissionaisPlano(String termo, int limit, int offset) throws SQLException {
        final String like = "%" + (termo == null ? "" : termo.trim().replace(' ', '%')) + "%";

        final String sql = """
            SELECT p.id_profissional,
                   u.nome_completo,
                   u.cidade,
                   u.estado,
                   p.telefone_comercial,
                   GROUP_CONCAT(DISTINCT h.titulo ORDER BY h.titulo SEPARATOR '||') AS hb
              FROM PROFISSIONAIS p
        INNER JOIN USUARIOS u ON u.id_usuario = p.id_profissional
          LEFT JOIN HABILIDADES h ON h.id_profissional = p.id_profissional
             WHERE u.nome_completo   LIKE ?
                OR u.cidade          LIKE ?
                OR u.estado          LIKE ?
                OR h.titulo          LIKE ?
                OR h.descricao       LIKE ?
          GROUP BY p.id_profissional, u.nome_completo, u.cidade, u.estado, p.telefone_comercial
          ORDER BY u.nome_completo ASC
             LIMIT ? OFFSET ?
        """;

        List<ProfissionalBuscaDTO> out = new ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setString(5, like);
            ps.setInt(6, Math.max(1, limit));
            ps.setInt(7, Math.max(0, offset));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProfissionalBuscaDTO dto = new ProfissionalBuscaDTO();
                    dto.setIdProfissional(rs.getLong("id_profissional"));
                    dto.setNomeCompleto(rs.getString("nome_completo"));
                    dto.setCidade(rs.getString("cidade"));
                    dto.setEstado(rs.getString("estado"));
                    dto.setTelefoneComercial(rs.getString("telefone_comercial"));
                    dto.setHabilidadesCsv(rs.getString("hb"));
                    out.add(dto);
                }
            }
        }
        return out;
    }

    public int contarProfissionaisPlano(String termo) throws SQLException {
        final String like = "%" + (termo == null ? "" : termo.trim().replace(' ', '%')) + "%";

        final String sql = """
            SELECT COUNT(DISTINCT p.id_profissional)
              FROM PROFISSIONAIS p
        INNER JOIN USUARIOS u ON u.id_usuario = p.id_profissional
          LEFT JOIN HABILIDADES h ON h.id_profissional = p.id_profissional
             WHERE u.nome_completo   LIKE ?
                OR u.cidade          LIKE ?
                OR u.estado          LIKE ?
                OR h.titulo          LIKE ?
                OR h.descricao       LIKE ?
        """;

        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setString(5, like);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}
