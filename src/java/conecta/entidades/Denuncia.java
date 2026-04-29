package conecta.entidades;

import jakarta.validation.constraints.NotNull;
import java.util.Date;

/**
 * @author Sebas
 */
public class Denuncia {

    private Long idDenuncia;

    @NotNull
    private Agendamento agendamento;   // FK AGENDAMENTOS

    @NotNull
    private Usuario denunciante;       // FK USUARIOS

    @NotNull
    private Usuario denunciado;        // FK USUARIOS

    @NotNull
    private String motivoDenuncia;     // ENUM no banco

    private String descricaoDenuncia;

    private String statusDenuncia;

    // --- novos campos do fluxo de moderação ---
    private Date dataDenuncia;             // DEFAULT CURRENT_TIMESTAMP
    private String acaoTomada;             // NENHUMA | SUSPENDER | BANIR | INVALIDAR
    private String observacaoModeracao;    // texto livre
    private Date prazoSuspensao;           // se SUSPENDER
    private Usuario moderador;             // admin que moderou
    private Date dataModeracao;            // quando moderou

    // getters/setters

    public Long getIdDenuncia() { return idDenuncia; }
    public void setIdDenuncia(Long idDenuncia) { this.idDenuncia = idDenuncia; }

    public Agendamento getAgendamento() { return agendamento; }
    public void setAgendamento(Agendamento agendamento) { this.agendamento = agendamento; }

    public Usuario getDenunciante() { return denunciante; }
    public void setDenunciante(Usuario denunciante) { this.denunciante = denunciante; }

    public Usuario getDenunciado() { return denunciado; }
    public void setDenunciado(Usuario denunciado) { this.denunciado = denunciado; }

    public String getMotivoDenuncia() { return motivoDenuncia; }
    public void setMotivoDenuncia(String motivoDenuncia) { this.motivoDenuncia = motivoDenuncia; }

    public String getDescricaoDenuncia() { return descricaoDenuncia; }
    public void setDescricaoDenuncia(String descricaoDenuncia) { this.descricaoDenuncia = descricaoDenuncia; }

    public String getStatusDenuncia() { return statusDenuncia; }
    public void setStatusDenuncia(String statusDenuncia) { this.statusDenuncia = statusDenuncia; }

    public Date getDataDenuncia() { return dataDenuncia; }
    public void setDataDenuncia(Date dataDenuncia) { this.dataDenuncia = dataDenuncia; }

    public String getAcaoTomada() { return acaoTomada; }
    public void setAcaoTomada(String acaoTomada) { this.acaoTomada = acaoTomada; }

    public String getObservacaoModeracao() { return observacaoModeracao; }
    public void setObservacaoModeracao(String observacaoModeracao) { this.observacaoModeracao = observacaoModeracao; }

    public Date getPrazoSuspensao() { return prazoSuspensao; }
    public void setPrazoSuspensao(Date prazoSuspensao) { this.prazoSuspensao = prazoSuspensao; }

    public Usuario getModerador() { return moderador; }
    public void setModerador(Usuario moderador) { this.moderador = moderador; }

    public Date getDataModeracao() { return dataModeracao; }
    public void setDataModeracao(Date dataModeracao) { this.dataModeracao = dataModeracao; }
}
