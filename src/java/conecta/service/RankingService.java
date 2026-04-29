package conecta.service;

import conecta.dao.RankingDAO;
import conecta.dto.RankingProfissionalDTO;
import java.sql.SQLException;
import java.util.List;

/**
 * 
 * @author Sebas
 */
public class RankingService {

    private final RankingDAO dao = new RankingDAO();

    public List<RankingProfissionalDTO> top(int limit, int offset) throws SQLException {
        return dao.listarTop(limit, offset);
    }

    public RankingProfissionalDTO doProfissional(long idProf) throws SQLException {
        return dao.buscarDoProfissional(idProf);
    }
}
