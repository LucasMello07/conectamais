<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Conecta+: Cadastro</title>
  <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
  <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="flex items-center justify-center min-h-screen bg-gray-50" style="font-family: 'Poppins', sans-serif;">

  <div class="w-full max-w-3xl bg-white rounded-2xl shadow-lg p-8">

    <!-- Logo -->
    <div class="flex justify-center mb-6">
      <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
    </div>

    <h2 class="text-2xl font-bold text-center text-slate-700 mb-6">Crie sua conta</h2>

    <!-- Mensagem de Sucesso -->
    <c:if test="${not empty sucesso}">
      <div class="mb-4 p-3 text-sm text-green-700 bg-green-100 border border-green-300 rounded-lg">
        ${sucesso}
      </div>
    </c:if>

    <!-- Mensagem de Erro -->
    <c:if test="${not empty erro}">
      <div class="mb-4 p-3 text-sm text-red-600 bg-red-100 border border-red-300 rounded-lg">
        ${erro}
      </div>
    </c:if>

    <!-- Botões -->
    <div class="flex justify-center gap-6 mb-6">
      <button type="button" onclick="mostrarFormulario('cliente')" class="px-6 py-3 rounded-xl bg-blue-600 text-white font-semibold hover:bg-blue-700 transition">
        Sou Cliente
      </button>
      <button type="button" onclick="mostrarFormulario('profissional')" class="px-6 py-3 rounded-xl bg-green-600 text-white font-semibold hover:bg-green-700 transition">
        Sou Profissional
      </button>
    </div>

    <!-- Formulário Cliente -->
    <form id="form-cliente" action="${pageContext.request.contextPath}/CadastroClienteServlet" method="post" class="hidden space-y-4">
      
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Nome Completo</label>
          <input type="text" name="nomeCompleto" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Data de Nascimento</label>
          <input type="date" name="dataNascimento" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
        </div>
      </div>

      <div>
        <label class="block text-sm font-semibold text-slate-600 mb-1">Gênero</label>
        <select name="genero" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
          <option value="">Selecione</option>
          <option value="Masculino">Masculino</option>
          <option value="Feminino">Feminino</option>
          <option value="Prefiro não dizer">Prefiro não dizer</option>
        </select>
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Celular</label>
          <input type="text" name="celular" maxlength="11" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">CPF</label>
          <input type="text" name="cpf" maxlength="15" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
        </div>
      </div>

      <div>
        <label class="block text-sm font-semibold text-slate-600 mb-1">Email</label>
        <input type="email" name="email" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Senha</label>
          <input type="password" name="senha" id="senha-cliente" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Confirmar Senha</label>
          <input type="password" id="confirmar-cliente" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
        </div>
      </div>

      <div class="grid grid-cols-3 gap-4">
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Rua</label>
          <input type="text" name="enderecoRua" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Bairro</label>
          <input type="text" name="bairro" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Cidade</label>
          <input type="text" name="cidade" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
        </div>
      </div>

      <div>
        <label class="block text-sm font-semibold text-slate-600 mb-1">Estado</label>
        <input type="text" name="estado" maxlength="2" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
      </div>

      <button type="submit" onclick="return validarSenha('cliente')" class="w-full py-2 mt-4 bg-gradient-to-r from-blue-600 to-green-400 text-white font-semibold rounded-lg hover:opacity-90 transition">
        Cadastrar Cliente
      </button>
    </form>

    <!-- Formulário Profissional -->
    <form id="form-profissional" action="${pageContext.request.contextPath}/CadastroProfissionalServlet" method="post" class="hidden space-y-4">
      
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Nome Completo</label>
          <input type="text" name="nomeCompleto" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Data de Nascimento</label>
          <input type="date" name="dataNascimento" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
        </div>
      </div>

      <div>
        <label class="block text-sm font-semibold text-slate-600 mb-1">Gênero</label>
        <select name="genero" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
          <option value="">Selecione</option>
          <option value="Masculino">Masculino</option>
          <option value="Feminino">Feminino</option>
          <option value="Prefiro não dizer">Prefiro não dizer</option>
        </select>
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Celular</label>
          <input type="text" name="celular" maxlength="11" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">CPF/CNPJ</label>
          <input type="text" name="cpfCnpj" maxlength="15" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
        </div>
      </div>

      <div>
        <label class="block text-sm font-semibold text-slate-600 mb-1">Email</label>
        <input type="email" name="email" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
      </div>

      <div class="grid grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Senha</label>
          <input type="password" name="senha" id="senha-prof" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Confirmar Senha</label>
          <input type="password" id="confirmar-prof" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
        </div>
      </div>

      <div class="grid grid-cols-3 gap-4">
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Rua</label>
          <input type="text" name="enderecoRua" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Bairro</label>
          <input type="text" name="bairro" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
        </div>
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Cidade</label>
          <input type="text" name="cidade" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
        </div>
      </div>

      <div>
        <label class="block text-sm font-semibold text-slate-600 mb-1">Estado</label>
        <input type="text" name="estado" maxlength="2" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
      </div>

      <!-- 🔹 Campos extras para Profissional futuramente (habilidades, especialidades etc.) -->

      <button type="submit" onclick="return validarSenha('prof')" class="w-full py-2 mt-4 bg-gradient-to-r from-green-600 to-blue-400 text-white font-semibold rounded-lg hover:opacity-90 transition">
        Cadastrar Profissional
      </button>
    </form>

    <!-- Voltar para login -->
    <div class="text-center mt-6 text-sm">
      <a href="${pageContext.request.contextPath}/pages/landing-Page/login.jsp" class="text-blue-600 hover:underline">Já tenho uma conta</a>
    </div>
  </div>

  <!-- Scripts -->
  <script>
    function mostrarFormulario(tipo) {
      document.getElementById('form-cliente').classList.add('hidden');
      document.getElementById('form-profissional').classList.add('hidden');
      if (tipo === 'cliente') {
        document.getElementById('form-cliente').classList.remove('hidden');
      } else {
        document.getElementById('form-profissional').classList.remove('hidden');
      }
    }

    function validarSenha(tipo) {
      let senha, confirmar;
      if (tipo === 'cliente') {
        senha = document.getElementById('senha-cliente').value;
        confirmar = document.getElementById('confirmar-cliente').value;
      } else {
        senha = document.getElementById('senha-prof').value;
        confirmar = document.getElementById('confirmar-prof').value;
      }

      if (senha.length < 8) {
        alert("A senha deve ter no mínimo 8 caracteres.");
        return false;
      }
      if (senha !== confirmar) {
        alert("As senhas não coincidem.");
        return false;
      }
      return true;
    }
  </script>
</body>
</html>
