<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Conecta+: ${empty habilidade ? 'Nova' : 'Editar'} Habilidade</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
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
      <ul class="flex flex-col mt-6 space-y-2">
        <li>
          <a href="${pageContext.request.contextPath}/pages/dashboard-Profissional/UC13-Listar-Agendamentos-Profissional/Listagem-agendamentos-profissional.jsp"
             class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
            <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
              <i class="bi bi-calendar-event-fill"></i>
            </div>
            <span>Meus Agendamentos</span>
          </a>
        </li>

        <!-- Item ativo -->
        <li>
          <a href="${pageContext.request.contextPath}/habilidades?acao=listar&id_profissional=${param.id_profissional != null ? param.id_profissional : habilidade.idProfissional}"
             class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
            <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
              <i class="bi bi-star-fill"></i>
            </div>
            <span>Minhas Habilidades</span>
          </a>
        </li>

        <li>
          <a href="${pageContext.request.contextPath}/pages/dashboard-Profissional/UC-34-Listar-Avaliacoes-Profissional/avaliacoes-Profissional.jsp"
             class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
            <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
              <i class="bi bi-chat-left-quote-fill"></i>
            </div>
            <span>Minhas Avaliações</span>
          </a>
        </li>

        <li>
          <a href="${pageContext.request.contextPath}/ranking?acao=listarTop"
             class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
            <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
              <i class="bi bi-trophy-fill"></i>
            </div>
            <span>Top Profissionais</span>
          </a>
        </li>

        <li>
          <a href="${pageContext.request.contextPath}/logout"
             class="flex items-center gap-3 p-2 rounded-lg hover:bg-red-100 text-red-600 font-semibold transition">
            <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-red-600 to-red-400 text-white">
              <i class="bi bi-box-arrow-right"></i>
            </div>
            <span>Sair</span>
          </a>
        </li>
      </ul>
    </aside>

    <!-- Main -->
    <main class="ml-72 p-6">
      <!-- Navbar -->
      <nav class="w-full mb-6 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
        <div>
          <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
            <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
            <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">
              <a href="${pageContext.request.contextPath}/habilidades?acao=listar&id_profissional=${param.id_profissional != null ? param.id_profissional : habilidade.idProfissional}">
                Especialidades
              </a>
            </li>
            <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">${empty habilidade ? 'Cadastrar' : 'Editar'}</li>
          </ol>
          <h6 class="mb-0 font-bold capitalize">${empty habilidade ? 'Nova' : 'Editar'} Habilidade</h6>
        </div>
        <div class="flex items-center gap-4">
            <a href="${pageContext.request.contextPath}/perfil?acao=ver"
             class="flex items-center gap-2 px-3 py-1 text-white font-semibold rounded-lg hover:bg-white/50 transition">
            <i class="bi bi-person-circle"></i>
            <span>Meu Perfil</span>
          </a>
        </div>
      </nav>

      <!-- Card do Form -->
      <section class="max-w-3xl mx-auto">
        <div class="bg-white shadow-md rounded-2xl p-6">
          <form action="${pageContext.request.contextPath}/habilidades" method="post" class="space-y-5">
            <input type="hidden" name="acao" value="salvar"/>
            <input type="hidden" name="id" value="${habilidade.idHabilidade}"/>
            <input type="hidden" name="id_profissional"
                   value="${param.id_profissional != null ? param.id_profissional : habilidade.idProfissional}"/>

            <div>
              <label class="block text-sm font-semibold mb-1">Título</label>
              <input name="titulo" maxlength="255" required
                     value="${habilidade.titulo}"
                     class="w-full px-3 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"/>
            </div>

            <div>
              <label class="block text-sm font-semibold mb-1">Descrição</label>
              <textarea name="descricao" rows="4" maxlength="500"
                        class="w-full px-3 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 text-black">${habilidade.descricao}</textarea>
            </div>

            <div>
              <label class="block text-sm font-semibold mb-1">Status</label>
              <select name="status"
                      class="w-full px-3 py-2 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 text-black">
                <option value="Ativo" ${habilidade.status == 'Ativo' ? 'selected' : ''}>Ativo</option>
                <option value="Inativo" ${habilidade.status == 'Inativo' ? 'selected' : ''}>Inativo</option>
              </select>
            </div>

            <div class="flex gap-3 justify-end">
              <a href="${pageContext.request.contextPath}/habilidades?acao=listar&id_profissional=${param.id_profissional != null ? param.id_profissional : habilidade.idProfissional}"
                 class="px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-100">Voltar</a>
              <button type="submit"
                      class="px-4 py-2 bg-gradient-to-r from-blue-600 to-green-400 text-white font-semibold rounded-lg shadow-md hover:opacity-90 transition">
                Salvar
              </button>
            </div>
          </form>
        </div>
      </section>
    </main>
  </body>
</html>
