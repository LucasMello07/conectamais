package conecta.service;

import conecta.dao.ProfissionalDAO;
import conecta.dto.HabilidadeDTO;
import conecta.dto.ProfissionalBuscaDTO;
import conecta.entidades.Profissional;
import java.sql.SQLException;
import java.util.List;

/**
 * @author Sebas
 */
public class ProfissionalService {

    private final ProfissionalDAO dao = new ProfissionalDAO();

    public List<ProfissionalBuscaDTO> buscarPlano(String termo, int limit, int offset) throws SQLException {
        return dao.buscarProfissionaisPlano(termo, limit, offset);
    }

    public int contarPlano(String termo) throws SQLException {
        return dao.contarProfissionaisPlano(termo);
    }

    public Profissional buscarPorId(long idProf) throws SQLException {
        return dao.buscarPorId(idProf);
    }

    public List<HabilidadeDTO> listarHabilidadesAtivas(long idProf) throws SQLException {
        return dao.listarHabilidadesAtivas(idProf);
    }

    public Profissional buscarPorUsuario(long idUsuario) throws SQLException {
        return dao.buscarPorUsuario(idUsuario);
    }

    public Long obterIdProfissionalPorUsuario(long idUsuario) throws SQLException {
        Profissional p = dao.buscarPorUsuario(idUsuario);
        return (p != null && p.getIdProfissional() != null) ? p.getIdProfissional() : null;
    }

    public Profissional buscarPorUsuarioId(long idUsuario) throws SQLException {
        return dao.buscarPorUsuarioId(idUsuario);
    }
}
