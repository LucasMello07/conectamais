package conecta.dto;

/**
 * DTO de perfil do profissional para telas de visualização.
 * Mantém apenas os dados necessários para exibir o cartão/perfil.
 *
 * @author Sebas
 */
public class ProfissionalDTO {

    private Long idProfissional;
    private String nomeCompleto;
    private String cidade;
    private String estado;
    private String telefoneComercial;
    private String enderecoComercial;

    public Long getIdProfissional() {
        return idProfissional;
    }
    public void setIdProfissional(Long idProfissional) {
        this.idProfissional = idProfissional;
    }

    public String getNomeCompleto() {
        return nomeCompleto;
    }
    public void setNomeCompleto(String nomeCompleto) {
        this.nomeCompleto = nomeCompleto;
    }

    public String getCidade() {
        return cidade;
    }
    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public String getEstado() {
        return estado;
    }
    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getTelefoneComercial() {
        return telefoneComercial;
    }
    public void setTelefoneComercial(String telefoneComercial) {
        this.telefoneComercial = telefoneComercial;
    }

    public String getEnderecoComercial() {
        return enderecoComercial;
    }
    public void setEnderecoComercial(String enderecoComercial) {
        this.enderecoComercial = enderecoComercial;
    }
}
