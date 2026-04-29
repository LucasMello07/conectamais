package conecta.dao;

import conecta.entidades.Habilidade;
import conecta.jdbc.ConnectionFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HabilidadeDAO {

    public void inserir(Habilidade h) throws SQLException {
        String sql = "INSERT INTO HABILIDADES (titulo, descricao, status, id_profissional) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getTitulo());
            ps.setString(2, h.getDescricao());
            ps.setString(3, h.getStatus());
            ps.setInt(4, h.getIdProfissional());
            ps.executeUpdate();
        }
    }

    public void atualizar(Habilidade h) throws SQLException {
        String sql = "UPDATE HABILIDADES SET titulo=?, descricao=?, status=? WHERE id_habilidade=?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getTitulo());
            ps.setString(2, h.getDescricao());
            ps.setString(3, h.getStatus());
            ps.setInt(4, h.getIdHabilidade());
            ps.executeUpdate();
        }
    }

    public void excluir(int idHabilidade) throws SQLException {
        String sql = "DELETE FROM HABILIDADES WHERE id_habilidade=?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idHabilidade);
            ps.executeUpdate();
        }
    }

    public Habilidade buscarPorId(int id) throws SQLException {
        String sql = """
            SELECT h.id_habilidade, h.titulo, h.descricao, h.status, h.id_profissional,
                   u.nome_completo AS nome_profissional
            FROM HABILIDADES h
            JOIN PROFISSIONAIS p ON p.id_profissional = h.id_profissional
            JOIN USUARIOS u ON u.id_usuario = p.id_profissional
            WHERE h.id_habilidade = ?
        """;
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public List<Habilidade> listarPorProfissional(int idProfissional) throws SQLException {
        String sql = """
            SELECT h.id_habilidade, h.titulo, h.descricao, h.status, h.id_profissional,
                   u.nome_completo AS nome_profissional
            FROM HABILIDADES h
            JOIN PROFISSIONAIS p ON p.id_profissional = h.id_profissional
            JOIN USUARIOS u ON u.id_usuario = p.id_profissional
            WHERE h.id_profissional = ?
            ORDER BY h.id_habilidade DESC
        """;
        List<Habilidade> lista = new ArrayList<>();
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idProfissional);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(map(rs));
            }
        }
        return lista;
    }

    /** Somente status = 'Ativo' (case-insensitive) */
    public List<Habilidade> listarAtivasPorProfissional(int idProfissional) throws SQLException {
        String sql = """
            SELECT h.id_habilidade, h.titulo, h.descricao, h.status, h.id_profissional,
                   u.nome_completo AS nome_profissional
              FROM HABILIDADES h
              JOIN PROFISSIONAIS p ON p.id_profissional = h.id_profissional
              JOIN USUARIOS u ON u.id_usuario = p.id_profissional
             WHERE h.id_profissional = ?
               AND TRIM(UPPER(h.status)) = 'ATIVO'
             ORDER BY h.titulo ASC
        """;
        List<Habilidade> lista = new ArrayList<>();
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idProfissional);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(map(rs));
            }
        }
        return lista;
    }

    private Habilidade map(ResultSet rs) throws SQLException {
        Habilidade h = new Habilidade();
        h.setIdHabilidade(rs.getInt("id_habilidade"));
        h.setTitulo(rs.getString("titulo"));
        h.setDescricao(rs.getString("descricao"));
        h.setStatus(rs.getString("status"));
        h.setIdProfissional(rs.getInt("id_profissional"));
        h.setNomeProfissional(rs.getString("nome_profissional"));
        return h;
    }
}
