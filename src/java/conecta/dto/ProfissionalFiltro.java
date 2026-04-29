package conecta.dto;

/**
 * DTO usado como filtro na busca de profissionais.
 * 
 * @author Sebas
 */
public class ProfissionalFiltro {
    private String termo;
    private String cidade;
    private String estado;
    private int limit = 20;
    private int offset = 0;

    // Getters e Setters
    public String getTermo() { return termo; }
    public void setTermo(String termo) { this.termo = termo; }

    public String getCidade() { return cidade; }
    public void setCidade(String cidade) { this.cidade = cidade; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public int getLimit() { return limit; }
    public void setLimit(int limit) { this.limit = limit; }

    public int getOffset() { return offset; }
    public void setOffset(int offset) { this.offset = offset; }
}
