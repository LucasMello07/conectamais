package conecta.dao;

import conecta.dto.ModeracaoUsuarioDTO;
import conecta.jdbc.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ModeracaoDAO {

    /** Lista um card por usuário com a ÚLTIMA moderação + status atual do usuário */
    public List<ModeracaoUsuarioDTO> listarUsuariosModerados() throws SQLException {
        String sql = """
            SELECT u.id_usuario,
                   u.nome_completo,
                   u.status_usuario,
                   md.tipo_acao,
                   md.inicio
              FROM USUARIOS u
         LEFT JOIN (
                    SELECT m1.*
                      FROM MODERACOES_DENUNCIAS m1
                     JOIN (
                           SELECT id_usuario, MAX(inicio) AS max_inicio
                             FROM MODERACOES_DENUNCIAS
                            GROUP BY id_usuario
                          ) ult
                       ON ult.id_usuario = m1.id_usuario
                      AND ult.max_inicio = m1.inicio
                   ) md
                ON md.id_usuario = u.id_usuario
             WHERE u.status_usuario IN ('SUSPENSO','BANIDO')
                OR md.id_usuario IS NOT NULL
          ORDER BY
                (CASE u.status_usuario
                   WHEN 'BANIDO' THEN 1
                   WHEN 'SUSPENSO' THEN 2
                   ELSE 3
                 END),
                md.inicio DESC, u.id_usuario DESC
        """;

        List<ModeracaoUsuarioDTO> lista = new ArrayList<>();
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ModeracaoUsuarioDTO dto = new ModeracaoUsuarioDTO();
                dto.setIdUsuario(rs.getInt("id_usuario"));
                dto.setNomeUsuario(rs.getString("nome_completo"));
                dto.setStatusUsuario(rs.getString("status_usuario")); // ATIVO|SUSPENSO|BANIDO
                dto.setTipoAcao(rs.getString("tipo_acao"));           // pode ser null
                Timestamp ts = rs.getTimestamp("inicio");
                if (ts != null) dto.setDataAcao(new java.util.Date(ts.getTime()));
                lista.add(dto);
            }
        }
        return lista;
    }

    /** Contadores rápidos pelo status atual do usuário */
    public int contarSuspensos() throws SQLException {
        return contarPorStatus("SUSPENSO");
    }

    public int contarBanidos() throws SQLException {
        return contarPorStatus("BANIDO");
    }

    /** Denúncias invalidadas: conta no log a última ação INVALIDAR */
    public int contarInvalidas() throws SQLException {
        String sql = """
            SELECT COUNT(*)
              FROM (
                    SELECT m1.id_usuario, m1.tipo_acao, m1.inicio
                      FROM MODERACOES_DENUNCIAS m1
                     JOIN (
                           SELECT id_usuario, MAX(inicio) max_inicio
                             FROM MODERACOES_DENUNCIAS
                            GROUP BY id_usuario
                          ) ult
                       ON ult.id_usuario = m1.id_usuario
                      AND ult.max_inicio = m1.inicio
                   ) x
             WHERE x.tipo_acao = 'INVALIDAR'
        """;
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private int contarPorStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM USUARIOS WHERE status_usuario = ?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Desbloquear = voltar para ATIVO */
    public void desbloquearUsuario(int idUsuario) throws SQLException {
        String sql = "UPDATE USUARIOS SET status_usuario = 'ATIVO' WHERE id_usuario = ?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
        }
    }
}
