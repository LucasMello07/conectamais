package conecta.entidades;

import jakarta.validation.constraints.NotNull;

/**
 *
 * @author Sebas
 */
public class Profissional {

    @NotNull
    private Long idProfissional;        // = FK id_usuario na tabela PROFISSIONAIS

    private String enderecoComercial;   

    @NotNull
    private String telefoneComercial;

    @NotNull
    private Usuario usuario;            // Relacionamento com USUARIOS

    public Long getIdProfissional() {
        return idProfissional;
    }

    public void setIdProfissional(Long idProfissional) {
        this.idProfissional = idProfissional;
    }

    public String getEnderecoComercial() {
        return enderecoComercial;
    }

    public void setEnderecoComercial(String enderecoComercial) {
        this.enderecoComercial = enderecoComercial;
    }

    public String getTelefoneComercial() {
        return telefoneComercial;
    }

    public void setTelefoneComercial(String telefoneComercial) {
        this.telefoneComercial = telefoneComercial;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
