package conecta.service;

import conecta.dao.AgendamentoDAO;
import conecta.entidades.Agendamento;
import conecta.entidades.Usuario;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;

/**
 *
 * @author Sebas
 */
public class AgendamentoService {

    private final AgendamentoDAO dao = new AgendamentoDAO();

    public Long agendar(Agendamento a, Usuario usuarioLogado) throws SQLException {
        if (usuarioLogado == null || !"Cliente".equalsIgnoreCase(usuarioLogado.getTipoUsuario())) {
            throw new IllegalArgumentException("Apenas clientes podem agendar.");
        }
        if (a.getCliente() == null || a.getProfissional() == null
                || a.getDataAgendamento() == null || a.getHorarioAgendamento() == null) {
            throw new IllegalArgumentException("Dados de agendamento incompletos.");
        }

        LocalDate hoje = LocalDate.now();
        LocalDate dataAg = ((java.sql.Date) a.getDataAgendamento()).toLocalDate();
        if (dataAg.isBefore(hoje)) {
            throw new IllegalArgumentException("A data do agendamento não pode ser no passado.");
        }
        if (dataAg.isEqual(hoje)) {
            LocalTime horaAg = LocalTime.parse(a.getHorarioAgendamento());
            if (horaAg.isBefore(LocalTime.now())) {
                throw new IllegalArgumentException("O horário selecionado já passou para hoje.");
            }
        }

        Time hora = Time.valueOf(a.getHorarioAgendamento() + ":00");
        boolean conflito = dao.existeConflito(a.getProfissional().getIdProfissional(),
                new java.sql.Date(a.getDataAgendamento().getTime()), hora);
        if (conflito) {
            throw new IllegalArgumentException("Horário indisponível para este profissional.");
        }

        return dao.inserir(a);
    }

    public void concluir(long idAgendamento) throws SQLException {
        Agendamento ag = dao.buscarPorId(idAgendamento);
        if (ag == null) {
            throw new IllegalArgumentException("Agendamento não encontrado");
        }

        if ("Cancelado".equalsIgnoreCase(ag.getStatusAgendamento())) {
            return;
        }

        java.util.Date agora = new java.util.Date();
        if ("Pendente".equalsIgnoreCase(ag.getStatusAgendamento()) && ag.getDataAgendamento().before(agora)) {
            dao.atualizarStatus(idAgendamento, "Concluído");
        } else if ("Pendente".equalsIgnoreCase(ag.getStatusAgendamento())) {
            dao.atualizarStatus(idAgendamento, "Concluído");
        }
    }

    public void cancelar(long idAgendamento) throws SQLException {
        dao.atualizarStatus(idAgendamento, "Cancelado");
    }

    public int contarCliente(String status, long idCliente) throws SQLException {
        return dao.contarPorClienteStatus(idCliente, status);
    }

    public int contarProf(String status, long idProf) throws SQLException {
        return dao.contarPorProfissionalStatus(idProf, status);
    }

    public int autoConcluirExpirados() throws SQLException {
        return dao.confirmarPendentesExpirados();
    }
}
