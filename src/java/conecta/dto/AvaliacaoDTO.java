package conecta.dto;

import java.io.Serializable;

/**
 * AvaliacaoDTO
 * Camada de transporte para exibição de avaliações em JSP.
 * Converte a nota textual (enum) para valor numérico 1..5 (notaValor).
 * 
 * @author Sebas
 */
public class AvaliacaoDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer idAvaliacao;
    private String nomeCliente;       
    private String comentarioAvaliacao; 
    private String nota;                 
    private Integer notaValor;           

    public AvaliacaoDTO() {}

    public AvaliacaoDTO(Integer idAvaliacao, String nomeCliente, String comentarioAvaliacao, String nota) {
        this.idAvaliacao = idAvaliacao;
        this.nomeCliente = nomeCliente;
        this.comentarioAvaliacao = comentarioAvaliacao;
        this.nota = nota;
        this.notaValor = mapNotaToValor(nota);
    }

    private int mapNotaToValor(String n) {
        if (n == null) return 0;
        switch (n) {
            case "Ruim":        return 1;
            case "Regular":     return 2;
            case "Bom":         return 3;
            case "Ótimo":       return 4;
            case "Excelente":   return 5;
            default:            return 0;
        }
    }

    public Integer getIdAvaliacao() {
        return idAvaliacao;
    }

    public void setIdAvaliacao(Integer idAvaliacao) {
        this.idAvaliacao = idAvaliacao;
    }

    public String getNomeCliente() {
        return nomeCliente;
    }

    public void setNomeCliente(String nomeCliente) {
        this.nomeCliente = nomeCliente;
    }

    public String getComentarioAvaliacao() {
        return comentarioAvaliacao;
    }

    public void setComentarioAvaliacao(String comentarioAvaliacao) {
        this.comentarioAvaliacao = comentarioAvaliacao;
    }

    public String getNota() {
        return nota;
    }

    public void setNota(String nota) {
        this.nota = nota;
        this.notaValor = mapNotaToValor(nota);
    }

    public Integer getNotaValor() {
        return notaValor;
    }

    public void setNotaValor(Integer notaValor) {
        this.notaValor = notaValor;
    }
}
