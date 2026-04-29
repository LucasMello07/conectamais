package conecta.service;

import conecta.dao.UsuarioDAO;
import conecta.entidades.Usuario;

import java.sql.SQLException;
import java.util.Objects;

/**
 * Regras de negócio do Usuário.
 * Inclui atualização básica de perfil e troca de senha.
 *
 * Obs.: Senha em texto conforme schema atual. Podemos migrar para hash depois.
 * @author Sebas
 */
public class UsuarioService {

    private final UsuarioDAO usuarioDAO;

    public UsuarioService() {
        this.usuarioDAO = new UsuarioDAO();
    }

    /* ========================= Consultas ========================= */

    public Usuario buscarPorId(long id) throws SQLException {
        return usuarioDAO.buscarPorId(id);
    }

    /* ========================= Cadastro/Atualização ========================= */

    public void cadastrarUsuario(Usuario usuario) throws SQLException {
        validarParaCadastro(usuario);
        usuarioDAO.cadastrar(usuario);
    }

    public void atualizarUsuario(Usuario usuario) throws SQLException {
        Objects.requireNonNull(usuario, "Usuário não pode ser nulo");
        if (usuario.getIdUsuario() == null) {
            throw new IllegalArgumentException("ID do usuário é obrigatório para atualizar.");
        }
        usuarioDAO.atualizar(usuario);
    }

    public void atualizarBasico(long idUsuario,
                            String nomeCompleto,
                            String celular,
                            String email,
                            String genero,
                            String enderecoRua,
                            String bairro,
                            String cidade,
                            String estado) throws SQLException {

            Usuario atual = usuarioDAO.buscarPorId(idUsuario);
            if (atual == null) throw new IllegalArgumentException("Usuário não encontrado (id=" + idUsuario + ").");

            // obrigatórios: se vierem vazios, mantém o atual
            if (isBlank(nomeCompleto)) nomeCompleto = atual.getNomeCompleto();
            if (isBlank(email))        email        = atual.getEmail();

            // limpa celular: só dígitos (10 ou 11). Se vier inválido, mantém o atual.
            String celLimpo = normalizePhone(celular);
            if (celLimpo == null) {
                celLimpo = atual.getCelular(); // preserva
            }

            genero      = isBlank(genero)      ? atual.getGenero()      : genero.trim();
            enderecoRua = isBlank(enderecoRua) ? atual.getEnderecoRua() : enderecoRua.trim();
            bairro      = isBlank(bairro)      ? atual.getBairro()      : bairro.trim();
            cidade      = isBlank(cidade)      ? atual.getCidade()      : cidade.trim();
            estado      = isBlank(estado)      ? atual.getEstado()      : estado.trim();

            atual.setNomeCompleto(nomeCompleto.trim());
            atual.setCelular(celLimpo);
            atual.setEmail(email.trim());
            atual.setGenero(genero);
            atual.setEnderecoRua(enderecoRua);
            atual.setBairro(bairro);
            atual.setCidade(cidade);
            atual.setEstado(estado);

            usuarioDAO.atualizar(atual);
        }

    private String normalizePhone(String s) {
            if (s == null) return null;
            String d = s.replaceAll("\\D", "");
            if (d.length() >= 10) {
                return d.substring(0, Math.min(11, d.length())); // até 11
            }
            return null;
        }


    /* ========================= Troca de senha ========================= */

    public void trocarSenha(long idUsuario, String senhaAtual, String novaSenha, String confirma) throws SQLException {
        if (isBlank(senhaAtual)) throw new IllegalArgumentException("Informe a senha atual.");
        if (isBlank(novaSenha))  throw new IllegalArgumentException("Informe a nova senha.");
        if (novaSenha.length() < 6) throw new IllegalArgumentException("A nova senha deve ter pelo menos 6 caracteres.");
        if (!Objects.equals(novaSenha, confirma)) {
            throw new IllegalArgumentException("A confirmação da senha não confere.");
        }

        String senhaBanco = usuarioDAO.buscarSenhaPorId(idUsuario);
        if (senhaBanco == null) throw new IllegalArgumentException("Usuário não encontrado.");
        if (!Objects.equals(senhaBanco, senhaAtual)) {
            throw new IllegalArgumentException("Senha atual inválida.");
        }

        usuarioDAO.atualizarSenha(idUsuario, novaSenha);
    }

    /* ========================= Exclusão ========================= */

    public void deletarUsuario(long id) throws SQLException {
        usuarioDAO.deletar(id);
    }

    /* ========================= Validações/Utils ========================= */

    private void validarParaCadastro(Usuario u) {
        Objects.requireNonNull(u, "Usuário não pode ser nulo");
        if (isBlank(u.getNomeCompleto())) throw new IllegalArgumentException("O nome completo é obrigatório.");
        if (isBlank(u.getEmail()))        throw new IllegalArgumentException("O e-mail é obrigatório.");
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
    private String trimOrNull(String s) {
        return s == null ? null : s.trim();
    }
}
