package conecta.dto;

/**
 * Card de favorito no perfil do cliente (área = concat de habilidades ativas)
 * @author Sebas
 */
public class ProfissionalFavoritoDTO {
    private Long idProfissional;
    private String nomeProfissional;
    private String areaAtuacao;   // ex.: "Corte, Pintura"
    private String dataFavorito;  // já formatada

    public Long getIdProfissional() { return idProfissional; }
    public void setIdProfissional(Long idProfissional) { this.idProfissional = idProfissional; }
    public String getNomeProfissional() { return nomeProfissional; }
    public void setNomeProfissional(String nomeProfissional) { this.nomeProfissional = nomeProfissional; }
    public String getAreaAtuacao() { return areaAtuacao; }
    public void setAreaAtuacao(String areaAtuacao) { this.areaAtuacao = areaAtuacao; }
    public String getDataFavorito() { return dataFavorito; }
    public void setDataFavorito(String dataFavorito) { this.dataFavorito = dataFavorito; }
}
