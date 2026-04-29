package conecta.dao;

import conecta.entidades.*;
import conecta.jdbc.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO de Avaliação
 *
 * @author Sebas
 */
public class AvaliacaoDAO {

    /* ========================= CRUD ========================= */

    public Long cadastrar(Avaliacao a) throws SQLException {
        final String sql = """
            INSERT INTO AVALIACOES
              (id_cliente, id_profissional, id_agendamento, nota, comentario_avaliacao, data_avaliacao)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, a.getCliente().getIdCliente());
            ps.setLong(2, a.getProfissional().getIdProfissional());
            ps.setLong(3, a.getAgendamento().getIdAgendamento());
            ps.setString(4, a.getNota());
            ps.setString(5, a.getComentarioAvaliacao());
            ps.setDate(6, new java.sql.Date(a.getDataAvaliacao().getTime()));
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : null;
            }
        }
    }

    public void atualizar(Avaliacao a) throws SQLException {
        final String sql = """
            UPDATE AVALIACOES
               SET nota = ?,
                   comentario_avaliacao = ?,
                   data_avaliacao = ?
             WHERE id_avaliacao = ? AND id_cliente = ?
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, a.getNota());
            ps.setString(2, a.getComentarioAvaliacao());
            ps.setDate(3, new java.sql.Date(a.getDataAvaliacao().getTime()));
            ps.setLong(4, a.getIdAvaliacao());
            ps.setLong(5, a.getCliente().getIdCliente());
            ps.executeUpdate();
        }
    }

    public void deletar(long idAvaliacao, long idCliente) throws SQLException {
        final String sql = "DELETE FROM AVALIACOES WHERE id_avaliacao = ? AND id_cliente = ?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idAvaliacao);
            ps.setLong(2, idCliente);
            ps.executeUpdate();
        }
    }

    /* ========================= EXISTS/HELPERS ========================= */

    public boolean jaExistePorAgendamento(long idAgendamento) throws SQLException {
        final String sql = "SELECT 1 FROM AVALIACOES WHERE id_agendamento = ? LIMIT 1";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idAgendamento);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Verificação por agendamento e cliente (evita duplicidade do mesmo cliente). */
    public boolean existePorAgendamentoCliente(long idAgendamento, long idCliente) throws SQLException {
        final String sql = "SELECT 1 FROM AVALIACOES WHERE id_agendamento = ? AND id_cliente = ? LIMIT 1";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idAgendamento);
            ps.setLong(2, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** NOVO: retorna o id_avaliacao para highlight, dado agendamento + cliente. */
    public Long buscarIdPorAgendamentoCliente(long idAgendamento, long idCliente) throws SQLException {
        final String sql = "SELECT id_avaliacao FROM AVALIACOES WHERE id_agendamento = ? AND id_cliente = ? LIMIT 1";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idAgendamento);
            ps.setLong(2, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : null;
            }
        }
    }

    /** OPCIONAL: busca a avaliação completa por agendamento + cliente. */
    public Avaliacao buscarPorAgendamentoCliente(long idAgendamento, long idCliente) throws SQLException {
        final String sql = """
            SELECT
                a.id_avaliacao             AS id_avaliacao,
                a.id_cliente               AS id_cliente,
                a.id_profissional          AS id_profissional,
                a.id_agendamento           AS id_agendamento,
                a.nota                     AS nota,
                a.comentario_avaliacao    AS comentario_avaliacao,
                a.data_avaliacao           AS data_avaliacao,
                ucli.nome_completo  AS cliente_nome,
                uprof.nome_completo AS profissional_nome,
                ag.data_agendamento AS ag_data
            FROM AVALIACOES a
            LEFT JOIN CLIENTES      cli   ON cli.id_cliente       = a.id_cliente
            LEFT JOIN PROFISSIONAIS prof  ON prof.id_profissional = a.id_profissional
            LEFT JOIN USUARIOS      ucli  ON ucli.id_usuario      = cli.id_cliente
            LEFT JOIN USUARIOS      uprof ON uprof.id_usuario     = prof.id_profissional
            LEFT JOIN AGENDAMENTOS  ag    ON ag.id_agendamento    = a.id_agendamento
            WHERE a.id_agendamento = ? AND a.id_cliente = ?
            LIMIT 1
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idAgendamento);
            ps.setLong(2, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    /* ========================= GETS ========================= */

    public Avaliacao buscarPorId(long id) throws SQLException {
        final String sql = """
            SELECT
                a.id_avaliacao             AS id_avaliacao,
                a.id_cliente               AS id_cliente,
                a.id_profissional          AS id_profissional,
                a.id_agendamento           AS id_agendamento,
                a.nota                     AS nota,
                a.comentario_avaliacao    AS comentario_avaliacao,
                a.data_avaliacao           AS data_avaliacao,
                ucli.nome_completo  AS cliente_nome,
                uprof.nome_completo AS profissional_nome,
                ag.data_agendamento AS ag_data
            FROM AVALIACOES a
            LEFT JOIN CLIENTES      cli   ON cli.id_cliente       = a.id_cliente
            LEFT JOIN PROFISSIONAIS prof  ON prof.id_profissional = a.id_profissional
            LEFT JOIN USUARIOS      ucli  ON ucli.id_usuario      = cli.id_cliente
            LEFT JOIN USUARIOS      uprof ON uprof.id_usuario     = prof.id_profissional
            LEFT JOIN AGENDAMENTOS  ag    ON ag.id_agendamento    = a.id_agendamento
            WHERE a.id_avaliacao = ?
            LIMIT 1
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public Avaliacao buscarPorAgendamento(long idAgendamento) throws SQLException {
        final String sql = """
            SELECT
                a.id_avaliacao             AS id_avaliacao,
                a.id_cliente               AS id_cliente,
                a.id_profissional          AS id_profissional,
                a.id_agendamento           AS id_agendamento,
                a.nota                     AS nota,
                a.comentario_avaliacao    AS comentario_avaliacao,
                a.data_avaliacao           AS data_avaliacao,
                ucli.nome_completo  AS cliente_nome,
                uprof.nome_completo AS profissional_nome,
                ag.data_agendamento AS ag_data
            FROM AVALIACOES a
            LEFT JOIN CLIENTES      cli   ON cli.id_cliente       = a.id_cliente
            LEFT JOIN PROFISSIONAIS prof  ON prof.id_profissional = a.id_profissional
            LEFT JOIN USUARIOS      ucli  ON ucli.id_usuario      = cli.id_cliente
            LEFT JOIN USUARIOS      uprof ON uprof.id_usuario     = prof.id_profissional
            LEFT JOIN AGENDAMENTOS  ag    ON ag.id_agendamento    = a.id_agendamento
            WHERE a.id_agendamento = ?
            LIMIT 1
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idAgendamento);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<Avaliacao> listarPorClienteDetalhado(long idCliente) throws SQLException {
        final String sql = """
            SELECT
                a.id_avaliacao             AS id_avaliacao,
                a.id_cliente               AS id_cliente,
                a.id_profissional          AS id_profissional,
                a.id_agendamento           AS id_agendamento,
                a.nota                     AS nota,
                a.comentario_avaliacao    AS comentario_avaliacao,
                a.data_avaliacao           AS data_avaliacao,
                uprof.nome_completo        AS profissional_nome,
                ag.data_agendamento        AS ag_data
            FROM AVALIACOES a
            INNER JOIN PROFISSIONAIS prof  ON prof.id_profissional = a.id_profissional
            INNER JOIN USUARIOS      uprof ON uprof.id_usuario     = prof.id_profissional
            LEFT JOIN AGENDAMENTOS   ag    ON ag.id_agendamento    = a.id_agendamento
            WHERE a.id_cliente = ?
            ORDER BY a.data_avaliacao DESC
        """;

        List<Avaliacao> list = new ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public List<Avaliacao> listarRecebidasPorProfissional(long idProf) throws SQLException {
        final String sql = """
            SELECT
                a.id_avaliacao             AS id_avaliacao,
                a.id_cliente               AS id_cliente,
                a.id_profissional          AS id_profissional,
                a.id_agendamento           AS id_agendamento,
                a.nota                     AS nota,
                a.comentario_avaliacao    AS comentario_avaliacao,
                a.data_avaliacao           AS data_avaliacao,
                ucli.nome_completo         AS cliente_nome,
                ag.data_agendamento        AS ag_data
            FROM AVALIACOES a
            INNER JOIN CLIENTES  c    ON c.id_cliente     = a.id_cliente
            INNER JOIN USUARIOS  ucli ON ucli.id_usuario  = c.id_cliente
            LEFT JOIN AGENDAMENTOS ag ON ag.id_agendamento = a.id_agendamento
            WHERE a.id_profissional = ?
            ORDER BY a.data_avaliacao DESC
        """;

        List<Avaliacao> list = new ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idProf);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    /* ========================= MAPPER ========================= */

    private Avaliacao map(ResultSet rs) throws SQLException {
        Avaliacao a = new Avaliacao();

        a.setIdAvaliacao(getLongSafe(rs, "id_avaliacao"));
        a.setNota(getStringSafe(rs, "nota"));

        String comentario = getStringSafe(rs, "comentario_avaliacao");
        if (comentario == null) comentario = getStringSafe(rs, "comentario_avaliacao");
        a.setComentarioAvaliacao(comentario);

        java.util.Date dtAv = getDateSafe(rs, "data_avaliacao");
        if (dtAv == null) dtAv = getDateSafe(rs, "data_av"); // compat
        if (dtAv != null) a.setDataAvaliacao(dtAv);

        Cliente cl = new Cliente();
        Long idCli = getLongSafe(rs, "id_cliente");
        if (idCli != null) cl.setIdCliente(idCli);
        String nomeCli = getStringSafe(rs, "cliente_nome");
        if (nomeCli != null) {
            Usuario u = new Usuario();
            u.setIdUsuario(idCli);
            u.setNomeCompleto(nomeCli);
            cl.setUsuario(u);
        }
        a.setCliente(cl);

        Profissional pr = new Profissional();
        Long idPr = getLongSafe(rs, "id_profissional");
        if (idPr != null) pr.setIdProfissional(idPr);
        String nomePr = getStringSafe(rs, "profissional_nome");
        if (nomePr != null) {
            Usuario u = new Usuario();
            u.setIdUsuario(idPr);
            u.setNomeCompleto(nomePr);
            pr.setUsuario(u);
        }
        a.setProfissional(pr);

        Agendamento ag = new Agendamento();
        Long idAg = getLongSafe(rs, "id_agendamento");
        if (idAg != null) ag.setIdAgendamento(idAg);

        // NOVO: se a consulta trouxe a data do agendamento como ag_data, preenche no objeto
        java.util.Date dtAg = getDateSafe(rs, "ag_data");
        if (dtAg != null) {
            ag.setDataAgendamento(new java.sql.Date(dtAg.getTime()));
        }
        a.setAgendamento(ag);

        return a;
    }

    /* ========================= UTILS ========================= */

    private boolean hasColumn(ResultSet rs, String label) {
        try {
            rs.findColumn(label);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    private String getStringSafe(ResultSet rs, String label) {
        try {
            if (!hasColumn(rs, label)) return null;
            return rs.getString(label);
        } catch (SQLException e) {
            return null;
        }
    }

    private Long getLongSafe(ResultSet rs, String label) {
        try {
            if (!hasColumn(rs, label)) return null;
            long v = rs.getLong(label);
            return rs.wasNull() ? null : v;
        } catch (SQLException e) {
            return null;
        }
    }

    private java.util.Date getDateSafe(ResultSet rs, String label) {
        try {
            if (!hasColumn(rs, label)) return null;
            Date d = rs.getDate(label);
            return d == null ? null : new java.util.Date(d.getTime());
        } catch (SQLException e) {
            return null;
        }
    }
}
