<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="conecta.entidades.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null || !"Cliente".equalsIgnoreCase(usuario.getTipoUsuario())) {
        response.sendRedirect(request.getContextPath() + "/pages/landing-Page/index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Conecta+: Avaliar</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="m-0 font-sans bg-gray-50 text-slate-700 antialiased" style="font-family:'Poppins',sans-serif;">

        <aside class="fixed inset-y-0 my-4 ml-4 block w-60 rounded-2xl bg-white p-4 text-slate-700 shadow-lg">
            <div class="h-20 flex items-center justify-center">
                <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
            </div>
            <ul class="flex flex-col mt-6 space-y-2">
                <li>
                    <a href="${pageContext.request.contextPath}/agendamentos?acao=listarCliente"
                       class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-calendar-event-fill"></i>
                        </div>
                        <span>Meus Agendamentos</span>
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/favoritos?acao=listar"
                       class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-star-fill"></i>
                        </div>
                        <span>Favoritos</span>
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/avaliacoes?acao=listarCliente"
                       class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
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

        <main class="ml-72 p-6">
            <nav class="w-full mb-6 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
                <div>
                    <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
                        <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Avaliações</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Avaliar Profissional</h6>
                </div>

                <form action="${pageContext.request.contextPath}/buscar-profissionais" method="get"
                      class="flex items-center gap-2 bg-white/20 rounded-lg p-1">
                    <input type="text" name="termo" value="${param.termo}"
                           placeholder="Buscar por nome, cidade, estado ou habilidade..."
                           class="px-3 py-1 w-96 rounded-lg text-black focus:outline-none" autocomplete="off">
                    <button type="submit"
                            class="px-3 py-1 rounded-lg bg-white/20 hover:bg-white/30 text-white font-semibold flex items-center gap-2">
                        <i class="bi bi-search"></i> Buscar
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/perfil?acao=ver"
                   class="flex items-center gap-2 px-3 py-1 text-white font-semibold rounded-lg hover:bg-white/50 transition">
                    <i class="bi bi-person-circle"></i>
                    <span>Meu Perfil</span>
                </a>
            </nav>

            <section class="max-w-2xl mx-auto">
                <h2 class="text-2xl font-bold mb-4">
                    <c:choose>
                        <c:when test="${not empty avaliacao}">Editar Avaliação</c:when>
                        <c:otherwise>Avaliar Atendimento</c:otherwise>
                    </c:choose>
                </h2>

                <c:if test="${not empty erro}">
                    <div class="mb-4 p-3 rounded-lg bg-red-100 text-red-700">${erro}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/avaliacoes" method="post"
                      class="bg-white rounded-2xl shadow p-6 space-y-5">

                    <c:choose>
                        <c:when test="${not empty avaliacao}">
                            <input type="hidden" name="acao" value="salvarEdicao"/>
                            <input type="hidden" name="id" value="${avaliacao.idAvaliacao}"/>
                            <input type="hidden" name="id_agendamento" value="${empty id_agendamento ? param.id_agendamento : id_agendamento}"/>
                            <input type="hidden" name="id_profissional" value="${empty id_profissional ? param.id_profissional : id_profissional}"/>
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="acao" value="salvar"/>
                            <input type="hidden" name="id_agendamento" value="${empty id_agendamento ? param.id_agendamento : id_agendamento}"/>
                            <input type="hidden" name="id_profissional" value="${empty id_profissional ? param.id_profissional : id_profissional}"/>
                        </c:otherwise>
                    </c:choose>

                    <div>
                        <label class="block text-sm font-semibold mb-1">Profissional</label>
                        <div class="px-3 py-2 rounded-lg bg-gray-100">
                            <c:choose>
                                <c:when test="${not empty profissional and not empty profissional.usuario and not empty profissional.usuario.nomeCompleto}">
                                    <c:out value="${profissional.usuario.nomeCompleto}"/>
                                </c:when>
                                <c:when test="${not empty profissionalNome}">
                                    <c:out value="${profissionalNome}"/>
                                </c:when>
                                <c:when test="${not empty param.nome_prof}">
                                    <c:out value="${param.nome_prof}"/>
                                </c:when>
                                <c:otherwise>
                                    #<c:out value="${empty id_profissional ? param.id_profissional : id_profissional}"/>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold mb-2">Nota</label>
                        <c:set var="notaSel" value="${not empty avaliacao ? avaliacao.nota : ''}"/>
                        <c:set var="notaIdx" value="${notaSel=='Ruim' ? 1 : (notaSel=='Regular' ? 2 : (notaSel=='Bom' ? 3 : (notaSel=='Ótimo' ? 4 : (notaSel=='Excelente' ? 5 : 0))))}"/>
                        <div class="flex items-center gap-2 text-3xl cursor-pointer select-none" id="rating-stars">
                            <label class="leading-none">
                                <input type="radio" name="nota" value="Ruim" class="hidden" <c:if test="${notaSel=='Ruim'}">checked</c:if> required>
                                <i class="bi bi-star-fill star ${notaIdx>=1 ? 'text-yellow-400' : 'text-gray-300'}"></i>
                            </label>
                            <label class="leading-none">
                                <input type="radio" name="nota" value="Regular" class="hidden" <c:if test="${notaSel=='Regular'}">checked</c:if>>
                                <i class="bi bi-star-fill star ${notaIdx>=2 ? 'text-yellow-400' : 'text-gray-300'}"></i>
                            </label>
                            <label class="leading-none">
                                <input type="radio" name="nota" value="Bom" class="hidden" <c:if test="${notaSel=='Bom'}">checked</c:if>>
                                <i class="bi bi-star-fill star ${notaIdx>=3 ? 'text-yellow-400' : 'text-gray-300'}"></i>
                            </label>
                            <label class="leading-none">
                                <input type="radio" name="nota" value="Ótimo" class="hidden" <c:if test="${notaSel=='Ótimo'}">checked</c:if>>
                                <i class="bi bi-star-fill star ${notaIdx>=4 ? 'text-yellow-400' : 'text-gray-300'}"></i>
                            </label>
                            <label class="leading-none">
                                <input type="radio" name="nota" value="Excelente" class="hidden" <c:if test="${notaSel=='Excelente'}">checked</c:if>>
                                <i class="bi bi-star-fill star ${notaIdx>=5 ? 'text-yellow-400' : 'text-gray-300'}"></i>
                            </label>
                        </div>
                    </div>


                    <div>
                        <label for="comentario" class="block text-sm font-semibold mb-1">Comentário</label>
                        <textarea id="comentario" name="comentario" rows="4"
                                  class="w-full px-3 py-2 rounded-lg border border-slate-300 focus:outline-none"
                                  placeholder="Como foi o atendimento?"><c:out value="${not empty avaliacao ? avaliacao.comentarioAvaliacao : ''}"/></textarea>
                    </div>

                    <div class="pt-2">
                        <button type="submit"
                                class="px-4 py-2 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg hover:opacity-90 transition">
                            <c:choose>
                                <c:when test="${not empty avaliacao}">Salvar alterações</c:when>
                                <c:otherwise>Enviar avaliação</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>

                <div class="flex justify-end mt-6 pr-6">
                    <a href="${pageContext.request.contextPath}/agendamentos?acao=listarCliente"
                       class="px-6 py-3 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg hover:opacity-90 transition shadow-lg">
                        Voltar
                    </a>
                </div>
            </section>
        </main>
    </body>
</html>
