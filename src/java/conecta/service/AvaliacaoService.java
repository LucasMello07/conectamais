package conecta.service;

import conecta.dao.AvaliacaoDAO;
import conecta.entidades.Agendamento;
import conecta.entidades.Avaliacao;
import conecta.entidades.Cliente;
import conecta.entidades.Profissional;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

/**
 * Regras de negócio para Avaliações.
 * - Somente CLIENTE avalia.
 * - Um agendamento só pode ser avaliado uma vez.
 *
 * @author Sebas
 */
public class AvaliacaoService {

    private final AvaliacaoDAO dao;

    public AvaliacaoService() {
        this.dao = new AvaliacaoDAO();
    }

    /** Nova avaliação (cliente logado) */
    public Long salvarNovaAvaliacao(long idClienteSessao,
                                    long idProfissional,
                                    long idAgendamento,
                                    String nota,
                                    String comentario) throws SQLException {

        if (idClienteSessao <= 0 || idProfissional <= 0 || idAgendamento <= 0) {
            throw new IllegalArgumentException("Dados inválidos para avaliar.");
        }
        if (nota == null || nota.isBlank()) {
            throw new IllegalArgumentException("Escolha uma nota para a avaliação.");
        }

        // Evita avaliação duplicada do mesmo cliente para o mesmo agendamento
        if (dao.existePorAgendamentoCliente(idAgendamento, idClienteSessao)) {
            throw new IllegalArgumentException("Este agendamento já foi avaliado por você.");
        }

        Avaliacao a = new Avaliacao();
        Cliente c = new Cliente(); c.setIdCliente(idClienteSessao);
        Profissional p = new Profissional(); p.setIdProfissional(idProfissional);
        Agendamento ag = new Agendamento(); ag.setIdAgendamento(idAgendamento);

        a.setCliente(c);
        a.setProfissional(p);
        a.setAgendamento(ag);
        a.setNota(nota);
        a.setComentarioAvaliacao(comentario);
        a.setDataAvaliacao(new Date());

        return dao.cadastrar(a);
    }

    /** Edita avaliação do próprio cliente. */
    public void editarAvaliacao(long idClienteSessao,
                                long idAvaliacao,
                                String nota,
                                String comentario) throws SQLException {

        if (idClienteSessao <= 0 || idAvaliacao <= 0) {
            throw new IllegalArgumentException("Dados inválidos para editar avaliação.");
        }
        if (nota == null || nota.isBlank()) {
            throw new IllegalArgumentException("Informe a nota.");
        }

        Avaliacao a = dao.buscarPorId(idAvaliacao);
        if (a == null || a.getCliente() == null || a.getCliente().getIdCliente() == null
                || a.getCliente().getIdCliente() != idClienteSessao) {
            throw new IllegalArgumentException("Avaliação não encontrada para este cliente.");
        }

        a.setNota(nota);
        a.setComentarioAvaliacao(comentario);
        a.setDataAvaliacao(new Date());

        dao.atualizar(a);
    }

    /** Exclui avaliação do próprio cliente. */
    public void excluirAvaliacao(long idClienteSessao, long idAvaliacao) throws SQLException {
        if (idClienteSessao <= 0 || idAvaliacao <= 0) return;
        dao.deletar(idAvaliacao, idClienteSessao);
    }

    /** Lista avaliações feitas por um cliente (detalhadas p/ tela do cliente). */
    public List<Avaliacao> listarCliente(long idCliente) throws SQLException {
        return dao.listarPorClienteDetalhado(idCliente);
    }

    /** Lista avaliações recebidas por um profissional (para tela do profissional). */
    public List<Avaliacao> listarRecebidasPorProfissional(long idProf) throws SQLException {
        return dao.listarRecebidasPorProfissional(idProf);
    }

    /** Verifica se o cliente já avaliou o agendamento (para pintar botão 'Ver avaliação'). */
    public boolean jaAvaliado(long idAgendamento, long idCliente) throws SQLException {
        if (idAgendamento <= 0 || idCliente <= 0) return false;
        return dao.existePorAgendamentoCliente(idAgendamento, idCliente);
    }
}
