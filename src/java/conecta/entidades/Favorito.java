package conecta.entidades;

import java.util.Date;
import jakarta.validation.constraints.NotNull;

/**
 *
 * @author Sebas
 */
public class Favorito {

    private Long idFavorito;  

    @NotNull
    private Cliente cliente;   // FK para CLIENTES

    @NotNull
    private Profissional profissional;   // FK para PROFISSIONAIS

    private Date dataFavorito;  

    public Long getIdFavorito() {
        return idFavorito;
    }

    public void setIdFavorito(Long idFavorito) {
        this.idFavorito = idFavorito;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public Profissional getProfissional() {
        return profissional;
    }

    public void setProfissional(Profissional profissional) {
        this.profissional = profissional;
    }

    public Date getDataFavorito() {
        return dataFavorito;
    }

    public void setDataFavorito(Date dataFavorito) {
        this.dataFavorito = dataFavorito;
    }
}
