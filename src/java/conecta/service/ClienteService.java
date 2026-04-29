package conecta.service;

import conecta.dao.ClienteDAO;
import conecta.dto.ClientePerfilDTO;
import conecta.dto.AvaliacaoResumoDTO;
import conecta.dto.ProfissionalFavoritoDTO;
import conecta.entidades.Cliente;
import java.sql.SQLException;
import java.util.List;

/**
 * @author Sebas
 */
public class ClienteService {

    private final ClienteDAO dao = new ClienteDAO();

    public ClientePerfilDTO buscarPerfilCliente(long idCliente) throws SQLException {
        return dao.buscarPerfilCliente(idCliente);
    }

    public List<ProfissionalFavoritoDTO> listarFavoritos(long idCliente) throws SQLException {
        return dao.listarFavoritos(idCliente);
    }

    public List<AvaliacaoResumoDTO> listarAvaliacoesFeitas(long idCliente) throws SQLException {
        return dao.listarAvaliacoesFeitas(idCliente);
    }

    public Cliente buscarPorUsuarioId(long idUsuario) throws SQLException {
        return dao.buscarPorUsuarioId(idUsuario);
    }
}
