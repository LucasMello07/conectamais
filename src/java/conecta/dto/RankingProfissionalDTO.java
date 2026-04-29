package conecta.dto;

/**
 * 
 * @author Sebas
 */
public class RankingProfissionalDTO {
    private Long idProfissional;
    private String nomeCompleto;
    private Double mediaNota;
    private Integer qtdAvaliacoes;
    private Integer posicao;
    private Integer qtdFavoritos;

    public RankingProfissionalDTO() {}

    public RankingProfissionalDTO(Long idProfissional, String nomeCompleto,
                                  Double mediaNota, Integer qtdAvaliacoes,
                                  Integer posicao, Integer qtdFavoritos) {
        this.idProfissional = idProfissional;
        this.nomeCompleto = nomeCompleto;
        this.mediaNota = mediaNota;
        this.qtdAvaliacoes = qtdAvaliacoes;
        this.posicao = posicao;
        this.qtdFavoritos = qtdFavoritos;
    }

    public Long getIdProfissional() { return idProfissional; }
    public void setIdProfissional(Long idProfissional) { this.idProfissional = idProfissional; }
    public String getNomeCompleto() { return nomeCompleto; }
    public void setNomeCompleto(String nomeCompleto) { this.nomeCompleto = nomeCompleto; }
    public Double getMediaNota() { return mediaNota; }
    public void setMediaNota(Double mediaNota) { this.mediaNota = mediaNota; }
    public Integer getQtdAvaliacoes() { return qtdAvaliacoes; }
    public void setQtdAvaliacoes(Integer qtdAvaliacoes) { this.qtdAvaliacoes = qtdAvaliacoes; }
    public Integer getPosicao() { return posicao; }
    public void setPosicao(Integer posicao) { this.posicao = posicao; }
    public Integer getQtdFavoritos() { return qtdFavoritos; }
    public void setQtdFavoritos(Integer qtdFavoritos) { this.qtdFavoritos = qtdFavoritos; }
}
