package conecta.dto;

import java.util.Date;

/** @author Sebas */
public class ModeracaoUsuarioDTO {
    private int idUsuario;
    private String nomeUsuario;
    private String statusUsuario; // ATIVO, SUSPENSO, BANIDO
    private String tipoAcao;      // SUSPENDER, BANIR, INVALIDAR
    private Date dataAcao;

    // Getters e Setters
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNomeUsuario() { return nomeUsuario; }
    public void setNomeUsuario(String nomeUsuario) { this.nomeUsuario = nomeUsuario; }

    public String getStatusUsuario() { return statusUsuario; }
    public void setStatusUsuario(String statusUsuario) { this.statusUsuario = statusUsuario; }

    public String getTipoAcao() { return tipoAcao; }
    public void setTipoAcao(String tipoAcao) { this.tipoAcao = tipoAcao; }

    public Date getDataAcao() { return dataAcao; }
    public void setDataAcao(Date dataAcao) { this.dataAcao = dataAcao; }
}
