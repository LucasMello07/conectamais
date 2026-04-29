<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  conecta.entidades.Usuario usuarioLogado = (conecta.entidades.Usuario) session.getAttribute("usuarioLogado");
  if (usuarioLogado == null) {
      response.sendRedirect(request.getContextPath() + "/pages/landing-Page/index.jsp");
      return;
  }
%>

<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Conecta+: Trocar Senha</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
    <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <script src="https://cdn.tailwindcss.com"></script>
  </head>

  <body class="m-0 font-sans antialiased font-normal text-base leading-default bg-gray-50 text-slate-600" style="font-family: 'Poppins', sans-serif;">
    
    <!-- Sidebar -->
    <aside class="fixed inset-y-0 my-4 ml-4 block w-60 rounded-2xl bg-white p-4 text-slate-700 shadow-lg">
      <div class="h-20 flex items-center justify-center">
        <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
      </div>

      <c:choose>
        <c:when test="${usuarioLogado.tipoUsuario eq 'Cliente'}">
          <ul class="flex flex-col mt-6 space-y-2">
            <li>
              <a href="${pageContext.request.contextPath}/agendamentos?acao=listarCliente" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-calendar-event-fill"></i>
                </div>
                <span>Meus Agendamentos</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/favoritos?acao=listar" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-star-fill"></i>
                </div>
                <span>Favoritos</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/avaliacoes?acao=listarCliente" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-chat-left-quote-fill"></i>
                </div>
                <span>Avaliações</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/perfil?acao=ver" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-person-circle"></i>
                </div>
                <span>Meu Perfil</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/perfil-senha" class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-key-fill"></i>
                </div>
                <span>Trocar Senha</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/pages/landing-Page/index.jsp" class="flex items-center gap-3 p-2 rounded-lg hover:bg-red-100 text-red-600 font-semibold transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-red-600 to-red-400 text-white">
                  <i class="bi bi-box-arrow-right"></i>
                </div>
                <span>Sair</span>
              </a>
            </li>
          </ul>
        </c:when>

        <c:otherwise>
          <ul class="flex flex-col mt-6 space-y-2">
            <li>
              <a href="${pageContext.request.contextPath}/agendamentos?acao=listarProfissional" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-calendar-event-fill"></i>
                </div>
                <span>Meus Agendamentos</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/habilidades?acao=listar" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-tools"></i>
                </div>
                <span>Minhas Habilidades</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/avaliacoes?acao=listarProfissional" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-chat-left-quote-fill"></i>
                </div>
                <span>Avaliações</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/perfil?acao=ver" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-person-circle"></i>
                </div>
                <span>Meu Perfil</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/perfil-senha" class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                  <i class="bi bi-key-fill"></i>
                </div>
                <span>Trocar Senha</span>
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/pages/landing-Page/index.jsp" class="flex items-center gap-3 p-2 rounded-lg hover:bg-red-100 text-red-600 font-semibold transition">
                <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-red-600 to-red-400 text-white">
                  <i class="bi bi-box-arrow-right"></i>
                </div>
                <span>Sair</span>
              </a>
            </li>
          </ul>
        </c:otherwise>
      </c:choose>
    </aside>

    <!-- Main Content -->
    <main class="ml-72 p-6">
      <nav class="w-full mb-6 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
        <div>
          <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
            <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
            <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Gerenciar perfil / Meu perfil</li>
          </ol>
          <h6 class="mb-0 font-bold capitalize">Alterar Senha</h6>
        </div>
        <div>
          <a href="${pageContext.request.contextPath}/perfil?acao=ver" class="inline-flex items-center gap-2 px-3 py-2 rounded-lg bg-white/20 hover:bg-white/30">
            <i class="bi bi-person-circle"></i> Meu Perfil
          </a>
        </div>
      </nav>

      <section class="bg-white shadow-md rounded-2xl p-6 max-w-2xl mx-auto mt-10">
        <c:if test="${not empty sessionScope.flash}">
          <div class="mb-4 p-3 rounded bg-green-100 text-green-800 border border-green-200">
            ${sessionScope.flash}
          </div>
          <c:remove var="flash" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.flashErro}">
          <div class="mb-4 p-3 rounded bg-red-100 text-red-800 border border-red-200">
            ${sessionScope.flashErro}
          </div>
          <c:remove var="flashErro" scope="session"/>
        </c:if>

        <h1 class="text-xl font-semibold mb-4">Trocar senha</h1>

        <form id="formSenha" action="${pageContext.request.contextPath}/perfil-senha" method="post" class="space-y-4">
          <div>
            <label class="block text-sm text-slate-600">Senha atual</label>
            <div class="relative">
              <input id="senha_atual" type="password" name="senha_atual" class="w-full border rounded p-2 pr-10" required/>
              <button type="button" class="absolute inset-y-0 right-0 px-3 text-slate-500 hover:text-slate-700" aria-label="Mostrar/ocultar senha" data-toggle="senha_atual">
                <i class="bi bi-eye"></i>
              </button>
            </div>
          </div>

          <div>
            <label class="block text-sm text-slate-600">Nova senha</label>
            <div class="relative">
              <input id="nova_senha" type="password" name="nova_senha" class="w-full border rounded p-2 pr-10" minlength="6" required/>
              <button type="button" class="absolute inset-y-0 right-0 px-3 text-slate-500 hover:text-slate-700" aria-label="Mostrar/ocultar senha" data-toggle="nova_senha">
                <i class="bi bi-eye"></i>
              </button>
            </div>
            <p id="hint-min" class="mt-1 text-xs text-slate-500">Mínimo de 6 caracteres.</p>
          </div>

          <div>
            <label class="block text-sm text-slate-600">Confirmar nova senha</label>
            <div class="relative">
              <input id="confirma_senha" type="password" name="confirma_senha" class="w-full border rounded p-2 pr-10" minlength="6" required/>
              <button type="button" class="absolute inset-y-0 right-0 px-3 text-slate-500 hover:text-slate-700" aria-label="Mostrar/ocultar senha" data-toggle="confirma_senha">
                <i class="bi bi-eye"></i>
              </button>
            </div>
            <p id="hint-match" class="mt-1 text-xs"></p>
          </div>

          <div class="flex gap-2 justify-end pt-2">
            <a href="${pageContext.request.contextPath}/perfil?acao=ver"
               class="px-4 py-2 rounded bg-slate-100 text-slate-700 hover:bg-slate-200">
              <i class="bi bi-arrow-left"></i> Voltar
            </a>
            <button id="btnSalvar" class="px-4 py-2 rounded bg-gradient-to-r from-blue-600 to-green-400 text-white hover:opacity-90 disabled:opacity-50 disabled:cursor-not-allowed" disabled>
              <i class="bi bi-key"></i> Salvar nova senha
            </button>
          </div>
        </form>
      </section>
    </main>

    <script>
      (function () {
        // Toggle visibilidade
        document.querySelectorAll('[data-toggle]').forEach(function(btn){
          btn.addEventListener('click', function(){
            const id = btn.getAttribute('data-toggle');
            const input = document.getElementById(id);
            const icon = btn.querySelector('i');
            if (!input) return;
            if (input.type === 'password') {
              input.type = 'text';
              icon.classList.replace('bi-eye', 'bi-eye-slash');
            } else {
              input.type = 'password';
              icon.classList.replace('bi-eye-slash', 'bi-eye');
            }
            input.focus();
          });
        });

        const form = document.getElementById('formSenha');
        const btnSalvar = document.getElementById('btnSalvar');
        const atual = document.getElementById('senha_atual');
        const nova = document.getElementById('nova_senha');
        const conf = document.getElementById('confirma_senha');
        const hintMatch = document.getElementById('hint-match');

        function validate() {
          const novaVal = (nova.value || '').trim();
          const confVal = (conf.value || '').trim();
          const lenOK = novaVal.length >= 6;
          const match = novaVal === confVal && lenOK;

          conf.classList.toggle('border-green-500', match);
          conf.classList.toggle('border-red-500', !match && confVal.length > 0);
          hintMatch.textContent = match ? 'As senhas conferem.' : (confVal.length > 0 ? 'As senhas não conferem.' : '');
          hintMatch.className = 'mt-1 text-xs ' + (match ? 'text-green-600' : (confVal.length > 0 ? 'text-red-600' : 'text-slate-500'));

          btnSalvar.disabled = !(atual.value && lenOK && match);
        }

        [atual, nova, conf].forEach(function(inp){
          inp.addEventListener('input', validate);
          inp.addEventListener('blur', validate);
        });

        form.addEventListener('submit', function(e){
          validate();
          if (btnSalvar.disabled) e.preventDefault();
        });
      })();
    </script>
  </body>
</html>
