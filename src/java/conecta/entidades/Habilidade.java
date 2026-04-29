package conecta.entidades;

/**
 *
 * @author Sebas
 */
public class Habilidade {
    private int idHabilidade;
    private String titulo;
    private String descricao;
    private String status;
    private int idProfissional;

    private String nomeProfissional;

    public int getIdHabilidade() { return idHabilidade; }
    public void setIdHabilidade(int idHabilidade) { this.idHabilidade = idHabilidade; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getIdProfissional() { return idProfissional; }
    public void setIdProfissional(int idProfissional) { this.idProfissional = idProfissional; }

    public String getNomeProfissional() { return nomeProfissional; }
    public void setNomeProfissional(String nomeProfissional) { this.nomeProfissional = nomeProfissional; }
}
