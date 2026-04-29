package conecta.dto;

/**
 * DTO simples para listar habilidades em cartões/tabelas.
 *
 * @author Sebas
 */
public class HabilidadeDTO {

    private Long idHabilidade;
    private String titulo;
    private String descricao;
    private String status; // "Ativo" / "Inativo"

    public Long getIdHabilidade() {
        return idHabilidade;
    }
    public void setIdHabilidade(Long idHabilidade) {
        this.idHabilidade = idHabilidade;
    }

    public String getTitulo() {
        return titulo;
    }
    public void setTitulo(String titulo) {
        this.titulo = titulo;
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
}
