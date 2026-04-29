<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="conecta.entidades.Usuario" %>
<% request.setAttribute("ocultarVerAvaliacao", true); %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null || !"Cliente".equals(usuario.getTipoUsuario())) {
        response.sendRedirect(request.getContextPath() + "/pages/landing-Page/index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Conecta+: Minhas Avaliações</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="m-0 font-sans antialiased font-normal text-base leading-default bg-gray-50 text-slate-600"
          style="font-family: 'Poppins', sans-serif;">

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
                            <i class="bi bi-heart-fill"></i>
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
                    <h6 class="mb-0 font-bold capitalize">Minhas Avaliações</h6>
                </div>

                <form action="${pageContext.request.contextPath}/buscar-profissionais" method="get"
                      class="flex items-center gap-2 bg-white/20 rounded-lg p-1">
                    <input type="text" name="termo" value="${param.termo}"
                           placeholder="Buscar por nome, cidade, estado ou habilidade..."
                           class="px-3 py-1 w-96 rounded-lg text-black focus:outline-none"
                           autocomplete="off">
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

            <c:if test="${not empty msg}">
                <div class="mb-4 p-2 text-sm text-green-700 bg-green-100 border border-green-300 rounded-lg">${msg}</div>
            </c:if>
            <c:if test="${not empty erro}">
                <div class="mb-4 p-2 text-sm text-red-600 bg-red-100 border border-red-300 rounded-lg">${erro}</div>
            </c:if>
            <c:if test="${param.av_del_ok == '1' || param.del_ok == '1'}">
                <div class="mb-4 p-2 text-sm text-green-700 bg-green-100 border border-green-300 rounded-lg">
                    Avaliação excluída com sucesso!
                </div>
            </c:if>
            <c:if test="${param.av_del_err == '1' || not empty param.del_err}">
                <div class="mb-4 p-2 text-sm text-red-600 bg-red-100 border border-red-300 rounded-lg">
                    Não foi possível excluir a avaliação.
                </div>
            </c:if>

            <c:if test="${not empty agendamentosConcluidosNaoAvaliados}">
                <div class="bg-white shadow-md rounded-2xl p-4 mb-6">
                    <h3 class="font-semibold mb-2">Agendamentos concluídos sem avaliação</h3>
                    <div class="flex flex-wrap gap-2">
                        <c:forEach var="ag" items="${agendamentosConcluidosNaoAvaliados}">
                            <a href="${pageContext.request.contextPath}/avaliacoes?acao=novo&id_agendamento=${ag.idAgendamento}&id_profissional=${ag.profissional.idProfissional}"
                               class="px-3 py-1 rounded-lg bg-pink-100 text-pink-700 hover:bg-pink-200 text-sm">
                                Avaliar #${ag.idAgendamento} — <c:out value="${ag.profissional.usuario.nomeCompleto}"/>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty requestScope.highlightId}">
                    <c:set var="highlightId" value="${requestScope.highlightId}" />
                </c:when>
                <c:otherwise>
                    <c:set var="highlightId" value="${param.highlight}" />
                </c:otherwise>
            </c:choose>

            <section class="space-y-6">
                <c:forEach var="a" items="${avaliacoes}">
                    <c:set var="isHighlight" value="${highlightId == a.idAvaliacao}" />
                    <div id="aval-${a.idAvaliacao}"
                         class="bg-white shadow-md rounded-2xl p-6 ${isHighlight ? 'ring-2 ring-purple-400' : ''}">
                        <div class="flex justify-between items-start">
                            <div>
                                <h4 class="font-semibold text-lg">
                                    <c:out value="${a.nomeProfissional}" default="Profissional"/>
                                </h4>
                                <p class="text-sm text-gray-500">
                                    Avaliado em:
                                    <c:out value="${a.dataAvaliacaoFmt}" default="--/--/----"/>
                                    <c:if test="${not empty a.dataAgendamentoFmt}">
                                        • Atendimento: <c:out value="${a.dataAgendamentoFmt}"/>
                                    </c:if>
                                </p>

                                <div class="flex items-center mt-2">
                                    <div class="flex text-yellow-500 mr-2">
                                        <c:forEach var="i" begin="1" end="5">
                                            <i class="bi ${i <= a.notaValor ? 'bi-star-fill' : 'bi-star'}"></i>
                                        </c:forEach>
                                    </div>
                                    <span class="text-sm font-semibold text-slate-700">
                                        <c:out value="${a.nota}" default="Sem nota"/>
                                    </span>
                                </div>

                                <p class="mt-3 text-gray-700">
                                    <c:out value="${a.comentarioAvaliacao}" default="Sem comentário."/>
                                </p>

                                <c:if test="${empty requestScope.ocultarVerAvaliacao}">
                                    <div class="mt-3">
                                        <a href="${pageContext.request.contextPath}/avaliacoes?acao=listarCliente&highlight=${a.idAvaliacao}#aval-${a.idAvaliacao}"
                                           class="text-purple-700 hover:text-purple-900 text-sm">
                                            <i class="bi bi-chat-left-quote"></i> Ver avaliação
                                        </a>
                                    </div>
                                </c:if>
                            </div>

                            <div class="flex gap-2 shrink-0 self-start">
                                <a href="${pageContext.request.contextPath}/avaliacoes?acao=editar&id=${a.idAvaliacao}"
                                   class="px-3 py-2 rounded-lg bg-yellow-100 text-yellow-700 hover:bg-yellow-200 transition flex items-center gap-1"
                                   title="Alterar Avaliação">
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/avaliacoes?acao=excluir&id=${a.idAvaliacao}"
                                   class="px-3 py-2 rounded-lg bg-red-100 text-red-700 hover:bg-red-200 transition flex items-center gap-1 js-del"
                                   data-href="${pageContext.request.contextPath}/avaliacoes?acao=excluir&id=${a.idAvaliacao}"
                                   data-msg="Deseja excluir esta avaliação?"
                                   title="Excluir Avaliação">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty avaliacoes}">
                    <div class="bg-white shadow-md rounded-2xl p-6 text-center text-slate-500">
                        Você ainda não realizou avaliações.
                    </div>
                </c:if>
            </section>

            <div id="avalDelModal" class="fixed inset-0 z-50 hidden">
                <div class="absolute inset-0 bg-black/40 backdrop-blur-sm"></div>
                <div class="relative z-10 max-w-md mx-auto mt-32">
                    <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
                        <div class="p-4 bg-gradient-to-r from-blue-600 to-green-400 text-white flex items-center gap-2">
                            <i class="bi bi-trash-fill text-lg"></i>
                            <span class="font-semibold">Confirmar exclusão</span>
                        </div>
                        <div class="p-5">
                            <p id="avalDelMsg" class="text-slate-700"></p>
                        </div>
                        <div class="p-4 flex justify-end gap-2 border-t">
                            <button id="avalDelCancel" class="px-4 py-2 rounded-lg border border-slate-300 text-slate-700 hover:bg-gray-100">Voltar</button>
                            <button id="avalDelConfirm" class="px-4 py-2 rounded-lg text-white bg-gradient-to-r from-red-600 to-red-400 hover:opacity-90">Excluir</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>
