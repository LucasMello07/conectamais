package conecta.service;

import conecta.dao.DenunciaDAO;
import conecta.dto.DenunciaDetalheDTO;
import conecta.dto.DenunciaListaDTO;

import java.util.Date;
import java.util.List;

/**
 * @author Sebas
 */
public class DenunciaService {
    private final DenunciaDAO dao = new DenunciaDAO();

    public List<DenunciaListaDTO> listarTodasJoin() throws Exception {
        return dao.listarTodasJoin();
    }

    public DenunciaDetalheDTO buscarDetalheDTO(int idDenuncia) throws Exception {
        return dao.buscarDetalheDTO(idDenuncia);
    }

    public boolean validarAgendamentoDoCliente(long idAgendamento, long idUsuarioCliente) throws Exception {
        return dao.validarAgendamentoDoCliente(idAgendamento, idUsuarioCliente);
    }

    public void criarDenunciaCliente(long idAgendamento, long idDenunciante, long idDenunciado,
                                     String motivo, String descricao) throws Exception {
        dao.criarDenunciaCliente(idAgendamento, idDenunciante, idDenunciado, motivo, descricao);
    }

    public void moderar(int idDenuncia, String tipoAcao, String observacao, Date prazo,
                        int moderadorId, boolean aplicarNoProf) throws Exception {
        dao.moderar(idDenuncia, tipoAcao, observacao, prazo, moderadorId, aplicarNoProf);
    }
}
