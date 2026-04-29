package conecta.entidades;

import java.util.Date;

/** 
 *
 * @author Sebas
 */
public class Agendamento {

    private Long idAgendamento;
    private Cliente cliente;
    private Profissional profissional;
    private Date dataAgendamento;
    private String horarioAgendamento;
    private String statusAgendamento;
    private Boolean jaAvaliado;
    private Long idHabilidade;
    private boolean jaDenunciado; // ✅ FLAG

    public Long getIdAgendamento() { return idAgendamento; }
    public void setIdAgendamento(Long idAgendamento) { this.idAgendamento = idAgendamento; }

    public Cliente getCliente() { return cliente; }
    public void setCliente(Cliente cliente) { this.cliente = cliente; }

    public Profissional getProfissional() { return profissional; }
    public void setProfissional(Profissional profissional) { this.profissional = profissional; }

    public Date getDataAgendamento() { return dataAgendamento; }
    public void setDataAgendamento(Date dataAgendamento) { this.dataAgendamento = dataAgendamento; }

    public String getHorarioAgendamento() { return horarioAgendamento; }
    public void setHorarioAgendamento(String horarioAgendamento) { this.horarioAgendamento = horarioAgendamento; }

    public String getStatusAgendamento() { return statusAgendamento; }
    public void setStatusAgendamento(String statusAgendamento) { this.statusAgendamento = statusAgendamento; }

    public Boolean getJaAvaliado() { return jaAvaliado; }
    public void setJaAvaliado(Boolean jaAvaliado) { this.jaAvaliado = jaAvaliado; }
    
    public Long getIdHabilidade() { return idHabilidade; }
    public void setIdHabilidade(Long idHabilidade) { this.idHabilidade = idHabilidade; }

    public boolean isJaDenunciado() { return jaDenunciado; }
    public void setJaDenunciado(boolean jaDenunciado) { this.jaDenunciado = jaDenunciado; }
}
