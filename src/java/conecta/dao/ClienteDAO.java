package conecta.dao;

import conecta.entidades.Cliente;
import conecta.entidades.Usuario;
import conecta.jdbc.ConnectionFactory;

import conecta.dto.ClientePerfilDTO;
import conecta.dto.ProfissionalFavoritoDTO;
import conecta.dto.AvaliacaoResumoDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Sebas
 */
public class ClienteDAO {

    /** Insere um cliente usando o mesmo id do usuário (FK 1:1 com USUARIOS.id_usuario). */
    public void cadastrar(Cliente cliente) throws SQLException {
        final String sql = "INSERT INTO CLIENTES (id_cliente) VALUES (?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, cliente.getUsuario().getIdUsuario());
            stmt.executeUpdate();
        }
    }

    /** Busca completa (Cliente + Usuario) pelo id do cliente (== id do usuário). */
    public Cliente buscarPorId(Long idCliente) throws SQLException {
        final String sql = """
            SELECT *
              FROM CLIENTES c
              INNER JOIN USUARIOS u ON c.id_cliente = u.id_usuario
             WHERE c.id_cliente = ?
        """;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, idCliente);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) return null;

                Cliente cliente = new Cliente();
                Usuario usuario = new Usuario();

                usuario.setIdUsuario(rs.getLong("id_usuario"));
                usuario.setNomeCompleto(rs.getString("nome_completo"));
                usuario.setDataNascimento(rs.getDate("data_nascimento"));
                usuario.setGenero(rs.getString("genero"));
                usuario.setCelular(rs.getString("celular"));
                usuario.setEmail(rs.getString("email"));
                usuario.setSenha(rs.getString("senha"));
                usuario.setCpfCnpj(rs.getString("cpf_cnpj"));
                usuario.setEnderecoRua(rs.getString("endereco_rua"));
                usuario.setBairro(rs.getString("bairro"));
                usuario.setCidade(rs.getString("cidade"));
                usuario.setEstado(rs.getString("estado"));
                usuario.setTipoUsuario(rs.getString("tipo_usuario"));

                cliente.setIdCliente(rs.getLong("id_cliente"));
                cliente.setUsuario(usuario);
                return cliente;
            }
        }
    }

    /** 🔹 Novo: Busca o Cliente a partir do id do USUÁRIO (1:1). */
    public Cliente buscarPorUsuarioId(long idUsuario) throws SQLException {
        // Como o relacionamento é 1:1 (CLIENTES.id_cliente == USUARIOS.id_usuario),
        // podemos reaproveitar a mesma consulta de buscarPorId:
        return buscarPorId(idUsuario);
    }

    /* ================== TELAS DE PERFIL / FAVORITOS / AVALIAÇÕES ================== */

    /** Dados enxutos do cabeçalho do perfil do cliente (sem foto). */
    public ClientePerfilDTO buscarPerfilCliente(long idCliente) throws SQLException {
        final String sql = """
            SELECT c.id_cliente,
                   u.nome_completo,
                   u.email,
                   u.celular,
                   u.cidade,
                   u.estado
              FROM CLIENTES c
              JOIN USUARIOS u ON u.id_usuario = c.id_cliente
             WHERE c.id_cliente = ?
        """;
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                ClientePerfilDTO dto = new ClientePerfilDTO();
                dto.setIdCliente(rs.getLong("id_cliente"));
                dto.setNomeCompleto(rs.getString("nome_completo"));
                dto.setEmail(rs.getString("email"));
                dto.setCelular(rs.getString("celular"));
                dto.setCidade(rs.getString("cidade"));
                dto.setEstado(rs.getString("estado"));
                return dto;
            }
        }
    }

    /**
     * Profissionais favoritos do cliente.
     * “Área” derivada das habilidades ativas do profissional (GROUP_CONCAT).
     * Se o seu schema usa a tabela FAVORITOS (como no seu código), está coerente.
     */
    public List<ProfissionalFavoritoDTO> listarFavoritos(long idCliente) throws SQLException {
        final String sql = """
            SELECT pf.id_profissional,
                   up.nome_completo AS nome_profissional,
                   GROUP_CONCAT(DISTINCT h.titulo ORDER BY h.titulo SEPARATOR ', ') AS area_atuacao,
                   DATE_FORMAT(pf.data_favorito, '%d/%m/%Y %H:%i') AS data_fav
              FROM FAVORITOS pf
              JOIN PROFISSIONAIS p ON p.id_profissional = pf.id_profissional
              JOIN USUARIOS up     ON up.id_usuario     = p.id_profissional
         LEFT JOIN HABILIDADES h   ON h.id_profissional = p.id_profissional AND h.status = 'Ativo'
             WHERE pf.id_cliente = ?
          GROUP BY pf.id_profissional, up.nome_completo, pf.data_favorito
          ORDER BY pf.data_favorito DESC
        """;
        List<ProfissionalFavoritoDTO> list = new ArrayList<>();
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProfissionalFavoritoDTO d = new ProfissionalFavoritoDTO();
                    d.setIdProfissional(rs.getLong("id_profissional"));
                    d.setNomeProfissional(rs.getString("nome_profissional"));
                    d.setAreaAtuacao(rs.getString("area_atuacao")); // ex.: "Corte, Pintura"
                    d.setDataFavorito(rs.getString("data_fav"));
                    list.add(d);
                }
            }
        }
        return list;
    }

    /** Avaliações feitas por este cliente (com profissional e, se existir, título do serviço). */
    public List<AvaliacaoResumoDTO> listarAvaliacoesFeitas(long idCliente) throws SQLException {
        final String sql = """
            SELECT a.id_avaliacao,
                   a.nota,
                   a.comentario_avaliacao AS comentario_avaliacao,
                   DATE_FORMAT(a.data_avaliacao, '%d/%m/%Y') AS data_av,
                   up.nome_completo AS nome_profissional,
                   h.titulo         AS servico
              FROM AVALIACOES a
              JOIN PROFISSIONAIS p ON p.id_profissional = a.id_profissional
              JOIN USUARIOS up     ON up.id_usuario     = p.id_profissional
         LEFT JOIN AGENDAMENTOS ag ON ag.id_agendamento = a.id_agendamento
         LEFT JOIN HABILIDADES  h  ON h.id_habilidade   = ag.id_habilidade
             WHERE a.id_cliente = ?
          ORDER BY a.data_avaliacao DESC, a.id_avaliacao DESC
        """;

        List<AvaliacaoResumoDTO> list = new ArrayList<>();
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AvaliacaoResumoDTO d = new AvaliacaoResumoDTO();
                    d.setIdAvaliacao(rs.getLong("id_avaliacao"));
                    d.setNota(rs.getString("nota"));
                    d.setComentario(rs.getString("comentario_avaliacao")); // alias acima
                    d.setDataAvaliacao(rs.getString("data_av"));
                    d.setNomeProfissional(rs.getString("nome_profissional"));
                    d.setTituloServico(rs.getString("servico"));
                    list.add(d);
                }
            }
        }
        return list;
    }
}
