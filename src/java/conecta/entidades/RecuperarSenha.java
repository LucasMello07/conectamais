package conecta.entidades;

import java.util.Date;
import jakarta.validation.constraints.NotNull;

/**
 *
 * @author Sebas
 */
public class RecuperarSenha {

    private Long idRecuperacao;  

    @NotNull
    private Usuario usuario;      // FK para USUARIOS

    @NotNull
    private String token;

    @NotNull
    private Date dataExpiracao;

    private Boolean usado;

    public Long getIdRecuperacao() {
        return idRecuperacao;
    }

    public void setIdRecuperacao(Long idRecuperacao) {
        this.idRecuperacao = idRecuperacao;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getDataExpiracao() {
        return dataExpiracao;
    }

    public void setDataExpiracao(Date dataExpiracao) {
        this.dataExpiracao = dataExpiracao;
    }

    public Boolean getUsado() {
        return usado;
    }

    public void setUsado(Boolean usado) {
        this.usado = usado;
    }
}
