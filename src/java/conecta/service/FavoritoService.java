package conecta.service;

import conecta.dao.FavoritoDAO;
import conecta.entidades.Favorito;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Sebas
 */
public class FavoritoService {

    private final FavoritoDAO dao = new FavoritoDAO();

    public void favoritar(Favorito f) throws SQLException {
        long idCli = f.getCliente().getIdCliente();
        long idProf = f.getProfissional().getIdProfissional();
        if (!dao.isFavorito(idCli, idProf)) {
            dao.cadastrar(f);
        }
    }

    public void desfavoritar(long idCliente, long idProfissional) throws SQLException {
        dao.removerPorClienteEProfissional(idCliente, idProfissional);
    }

    public List<Favorito> listarDetalhado(long idCliente, String termo) throws SQLException {
        return dao.listarPorClienteDetalhado(idCliente, termo);
    }

    public int contarFavoritadores(long idProfissional) throws SQLException {
        return dao.contarFavoritadoresDoProfissional(idProfissional);
    }

    public java.util.List<Long> buscarIdsFavoritosDoCliente(long idCliente) throws SQLException {
        return dao.buscarIdsFavoritos(idCliente);
    }

}
