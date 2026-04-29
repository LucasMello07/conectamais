package conecta.dao;

import conecta.entidades.Agendamento;
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
public class AgendamentoDAO {

    public Long inserir(Agendamento a) throws SQLException {
        final String sql = """
            INSERT INTO AGENDAMENTOS
              (id_cliente, id_profissional, data_agendamento, horario_agendamento, status_agendamento, id_habilidade)
            VALUES (?, ?, ?, ?, 'Pendente', ?)
        """;
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, a.getCliente().getIdCliente());
            ps.setLong(2, a.getProfissional().getIdProfissional());
            ps.setDate(3, new java.sql.Date(a.getDataAgendamento().getTime()));
            ps.setTime(4, Time.valueOf(a.getHorarioAgendamento() + ":00"));

            if (a.getIdHabilidade() == null || a.getIdHabilidade() <= 0) {
                throw new SQLException("id_habilidade obrigatório para criar agendamento.");
            }
            ps.setLong(5, a.getIdHabilidade());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        return null;
    }

    public Agendamento buscarPorId(long id) throws SQLException {
        final String sql = """
            SELECT id_agendamento, id_cliente, id_profissional,
                   data_agendamento, horario_agendamento, status_agendamento,
                   id_habilidade
              FROM AGENDAMENTOS
             WHERE id_agendamento = ?
        """;
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public List<Agendamento> listarPorCliente(long idCliente) throws SQLException {
        final String sql = """
            SELECT ag.id_agendamento, ag.id_cliente, ag.id_profissional,
                   ag.data_agendamento, ag.horario_agendamento, ag.status_agendamento,
                   ag.id_habilidade,
                   EXISTS (
                       SELECT 1
                         FROM DENUNCIAS d
                        WHERE d.id_agendamento = ag.id_agendamento
                          AND d.id_denunciante = ?
                   ) AS ja_denunciado
              FROM AGENDAMENTOS ag
             WHERE ag.id_cliente = ?
          ORDER BY FIELD(ag.status_agendamento, 'Pendente','Concluído','Cancelado'),
                   ag.data_agendamento DESC,
                   ag.horario_agendamento DESC
        """;
        List<Agendamento> lista = new ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idCliente);
            ps.setLong(2, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Agendamento a = map(rs);
                    try {
                        a.setJaDenunciado(rs.getBoolean("ja_denunciado"));
                    } catch (SQLException ignore) {
                    }
                    lista.add(a);
                }
            }
        }
        return lista;
    }

    public List<Agendamento> listarPorClienteComAvaliacao(long idCliente) throws SQLException {
        final String sql = """
         SELECT
             ag.id_agendamento,
             ag.id_cliente,
             ag.id_profissional,
             ag.data_agendamento,
             ag.horario_agendamento,
             ag.status_agendamento,
             uprof.nome_completo AS nome_profissional,
             EXISTS (
                 SELECT 1
                   FROM AVALIACOES av
                  WHERE av.id_agendamento = ag.id_agendamento
                    AND av.id_cliente     = ?
             ) AS ja_avaliado,
             EXISTS (
                 SELECT 1
                   FROM DENUNCIAS d
                  WHERE d.id_agendamento = ag.id_agendamento
                    AND d.id_denunciante  = ?
             ) AS ja_denunciado
         FROM AGENDAMENTOS ag
         INNER JOIN PROFISSIONAIS p    ON p.id_profissional = ag.id_profissional
         INNER JOIN USUARIOS     uprof ON uprof.id_usuario  = p.id_profissional
         WHERE ag.id_cliente = ?
         ORDER BY FIELD(ag.status_agendamento, 'Pendente','Concluído','Cancelado'),
                  ag.data_agendamento DESC,
                  ag.horario_agendamento DESC
     """;

        List<Agendamento> lista = new ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setLong(1, idCliente);
            ps.setLong(2, idCliente);
            ps.setLong(3, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Agendamento ag = new Agendamento();
                    ag.setIdAgendamento(rs.getLong("id_agendamento"));
                    ag.setDataAgendamento(rs.getDate("data_agendamento"));
                    ag.setHorarioAgendamento(rs.getString("horario_agendamento"));
                    ag.setStatusAgendamento(rs.getString("status_agendamento"));

                    Cliente cli = new Cliente();
                    cli.setIdCliente(rs.getLong("id_cliente"));
                    ag.setCliente(cli);

                    Profissional prof = new Profissional();
                    prof.setIdProfissional(rs.getLong("id_profissional"));
                    Usuario u = new Usuario();
                    u.setIdUsuario(rs.getLong("id_profissional"));
                    u.setNomeCompleto(rs.getString("nome_profissional"));
                    prof.setUsuario(u);
                    ag.setProfissional(prof);

                    ag.setJaAvaliado(rs.getBoolean("ja_avaliado"));
                    ag.setJaDenunciado(rs.getBoolean("ja_denunciado"));

                    lista.add(ag);
                }
            }
        }
        return lista;
    }

    public List<Agendamento> listarPorClienteComProfissional(long idCliente) throws SQLException {
        final String sql = """
            SELECT ag.id_agendamento, ag.id_cliente, ag.id_profissional,
                   ag.data_agendamento, ag.horario_agendamento, ag.status_agendamento,
                   ag.id_habilidade,
                   up.nome_completo AS nome_profissional,
                   EXISTS (
                       SELECT 1
                         FROM AVALIACOES av
                        WHERE av.id_agendamento = ag.id_agendamento
                          AND av.id_cliente     = ag.id_cliente
                   ) AS ja_avaliado,
                   EXISTS (
                       SELECT 1
                         FROM DENUNCIAS d
                        WHERE d.id_agendamento = ag.id_agendamento
                          AND d.id_denunciante  = ag.id_cliente
                   ) AS ja_denunciado
              FROM AGENDAMENTOS ag
         LEFT JOIN USUARIOS up ON up.id_usuario = ag.id_profissional
             WHERE ag.id_cliente = ?
          ORDER BY FIELD(ag.status_agendamento, 'Pendente','Concluído','Cancelado'),
                   ag.data_agendamento DESC,
                   ag.horario_agendamento DESC
        """;

        List<Agendamento> lista = new ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Agendamento a = map(rs);

                    Profissional p = a.getProfissional();
                    if (p == null) {
                        p = new Profissional();
                    }
                    p.setIdProfissional(rs.getLong("id_profissional"));

                    Usuario u = new Usuario();
                    u.setIdUsuario(rs.getLong("id_profissional"));
                    u.setNomeCompleto(rs.getString("nome_profissional"));
                    p.setUsuario(u);
                    a.setProfissional(p);

                    a.setJaAvaliado(rs.getBoolean("ja_avaliado"));
                    a.setJaDenunciado(rs.getBoolean("ja_denunciado"));

                    lista.add(a);
                }
            }
        }
        return lista;
    }

    public List<Agendamento> listarPorProfissionalComCliente(long idProf) throws SQLException {
        final String sql = """
            SELECT ag.id_agendamento, ag.id_cliente, ag.id_profissional,
                   ag.data_agendamento, ag.horario_agendamento, ag.status_agendamento,
                   ag.id_habilidade,
                   uc.nome_completo AS nome_cliente
              FROM AGENDAMENTOS ag
         LEFT JOIN USUARIOS uc ON uc.id_usuario = ag.id_cliente
             WHERE ag.id_profissional = ?
          ORDER BY FIELD(ag.status_agendamento, 'Pendente','Concluído','Cancelado'),
                   ag.data_agendamento DESC,
                   ag.horario_agendamento DESC
        """;
        List<Agendamento> lista = new ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setLong(1, idProf);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Agendamento a = map(rs);

                    Cliente cli = a.getCliente();
                    if (cli == null) {
                        cli = new Cliente();
                    }
                    cli.setIdCliente(rs.getLong("id_cliente"));

                    Usuario u = new Usuario();
                    u.setIdUsuario(rs.getLong("id_cliente"));
                    u.setNomeCompleto(rs.getString("nome_cliente"));
                    cli.setUsuario(u);
                    a.setCliente(cli);

                    lista.add(a);
                }
            }
        }
        return lista;
    }

    public void atualizarStatus(long idAgendamento, String novoStatus) throws SQLException {
        final String sql = "UPDATE AGENDAMENTOS SET status_agendamento = ? WHERE id_agendamento = ?";
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, novoStatus);
            ps.setLong(2, idAgendamento);
            ps.executeUpdate();
        }
    }

    public boolean existeConflito(long idProf, Date data, Time hora) throws SQLException {
        final String sql = """
            SELECT 1
              FROM AGENDAMENTOS
             WHERE id_profissional = ?
               AND data_agendamento = ?
               AND horario_agendamento = ?
               AND status_agendamento <> 'Cancelado'
             LIMIT 1
        """;
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idProf);
            ps.setDate(2, data);
            ps.setTime(3, hora);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int contarPorClienteStatus(long idCliente, String status) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM AGENDAMENTOS WHERE id_cliente = ? AND status_agendamento = ?";
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idCliente);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public int contarPorProfissionalStatus(long idProf, String status) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM AGENDAMENTOS WHERE id_profissional = ? AND status_agendamento = ?";
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, idProf);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private Agendamento map(ResultSet rs) throws SQLException {
        Agendamento a = new Agendamento();
        a.setIdAgendamento(rs.getLong("id_agendamento"));

        Cliente cli = new Cliente();
        cli.setIdCliente(rs.getLong("id_cliente"));
        a.setCliente(cli);

        Profissional p = new Profissional();
        p.setIdProfissional(rs.getLong("id_profissional"));
        a.setProfissional(p);

        Date d = rs.getDate("data_agendamento");
        if (d != null) {
            a.setDataAgendamento(new java.util.Date(d.getTime()));
        }

        Time t = rs.getTime("horario_agendamento");
        if (t != null) {
            String hhmm = t.toString();
            a.setHorarioAgendamento(hhmm.length() >= 5 ? hhmm.substring(0, 5) : hhmm);
        }

        a.setStatusAgendamento(rs.getString("status_agendamento"));

        try {
            Object oh = rs.getObject("id_habilidade");
            if (oh != null) {
                a.setIdHabilidade(rs.getLong("id_habilidade"));
            }
        } catch (SQLException ignore) {
        }

        try {
            a.setJaDenunciado(rs.getBoolean("ja_denunciado"));
        } catch (SQLException ignore) {
            a.setJaDenunciado(false);
        }

        return a;
    }

    public boolean existeVinculo(Long idUsuario, long idCliente) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int confirmarPendentesExpirados() throws SQLException {
        final String sql = """
            UPDATE AGENDAMENTOS
               SET status_agendamento = 'Concluído'
             WHERE status_agendamento = 'Pendente'
               AND TIMESTAMP(data_agendamento, horario_agendamento) <= (CURRENT_TIMESTAMP - INTERVAL 24 HOUR)
        """;
        try (Connection c = ConnectionFactory.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            return ps.executeUpdate();
        }
    }
}
