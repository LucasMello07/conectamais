package conecta.service;

import conecta.dao.HabilidadeDAO;
import conecta.dao.ProfissionalDAO;
import conecta.entidades.Habilidade;

import java.sql.SQLException;
import java.util.List;

public class HabilidadeService {

    private final HabilidadeDAO habDao = new HabilidadeDAO();
    private final ProfissionalDAO profDao = new ProfissionalDAO(); // se não usar, pode remover

    public void adicionar(Habilidade h) throws SQLException {
        validar(h, false);
        habDao.inserir(h);
    }

    public void editar(Habilidade h) throws SQLException {
        if (h == null || h.getIdHabilidade() <= 0)
            throw new IllegalArgumentException("ID da habilidade é obrigatório para editar.");
        validar(h, true);
        habDao.atualizar(h);
    }

    public void excluir(int idHabilidade) throws SQLException {
        if (idHabilidade <= 0) throw new IllegalArgumentException("ID inválido para exclusão.");
        habDao.excluir(idHabilidade);
    }

    public Habilidade buscar(int id) throws SQLException {
        if (id <= 0) return null;
        return habDao.buscarPorId(id);
    }

    public List<Habilidade> listarPorProfissional(int idProfissional) throws SQLException {
        if (idProfissional <= 0) throw new IllegalArgumentException("Profissional inválido");
        return habDao.listarPorProfissional(idProfissional);
    }

    /** Somente habilidades com status 'Ativo' */
    public List<Habilidade> listarAtivasPorProfissional(int idProfissional) throws SQLException {
        if (idProfissional <= 0) throw new IllegalArgumentException("Profissional inválido");
        return habDao.listarAtivasPorProfissional(idProfissional);
    }

    /* helpers */
    private void validar(Habilidade h, boolean editar) {
        if (h == null) throw new IllegalArgumentException("Dados de habilidade ausentes");
        if (h.getIdProfissional() <= 0) throw new IllegalArgumentException("Profissional obrigatório");
        if (isBlank(h.getTitulo())) throw new IllegalArgumentException("Título obrigatório");
        if (isBlank(h.getStatus())) h.setStatus("Ativo");
    }
    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
}
