package conecta.dao;

import conecta.dto.DenunciaDetalheDTO;
import conecta.dto.DenunciaListaDTO;
import conecta.jdbc.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/** @author Sebas */
public class DenunciaDAO {

    /** Listagem simplificada para o painel ADM */
    public List<DenunciaListaDTO> listarTodasJoin() throws SQLException {
        String sql = """
            SELECT d.id_denuncia,
                   d.motivo_denuncia,
                   d.status_denuncia,
                   d.data_denuncia,
                   uc.nome_completo AS cliente_nome,
                   up.nome_completo AS profissional_nome
              FROM DENUNCIAS d
              JOIN USUARIOS uc ON uc.id_usuario = d.id_denunciante
              JOIN USUARIOS up ON up.id_usuario = d.id_denunciado
             ORDER BY d.data_denuncia DESC, d.id_denuncia DESC
        """;

        List<DenunciaListaDTO> lista = new ArrayList<>();
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DenunciaListaDTO dto = new DenunciaListaDTO();
                dto.setIdDenuncia(rs.getInt("id_denuncia"));
                dto.setMotivo(rs.getString("motivo_denuncia"));
                dto.setStatus(rs.getString("status_denuncia"));
                dto.setDataDenuncia(rs.getTimestamp("data_denuncia"));
                dto.setClienteNome(rs.getString("cliente_nome"));
                dto.setProfissionalNome(rs.getString("profissional_nome"));
                lista.add(dto);
            }
        }
        return lista;
    }

    /** Detalhe da denúncia para moderação */
    public DenunciaDetalheDTO buscarDetalheDTO(int idDenuncia) throws SQLException {
        String sql = """
            SELECT d.*, 
                   uc.id_usuario   AS cliente_id,
                   uc.nome_completo AS cliente_nome,
                   uc.email        AS cliente_email,
                   up.id_usuario   AS prof_id,
                   up.nome_completo AS prof_nome,
                   up.email        AS prof_email
              FROM DENUNCIAS d
              JOIN AGENDAMENTOS ag ON ag.id_agendamento = d.id_agendamento
              JOIN CLIENTES c ON c.id_cliente = ag.id_cliente
              JOIN PROFISSIONAIS p ON p.id_profissional = ag.id_profissional
              JOIN USUARIOS uc ON uc.id_usuario = c.id_cliente
              JOIN USUARIOS up ON up.id_usuario = p.id_profissional
             WHERE d.id_denuncia = ?
        """;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idDenuncia);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DenunciaDetalheDTO dto = new DenunciaDetalheDTO();
                    dto.setIdDenuncia(rs.getInt("id_denuncia"));
                    dto.setIdAgendamento(rs.getInt("id_agendamento"));
                    dto.setMotivo(rs.getString("motivo_denuncia"));
                    dto.setDescricao(rs.getString("descricao_denuncia"));
                    dto.setStatus(rs.getString("status_denuncia"));
                    dto.setDataDenuncia(rs.getTimestamp("data_denuncia"));
                    dto.setAcaoTomada(rs.getString("acao_tomada"));
                    dto.setObservacaoModeracao(rs.getString("observacao_moderacao"));
                    dto.setPrazoSuspensao(rs.getDate("prazo_suspensao"));
                    dto.setDataModeracao(rs.getTimestamp("data_moderacao"));

                    dto.setClienteIdUsuario(rs.getInt("cliente_id"));
                    dto.setClienteNome(rs.getString("cliente_nome"));
                    dto.setClienteEmail(rs.getString("cliente_email"));
                    dto.setProfissionalIdUsuario(rs.getInt("prof_id"));
                    dto.setProfissionalNome(rs.getString("prof_nome"));
                    dto.setProfissionalEmail(rs.getString("prof_email"));
                    return dto;
                }
            }
        }
        return null;
    }

    /** Verifica se o agendamento pertence ao cliente logado */
    public boolean validarAgendamentoDoCliente(long idAgendamento, long idUsuarioCliente) throws SQLException {
        String sql = """
            SELECT COUNT(*) 
              FROM AGENDAMENTOS ag
              JOIN CLIENTES c ON c.id_cliente = ag.id_cliente
             WHERE ag.id_agendamento = ? AND c.id_cliente = ?
        """;
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, idAgendamento);
            ps.setLong(2, idUsuarioCliente);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    /** Cria uma denúncia feita pelo cliente */
    public void criarDenunciaCliente(long idAgendamento, long idDenunciante, long idDenunciado,
                                    String motivo, String descricao) throws SQLException {
       // checar duplicidade (índice único já ajuda, mas damos msg amigável)
       String checkSql = """
           SELECT 1 FROM DENUNCIAS
            WHERE id_agendamento = ? AND id_denunciante = ? LIMIT 1
       """;
       try (Connection conn = ConnectionFactory.getConnection()) {
           try (PreparedStatement ck = conn.prepareStatement(checkSql)) {
               ck.setLong(1, idAgendamento);
               ck.setLong(2, idDenunciante);
               try (ResultSet rs = ck.executeQuery()) {
                   if (rs.next()) {
                       throw new SQLException("Já existe denúncia deste agendamento por este cliente.");
                   }
               }
           }

           String insert = """
               INSERT INTO DENUNCIAS
                   (id_agendamento, id_denunciante, id_denunciado, motivo_denuncia, descricao_denuncia, status_denuncia)
               VALUES (?, ?, ?, ?, ?, 'Pendente')
           """;
           try (PreparedStatement ps = conn.prepareStatement(insert)) {
               ps.setLong(1, idAgendamento);
               ps.setLong(2, idDenunciante);
               ps.setLong(3, idDenunciado);
               ps.setString(4, motivo);
               ps.setString(5, descricao);
               ps.executeUpdate();
           }
       }
   }


   /** Atualiza denúncia com ação de moderação + aplica no usuário + registra log */
    public void moderar(int idDenuncia, String tipoAcao, String observacao, Date prazo,
                        int moderadorId, boolean aplicarNoProf) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConnectionFactory.getConnection();
            conn.setAutoCommit(false);

            // 1) Buscar denunciado
            int idDenunciado = 0;
            try (PreparedStatement psBusca = conn.prepareStatement(
                    "SELECT id_denunciado FROM DENUNCIAS WHERE id_denuncia=?")) {
                psBusca.setInt(1, idDenuncia);
                try (ResultSet rs = psBusca.executeQuery()) {
                    if (rs.next()) {
                        idDenunciado = rs.getInt("id_denunciado");
                    }
                }
            }
            if (idDenunciado == 0) throw new SQLException("Usuário denunciado não encontrado.");

            // 2) Status Denúncia
            String status;
            switch (tipoAcao.toUpperCase()) {
                case "SUSPENDER" -> status = "Suspensao";
                case "BANIR" -> status = "Banimento";
                case "INVALIDAR" -> status = "Invalidada";
                default -> status = "Resolvida";
            }

            // 3) Atualizar DENUNCIAS
            String sqlUpdate = """
                UPDATE DENUNCIAS
                   SET acao_tomada=?, observacao_moderacao=?, prazo_suspensao=?, 
                       moderador_id=?, data_moderacao=NOW(), status_denuncia=?
                 WHERE id_denuncia=?
            """;
            ps = conn.prepareStatement(sqlUpdate);
            ps.setString(1, tipoAcao.toUpperCase());
            ps.setString(2, observacao);
            if (prazo != null) ps.setDate(3, new java.sql.Date(prazo.getTime())); else ps.setNull(3, Types.DATE);
            ps.setInt(4, moderadorId);
            ps.setString(5, status);
            ps.setInt(6, idDenuncia);
            ps.executeUpdate();
            ps.close();

            // 4) Atualizar USUARIOS.status_usuario (somente se não INVALIDAR)
            if (!"INVALIDAR".equalsIgnoreCase(tipoAcao)) {
                String novoStatusUsuario = "ATIVO";
                if ("SUSPENDER".equalsIgnoreCase(tipoAcao)) novoStatusUsuario = "SUSPENSO";
                else if ("BANIR".equalsIgnoreCase(tipoAcao)) novoStatusUsuario = "BANIDO";

                try (PreparedStatement psUser = conn.prepareStatement(
                        "UPDATE USUARIOS SET status_usuario=? WHERE id_usuario=?")) {
                    psUser.setString(1, novoStatusUsuario);
                    psUser.setInt(2, idDenunciado);
                    psUser.executeUpdate();
                }
            }

            // 5) Inserir log em MODERACOES_DENUNCIAS
            String sqlLog = """
                INSERT INTO MODERACOES_DENUNCIAS
                  (id_denuncia, id_usuario, tipo_acao, observacao, inicio, fim, moderador_id)
                VALUES (?, ?, ?, ?, NOW(), ?, ?)
            """;
            try (PreparedStatement psLog = conn.prepareStatement(sqlLog)) {
                psLog.setInt(1, idDenuncia);
                psLog.setInt(2, idDenunciado);
                psLog.setString(3, tipoAcao.toUpperCase());
                psLog.setString(4, observacao);
                if ("SUSPENDER".equalsIgnoreCase(tipoAcao) && prazo != null) {
                    psLog.setDate(5, new java.sql.Date(prazo.getTime()));
                } else {
                    psLog.setNull(5, Types.DATE);
                }
                psLog.setInt(6, moderadorId);
                psLog.executeUpdate();
            }

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw new SQLException("Erro ao moderar denúncia: " + e.getMessage(), e);
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.setAutoCommit(true);
            if (conn != null) conn.close();
        }
    }
    public int resolverDenunciasDoUsuario(int idUsuarioDenunciado) throws SQLException {
        final String sql = """
            UPDATE DENUNCIAS
               SET status_denuncia = 'Resolvida',
                   acao_tomada     = 'DESBLOQUEAR',
                   data_moderacao  = NOW()
             WHERE id_denunciado = ?
               AND status_denuncia IN ('Pendente','Suspensao','Banimento')
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuarioDenunciado);
            return ps.executeUpdate(); // qtd linhas afetadas
        }
    }
}
