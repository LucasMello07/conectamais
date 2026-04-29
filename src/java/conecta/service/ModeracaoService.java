package conecta.service;

import conecta.dao.ModeracaoDAO;
import conecta.dto.ModeracaoUsuarioDTO;
import conecta.jdbc.ConnectionFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class ModeracaoService {

    private final ModeracaoDAO dao = new ModeracaoDAO();

    // Listagem e contadores usados na listagem-USUARIOS-ADM
    public List<ModeracaoUsuarioDTO> listarUsuariosModerados() throws SQLException {
        return dao.listarUsuariosModerados();
    }

    public int contarSuspensos() throws SQLException { return dao.contarSuspensos(); }

    public int contarBanidos() throws SQLException { return dao.contarBanidos(); }

    public int contarInvalidas() throws SQLException { return dao.contarInvalidas(); }

    /**
     * Desbloqueia o usuário e resolve as denúncias em aberto dele.
     * Usado pelo ModeracaoServlet ao clicar no botão “desbloquear”.
     */
    public void desbloquearUsuario(int idUsuario) throws SQLException {
        Connection c = null;
        try {
            c = ConnectionFactory.getConnection();
            c.setAutoCommit(false);

            // 1) Reativar usuário
            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE USUARIOS SET status_usuario='ATIVO' WHERE id_usuario=?")) {
                ps.setInt(1, idUsuario);
                ps.executeUpdate();
            }

            // 2) Resolver denúncias “em aberto” desse usuário
            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE DENUNCIAS " +
                    "   SET status_denuncia='Resolvida', " +
                    "       acao_tomada='DESBLOQUEAR', " +
                    "       data_moderacao=NOW() " +
                    " WHERE id_denunciado=? " +
                    "   AND status_denuncia IN ('Pendente','Suspensao','Banimento')")) {
                ps.setInt(1, idUsuario);
                ps.executeUpdate();
            }

            c.commit();
        } catch (SQLException e) {
            if (c != null) {
                try { c.rollback(); } catch (SQLException ignore) {}
            }
            throw e; // propaga pro servlet mostrar mensagem
        } finally {
            if (c != null) {
                try {
                    c.setAutoCommit(true);
                    c.close();
                } catch (SQLException ignore) {}
            }
        }
    }
}
