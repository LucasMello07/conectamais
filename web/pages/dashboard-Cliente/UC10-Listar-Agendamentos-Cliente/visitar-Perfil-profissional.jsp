<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Conecta+: Perfil do Profissional</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="m-0 font-sans antialiased text-base leading-default bg-gray-50 text-slate-600" style="font-family:'Poppins',sans-serif;">

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

        <main class="ml-72 p-6">
            <nav class="w-full mb-6 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
                <div>
                    <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
                        <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">
                            Realizar Busca / Visitar Perfil
                        </li>
                    </ol>

                    <c:choose>
                        <c:when test="${not empty profissional && not empty profissional.usuario && not empty profissional.usuario.nomeCompleto}">
                            <h6 class="mb-0 font-bold capitalize"><c:out value="${profissional.usuario.nomeCompleto}"/></h6>
                        </c:when>
                        <c:otherwise>
                            <h6 class="mb-0 font-bold capitalize">Perfil do Profissional</h6>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex items-center gap-4">
                    <a href="${pageContext.request.contextPath}/perfil?acao=ver"
                       class="flex items-center gap-2 px-3 py-1 text-white font-semibold rounded-lg hover:bg-white/50 transition">
                        <i class="bi bi-person-circle"></i>
                        <span>Meu Perfil</span>
                    </a>
                </div>
            </nav>

            <section class="space-y-6">
                <div class="relative overflow-hidden rounded-2xl bg-white shadow-md">
                    <div class="h-28 bg-gradient-to-r from-blue-600 to-green-400"></div>
                    <div class="-mt-12 px-6 pb-6">
                        <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-6">
                            <div class="flex items-start gap-5">
                                <div class="w-24 h-24 rounded-full ring-4 ring-white bg-gradient-to-tl from-blue-600 to-green-400 text-white flex items-center justify-center">
                                    <i class="bi bi-person text-4xl"></i>
                                </div>
                                <div>
                                    <div class="flex items-center gap-3 flex-wrap">
                                        <h2 class="text-2xl font-bold text-slate-800">
                                            <c:out value="${profissional.usuario.nomeCompleto}" default="Profissional"/>
                                        </h2>
                                        <span class="px-2.5 py-1 text-xs rounded-full bg-slate-100 text-slate-700">
                                            ID #<c:out value="${profissional.idProfissional}"/>
                                        </span>
                                    </div>

                                    <div class="mt-2 flex flex-wrap items-center gap-2 text-sm">
                                        <c:if test="${not empty profissional.usuario.cidade || not empty profissional.usuario.estado}">
                                            <span class="inline-flex items-center gap-1 px-2 py-1 rounded-full bg-blue-50 text-blue-700 border border-blue-100">
                                                <i class="bi bi-geo-alt"></i>
                                                <c:out value="${profissional.usuario.cidade}" default=""/> <c:if test="${not empty profissional.usuario.estado}">/<c:out value="${profissional.usuario.estado}"/></c:if>
                                                </span>
                                        </c:if>

                                        <c:if test="${not empty profissional.telefoneComercial}">
                                            <a href="tel:${profissional.telefoneComercial}"
                                               class="inline-flex items-center gap-1 px-2 py-1 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-100">
                                                <i class="bi bi-telephone"></i> <c:out value="${profissional.telefoneComercial}"/>
                                            </a>
                                        </c:if>

                                        <c:if test="${not empty profissional.enderecoComercial}">
                                            <span class="inline-flex items-center gap-1 px-2 py-1 rounded-full bg-slate-50 text-slate-700 border border-slate-200">
                                                <i class="bi bi-building"></i> <c:out value="${profissional.enderecoComercial}"/>
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="mt-4 flex flex-wrap gap-3">
                                        <c:if test="${param.hideAgendar ne '1'}">
                                            <a href="${pageContext.request.contextPath}/agendamentos?acao=novo&id_profissional=${profissional.idProfissional}"
                                               class="px-4 py-2 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg hover:opacity-90 transition shadow">
                                                Agendar Visita
                                            </a>
                                        </c:if>

                                        <c:choose>
                                            <c:when test="${favoritado}">
                                                <a href="${pageContext.request.contextPath}/favoritos?acao=remover&id_profissional=${profissional.idProfissional}"
                                                   class="px-4 py-2 rounded-lg border text-red-600 hover:bg-red-50 transition"
                                                   onclick="return confirm('Remover este profissional dos seus favoritos?');">
                                                    <i class="bi bi-heartbreak"></i> Remover Favorito
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/favoritos" method="post" class="inline">
                                                    <input type="hidden" name="acao" value="adicionar"/>
                                                    <input type="hidden" name="id_profissional" value="${profissional.idProfissional}"/>
                                                    <button class="px-4 py-2 rounded-lg border hover:bg-red-50 text-red-600 transition" title="Adicionar aos favoritos">
                                                        <i class="bi bi-heart"></i> Favoritar
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="grid grid-cols-2 sm:grid-cols-3 gap-3 md:text-right">
                                <div class="px-4 py-3 rounded-xl bg-slate-50 border border-slate-200">
                                    <div class="text-xs text-slate-500">Habilidades</div>
                                    <div class="text-lg font-semibold text-slate-800">
                                        <c:out value="${fn:length(habilidadesAtivas)}" default="0"/>
                                    </div>
                                </div>
                                <div class="px-4 py-3 rounded-xl bg-slate-50 border border-slate-200">
                                    <div class="text-xs text-slate-500">Avaliações</div>
                                    <div class="text-lg font-semibold text-slate-800">
                                        <c:out value="${fn:length(avaliacoes)}" default="0"/>
                                    </div>
                                </div>
                                <div class="px-4 py-3 rounded-xl bg-slate-50 border border-slate-200">
                                    <div class="text-xs text-slate-500">Status</div>
                                    <div class="text-lg font-semibold text-emerald-600">Ativo</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="bg-white shadow-md rounded-2xl p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-bold">Habilidades</h3>
                        <c:if test="${not empty habilidadesAtivas}">
                            <span class="text-xs px-2 py-1 rounded-full bg-slate-100 text-slate-600">
                                <c:out value="${fn:length(habilidadesAtivas)}"/> publicadas
                            </span>
                        </c:if>
                    </div>

                    <c:choose>
                        <c:when test="${not empty habilidadesAtivas}">
                            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
                                <c:forEach var="h" items="${habilidadesAtivas}">
                                    <article class="rounded-xl border border-slate-200 p-4 hover:shadow-md transition">
                                        <h4 class="font-semibold text-slate-800 flex items-center gap-2">
                                            <i class="bi bi-lightning-charge-fill text-blue-600"></i>
                                            <c:out value="${h.titulo}"/>
                                        </h4>
                                        <p class="mt-2 text-sm text-slate-600 leading-relaxed">
                                            <c:out value="${h.descricao}" default="Sem descrição informada."/>
                                        </p>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-sm text-gray-600">Nenhuma habilidade ativa publicada por este profissional.</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:choose>
                    <c:when test="${not empty avaliacoes}">
                        <section class="bg-white shadow-md rounded-2xl p-6">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-lg font-bold">Avaliações</h3>
                                <span class="text-xs px-2 py-1 rounded-full bg-slate-100 text-slate-600">
                                    <c:out value="${fn:length(avaliacoes)}"/> recebidas
                                </span>
                            </div>

                            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
                                <c:forEach var="a" items="${avaliacoes}">
                                    <article class="rounded-xl border border-slate-200 p-4 hover:shadow-md transition">
                                        <div class="flex items-start justify-between gap-3">
                                            <div class="min-w-0">
                                                <h4 class="font-semibold text-slate-800 truncate">
                                                    <i class="bi bi-person-circle mr-1"></i>
                                                    <c:out value="${a.cliente.usuario.nomeCompleto}" default="Cliente"/>
                                                </h4>
                                            </div>
                                            <div class="shrink-0 flex text-yellow-500" title="<c:out value='${a.nota}'/>">
                                                <c:set var="nv" value="${a.notaValor}"/>
                                                <c:forEach var="i" begin="1" end="5">
                                                    <i class="bi ${i <= nv ? 'bi-star-fill' : 'bi-star'} text-lg"></i>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <p class="mt-3 text-sm text-slate-700 leading-relaxed">
                                            <c:out value="${a.comentarioAvaliacao}" default="Sem comentário."/>
                                        </p>
                                    </article>
                                </c:forEach>
                            </div>
                        </section>
                    </c:when>
                    <c:otherwise>
                        <section class="bg-white shadow-md rounded-2xl p-6">
                            <h3 class="text-lg font-bold mb-2">Avaliações</h3>
                            <p class="text-sm text-slate-600">Este profissional ainda não recebeu avaliações.</p>
                        </section>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>
    </body>
</html>
