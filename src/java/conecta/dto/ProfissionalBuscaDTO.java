package conecta.dto;

/**
 *
 * @author Sebas
 */
public class ProfissionalBuscaDTO {
    private long idProfissional;
    private String nomeCompleto;
    private String cidade;
    private String estado;
    private String telefoneComercial;
    /** títulos de habilidades separados por "||" (já agrupados no SQL) */
    private String habilidadesCsv;

    public long getIdProfissional() { return idProfissional; }
    public void setIdProfissional(long idProfissional) { this.idProfissional = idProfissional; }

    public String getNomeCompleto() { return nomeCompleto; }
    public void setNomeCompleto(String nomeCompleto) { this.nomeCompleto = nomeCompleto; }

    public String getCidade() { return cidade; }
    public void setCidade(String cidade) { this.cidade = cidade; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getTelefoneComercial() { return telefoneComercial; }
    public void setTelefoneComercial(String telefoneComercial) { this.telefoneComercial = telefoneComercial; }

    public String getHabilidadesCsv() { return habilidadesCsv; }
    public void setHabilidadesCsv(String habilidadesCsv) { this.habilidadesCsv = habilidadesCsv; }
}
