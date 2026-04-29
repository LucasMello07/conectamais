package conecta.dto;

/**
 * Resumo das avaliações feitas pelo cliente (para listagem no perfil do cliente)
 * @author Sebas
 */
public class AvaliacaoResumoDTO {
    private Long idAvaliacao;
    private String nota;             // enum textual
    private String comentario;       // comentario_avaliacao
    private String dataAvaliacao;    // dd/MM/yyyy
    private String nomeProfissional;
    private String tituloServico;    // pode vir null

    public Long getIdAvaliacao() { return idAvaliacao; }
    public void setIdAvaliacao(Long idAvaliacao) { this.idAvaliacao = idAvaliacao; }
    public String getNota() { return nota; }
    public void setNota(String nota) { this.nota = nota; }
    public String getComentario() { return comentario; }
    public void setComentario(String comentario) { this.comentario = comentario; }
    public String getDataAvaliacao() { return dataAvaliacao; }
    public void setDataAvaliacao(String dataAvaliacao) { this.dataAvaliacao = dataAvaliacao; }
    public String getNomeProfissional() { return nomeProfissional; }
    public void setNomeProfissional(String nomeProfissional) { this.nomeProfissional = nomeProfissional; }
    public String getTituloServico() { return tituloServico; }
    public void setTituloServico(String tituloServico) { this.tituloServico = tituloServico; }
}
