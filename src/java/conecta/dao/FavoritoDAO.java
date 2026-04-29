package conecta.dao;

import conecta.entidades.Favorito;
import conecta.entidades.Cliente;
import conecta.entidades.Profissional;
import conecta.entidades.Usuario;
import conecta.jdbc.ConnectionFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Sebas
 */
public class FavoritoDAO {

    public void cadastrar(Favorito favorito) throws SQLException {
        final String sql = """
            INSERT INTO FAVORITOS (id_cliente, id_profissional, data_favorito)
            VALUES (?, ?, ?)
        """;

        try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, favorito.getCliente().getIdCliente());
            stmt.setLong(2, favorito.getProfissional().getIdProfissional());
            stmt.setTimestamp(3, favorito.getDataFavorito() != null
                    ? new Timestamp(favorito.getDataFavorito().getTime())
                    : new Timestamp(System.currentTimeMillis()));

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    favorito.setIdFavorito(rs.getLong(1));
                }
            }
        }
    }

    public boolean isFavorito(long idCliente, long idProfissional) throws SQLException {
        final String sql = "SELECT 1 FROM FAVORITOS WHERE id_cliente = ? AND id_profissional = ? LIMIT 1";
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idCliente);
            ps.setLong(2, idProfissional);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public Favorito buscarPorId(Long idFavorito) throws SQLException {
        String sql = "SELECT * FROM FAVORITOS WHERE id_favorito = ?";
        Favorito favorito = null;

        try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, idFavorito);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    favorito = mapResultSetToFavorito(rs);
                }
            }
        }
        return favorito;
    }

    public List<Favorito> listarPorCliente(Long idCliente) throws SQLException {
        String sql = "SELECT * FROM FAVORITOS WHERE id_cliente = ? ORDER BY data_favorito DESC";
        List<Favorito> favoritos = new ArrayList<>();

        try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, idCliente);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    favoritos.add(mapResultSetToFavorito(rs));
                }
            }
        }
        return favoritos;
    }

    public List<Favorito> listarPorClienteDetalhado(long idCliente, String termo) throws SQLException {
        String base = """
            SELECT
                f.id_favorito,
                f.id_cliente,
                f.id_profissional,
                f.data_favorito,
                u.nome_completo AS nome_profissional,
                u.cidade,
                u.estado,
                p.telefone_comercial
            FROM FAVORITOS f
            JOIN PROFISSIONAIS p ON p.id_profissional = f.id_profissional
            JOIN USUARIOS u      ON u.id_usuario = p.id_profissional
            WHERE f.id_cliente = ?
        """;

        String filtro = (termo != null && !termo.isBlank())
                ? " AND (u.nome_completo LIKE ? OR u.cidade LIKE ?) "
                : "";

        String order = " ORDER BY f.data_favorito DESC";

        String sql = base + filtro + order;

        List<Favorito> lista = new ArrayList<>();

        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setLong(1, idCliente);
            if (!filtro.isBlank()) {
                String like = "%" + termo.trim() + "%";
                ps.setString(2, like);
                ps.setString(3, like);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Favorito f = new Favorito();
                    f.setIdFavorito(rs.getLong("id_favorito"));
                    f.setDataFavorito(rs.getTimestamp("data_favorito"));

                    Cliente cli = new Cliente();
                    cli.setIdCliente(rs.getLong("id_cliente"));
                    f.setCliente(cli);

                    Profissional p = new Profissional();
                    p.setIdProfissional(rs.getLong("id_profissional"));
                    p.setTelefoneComercial(rs.getString("telefone_comercial"));

                    Usuario u = new Usuario();
                    u.setIdUsuario(rs.getLong("id_profissional"));
                    u.setNomeCompleto(rs.getString("nome_profissional"));
                    u.setCidade(rs.getString("cidade"));
                    u.setEstado(rs.getString("estado"));
                    p.setUsuario(u);

                    f.setProfissional(p);

                    lista.add(f);
                }
            }
        }
        return lista;
    }

    public void deletar(Long idFavorito) throws SQLException {
        String sql = "DELETE FROM FAVORITOS WHERE id_favorito = ?";
        try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, idFavorito);
            stmt.executeUpdate();
        }
    }

    public void removerPorClienteEProfissional(long idCliente, long idProfissional) throws SQLException {
        final String sql = "DELETE FROM FAVORITOS WHERE id_cliente = ? AND id_profissional = ?";
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idCliente);
            ps.setLong(2, idProfissional);
            ps.executeUpdate();
        }
    }

    public int contarFavoritadoresDoProfissional(long idProfissional) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM FAVORITOS WHERE id_profissional = ?";
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idProfissional);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public List<Long> buscarIdsFavoritos(long idCliente) throws SQLException {
        final String sql = "SELECT id_profissional FROM FAVORITOS WHERE id_cliente = ?";
        java.util.List<Long> ids = new java.util.ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getLong(1));
                }
            }
        }
        return ids;
    }

    // mappers
    private Favorito mapResultSetToFavorito(ResultSet rs) throws SQLException {
        Favorito f = new Favorito();
        f.setIdFavorito(rs.getLong("id_favorito"));
        f.setDataFavorito(rs.getTimestamp("data_favorito"));

        Cliente c = new Cliente();
        c.setIdCliente(rs.getLong("id_cliente"));
        f.setCliente(c);

        Profissional p = new Profissional();
        p.setIdProfissional(rs.getLong("id_profissional"));
        f.setProfissional(p);

        return f;
    }
}
