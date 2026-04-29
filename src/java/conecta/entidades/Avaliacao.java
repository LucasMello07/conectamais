package conecta.entidades;

import jakarta.validation.constraints.NotNull;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Sebas
 */
public class Avaliacao {

    private Long idAvaliacao;

    @NotNull
    private Cliente cliente;

    @NotNull
    private Profissional profissional;

    @NotNull
    private Agendamento agendamento;

    @NotNull
    private String nota;

    private String comentarioAvaliacao;

    private Date dataAvaliacao;

    public Long getIdAvaliacao() { return idAvaliacao; }
    public void setIdAvaliacao(Long idAvaliacao) { this.idAvaliacao = idAvaliacao; }

    public Cliente getCliente() { return cliente; }
    public void setCliente(Cliente cliente) { this.cliente = cliente; }

    public Profissional getProfissional() { return profissional; }
    public void setProfissional(Profissional profissional) { this.profissional = profissional; }

    public Agendamento getAgendamento() { return agendamento; }
    public void setAgendamento(Agendamento agendamento) { this.agendamento = agendamento; }

    public String getNota() { return nota; }
    public void setNota(String nota) { this.nota = nota; }

    public String getComentarioAvaliacao() { return comentarioAvaliacao; }
    public void setComentarioAvaliacao(String comentarioAvaliacao) { this.comentarioAvaliacao = comentarioAvaliacao; }

    public Date getDataAvaliacao() { return dataAvaliacao; }
    public void setDataAvaliacao(Date dataAvaliacao) { this.dataAvaliacao = dataAvaliacao; }

    // Helpers

    public String getDataAvaliacaoFmt() {
        if (dataAvaliacao == null) return null;
        return new SimpleDateFormat("dd/MM/yyyy").format(dataAvaliacao);
    }

    public String getDataAgendamentoFmt() {
        if (agendamento == null || agendamento.getDataAgendamento() == null) return null;
        return new SimpleDateFormat("dd/MM/yyyy").format(agendamento.getDataAgendamento());
    }

    public int getNotaValor() {
        if (nota == null) return 0;
        return switch (nota.trim().toLowerCase()) {
            case "ruim" -> 1;
            case "regular" -> 2;
            case "bom" -> 3;
            case "ótimo", "otimo" -> 4;
            case "excelente" -> 5;
            default -> 0;
        };
    }

    public String getNomeProfissional() {
        if (profissional == null || profissional.getUsuario() == null) return null;
        return profissional.getUsuario().getNomeCompleto();
    }
}
