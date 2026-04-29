package conecta.entidades;

import jakarta.validation.constraints.NotNull;

/**
 *
 * @author Sebas
 */
public class Cliente {

    @NotNull
    private Long idCliente;     // = fk id_usuario na tabela CLIENTES

    @NotNull
    private Usuario usuario;    // Relacionamento com USUARIOS

    public Long getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Long idCliente) {
        this.idCliente = idCliente;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
