package conecta.entidades;

import jakarta.validation.constraints.NotNull;

/**
 *
 * @author Sebas
 */
public class Administrador {

    @NotNull
    private Long idAdmin;       // = fk id_usuario na tabela ADMINISTRADOR (

    @NotNull
    private Usuario usuario;    // Relacionamento com USUARIOS

    public Long getIdAdmin() {
        return idAdmin;
    }

    public void setIdAdmin(Long idAdmin) {
        this.idAdmin = idAdmin;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
