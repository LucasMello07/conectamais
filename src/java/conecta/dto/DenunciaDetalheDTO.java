package conecta.dto;

import java.util.Date;

/** @author Sebas */
public class DenunciaDetalheDTO {
    private int idDenuncia;
    private int idAgendamento;
    private String motivo;
    private String descricao;
    private String status;
    private Date dataDenuncia;

    // Campos de moderação
    private String acaoTomada;
    private String observacaoModeracao;
    private Date prazoSuspensao;
    private Date dataModeracao;

    // Cliente
    private int clienteIdUsuario;
    private String clienteNome;
    private String clienteEmail;

    // Profissional
    private int profissionalIdUsuario;
    private String profissionalNome;
    private String profissionalEmail;

    // Getters e Setters
    public int getIdDenuncia() {
        return idDenuncia;
    }

    public void setIdDenuncia(int idDenuncia) {
        this.idDenuncia = idDenuncia;
    }

    public int getIdAgendamento() {
        return idAgendamento;
    }

    public void setIdAgendamento(int idAgendamento) {
        this.idAgendamento = idAgendamento;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDataDenuncia() {
        return dataDenuncia;
    }

    public void setDataDenuncia(Date dataDenuncia) {
        this.dataDenuncia = dataDenuncia;
    }

    public String getAcaoTomada() {
        return acaoTomada;
    }

    public void setAcaoTomada(String acaoTomada) {
        this.acaoTomada = acaoTomada;
    }

    public String getObservacaoModeracao() {
        return observacaoModeracao;
    }

    public void setObservacaoModeracao(String observacaoModeracao) {
        this.observacaoModeracao = observacaoModeracao;
    }

    public Date getPrazoSuspensao() {
        return prazoSuspensao;
    }

    public void setPrazoSuspensao(Date prazoSuspensao) {
        this.prazoSuspensao = prazoSuspensao;
    }

    public Date getDataModeracao() {
        return dataModeracao;
    }

    public void setDataModeracao(Date dataModeracao) {
        this.dataModeracao = dataModeracao;
    }

    public int getClienteIdUsuario() {
        return clienteIdUsuario;
    }

    public void setClienteIdUsuario(int clienteIdUsuario) {
        this.clienteIdUsuario = clienteIdUsuario;
    }

    public String getClienteNome() {
        return clienteNome;
    }

    public void setClienteNome(String clienteNome) {
        this.clienteNome = clienteNome;
    }

    public String getClienteEmail() {
        return clienteEmail;
    }

    public void setClienteEmail(String clienteEmail) {
        this.clienteEmail = clienteEmail;
    }

    public int getProfissionalIdUsuario() {
        return profissionalIdUsuario;
    }

    public void setProfissionalIdUsuario(int profissionalIdUsuario) {
        this.profissionalIdUsuario = profissionalIdUsuario;
    }

    public String getProfissionalNome() {
        return profissionalNome;
    }

    public void setProfissionalNome(String profissionalNome) {
        this.profissionalNome = profissionalNome;
    }

    public String getProfissionalEmail() {
        return profissionalEmail;
    }

    public void setProfissionalEmail(String profissionalEmail) {
        this.profissionalEmail = profissionalEmail;
    }
}
