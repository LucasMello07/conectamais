package conecta.dao;

import conecta.dto.RankingProfissionalDTO;
import conecta.jdbc.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para Ranking baseado em VIEW (Opção A).
 * Agora só LÊ dados calculados "ao vivo" nas views.
 * Métodos de escrita foram desabilitados.
 *
 * @author Sebas
 */
public class RankingDAO {

    // Base SQL: escolha UMA das opções de JOIN com USUARIOS.
    private static final String SQL_BASE = """
        SELECT
          p.id_profissional,
          u.nome_completo,
          COALESCE(v.media_nota, 0)      AS media_nota,
          COALESCE(v.qtd_avaliacoes, 0)  AS qtd_avaliacoes,
          COALESCE(v.posicao, 0)         AS posicao,
          COALESCE(f.qtd_favoritos, 0)   AS qtd_favoritos
        FROM PROFISSIONAIS p
        JOIN USUARIOS u ON u.id_usuario = p.id_profissional   -- << AQUI é o certo no seu banco
        LEFT JOIN vw_ranking_profissionais v ON v.id_profissional = p.id_profissional
        LEFT JOIN vw_favoritos_profissional  f ON f.id_profissional = p.id_profissional
      """;

    /**
     * Lista o Top N com paginação.
     * Ordenação: posicao asc com NULLS LAST (em MySQL simulamos com (posicao IS NULL), posicao)
     */
    public List<RankingProfissionalDTO> listarTop(int limit, int offset) throws SQLException {
        String sql = SQL_BASE + " ORDER BY (v.posicao IS NULL), v.posicao ASC LIMIT ? OFFSET ?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                List<RankingProfissionalDTO> out = new ArrayList<>();
                while (rs.next()) {
                    out.add(map(rs));
                }
                return out;
            }
        }
    }

    /**
     * Busca os números do ranking para um profissional específico.
     */
    public RankingProfissionalDTO buscarDoProfissional(long idProf) throws SQLException {
        String sql = SQL_BASE + " WHERE p.id_profissional = ?";
        try (Connection c = ConnectionFactory.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setLong(1, idProf);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    // ===== Métodos antigos de escrita: desabilitados para evitar uso com a Opção A =====
    @Deprecated
    public void cadastrar(Object ignore) {
        throw new UnsupportedOperationException("RankingDAO (Opção A) não permite inserir. Use as VIEWS para leitura.");
    }

    @Deprecated
    public void atualizar(Object ignore) {
        throw new UnsupportedOperationException("RankingDAO (Opção A) não permite atualizar. Use as VIEWS para leitura.");
    }

    @Deprecated
    public void deletar(Long idRanking) {
        throw new UnsupportedOperationException("RankingDAO (Opção A) não permite deletar. Use as VIEWS para leitura.");
    }

    // ===== Mapper DTO =====
    private RankingProfissionalDTO map(ResultSet rs) throws SQLException {
        return new RankingProfissionalDTO(
            rs.getLong("id_profissional"),
            rs.getString("nome_completo"),
            rs.getDouble("media_nota"),
            rs.getInt("qtd_avaliacoes"),
            rs.getInt("posicao"),
            rs.getInt("qtd_favoritos")
        );
    }
}
