<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Conecta+: Perfil do Cliente </title>
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
                <!-- Ativo -->
                <li>
                    <a href="${pageContext.request.contextPath}/agendamentos?acao=listarProfissional"
                       class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-calendar-event-fill"></i>
                        </div>
                        <span>Meus Agendamentos</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/habilidades?acao=listar&id_profissional=${idProfissional}"
                       class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-star-fill"></i>
                        </div>
                        <span>Minhas Habilidades</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/avaliacoes?acao=listarProfissional"
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
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Minha Agenda / Visitar Perfil</li>
                    </ol>
                    <c:choose>
                        <c:when test="${not empty cliente && not empty cleinte.usuario && not empty cliente.usuario.nomeCompleto}">
                            <h6 class="mb-0 font-bold capitalize">Perfil de <c:out value="${cliente.usuario.nomeCompleto}"/></h6>
                        </c:when>
                        <c:otherwise>
                            <h6 class="mb-0 font-bold capitalize">Perfil do Cliente</h6>
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

            <section class="mb-8">
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
                                            <c:out value="${cliente.nomeCompleto}" default="Cliente"/>
                                        </h2>
                                        <c:if test="${not empty cliente.idCliente}">
                                            <span class="px-2.5 py-1 text-xs rounded-full bg-slate-100 text-slate-700">
                                                ID #<c:out value="${cliente.idCliente}"/>
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="mt-2 flex flex-wrap items-center gap-2 text-sm">
                                        <c:if test="${not empty cliente.cidade or not empty cliente.estado}">
                                            <span class="inline-flex items-center gap-1 px-2 py-1 rounded-full bg-blue-50 text-blue-700 border border-blue-100">
                                                <i class="bi bi-geo-alt"></i>
                                                <c:out value="${cliente.cidade}"/>
                                                <c:if test="${not empty cliente.cidade and not empty cliente.estado}"> - </c:if>
                                                <c:out value="${cliente.estado}"/>
                                            </span>
                                        </c:if>

                                        <c:if test="${not empty cliente.celular}">
                                            <a href="tel:${cliente.celular}"
                                               class="inline-flex items-center gap-1 px-2 py-1 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-100">
                                                <i class="bi bi-telephone"></i> <c:out value="${cliente.celular}"/>
                                            </a>
                                        </c:if>

                                        <c:if test="${not empty cliente.email}">
                                            <a href="mailto:${cliente.email}"
                                               class="inline-flex items-center gap-1 px-2 py-1 rounded-full bg-violet-50 text-violet-700 border border-violet-100 truncate max-w-[260px]">
                                                <i class="bi bi-envelope"></i>
                                                <span class="truncate"><c:out value="${cliente.email}"/></span>
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Profissionais favoritos -->
            <section class="mb-10">
                <div class="flex items-center justify-between mb-3">
                    <h2 class="text-xl font-semibold text-slate-800">
                        <i class="bi bi-heart-fill text-pink-600"></i> Profissionais favoritos
                    </h2>
                    <span class="text-sm text-slate-500">
                        Total: <strong>${fn:length(favoritos)}</strong>
                    </span>
                </div>

                <c:choose>
                    <c:when test="${empty favoritos}">
                        <div class="bg-white rounded-2xl shadow p-6 text-slate-600">
                            Este cliente ainda não possui profissionais favoritos.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid md:grid-cols-2 gap-4">
                            <c:forEach var="fav" items="${favoritos}">
                                <div class="bg-white rounded-2xl shadow p-5 flex flex-col gap-2">
                                    <div class="flex items-start justify-between">
                                        <div>
                                            <h3 class="text-lg font-semibold text-slate-800">
                                                ${fav.nomeProfissional}
                                            </h3>
                                            <p class="text-sm text-slate-600">
                                                <i class="bi bi-briefcase"></i>
                                                <c:out value="${fav.areaAtuacao != null ? fav.areaAtuacao : 'Área não informada'}"/>
                                            </p>
                                            <p class="text-xs text-slate-500">
                                                Favoritado em: ${fav.dataFavorito}
                                            </p>
                                        </div>
                                        <a class="px-3 py-1 rounded-lg bg-purple-50 text-purple-700 hover:bg-purple-100 text-sm"
                                           href="${pageContext.request.contextPath}/profissionais?acao=perfil&id=${fav.idProfissional}">
                                            Ver profissional
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- Minhas avaliações (feitas pelo cliente) -->
            <section>
                <div class="flex items-center justify-between mb-3">
                    <h2 class="text-xl font-semibold text-slate-800">
                        <i class="bi bi-chat-left-quote-fill text-violet-600"></i> Minhas avaliações
                    </h2>
                    <span class="text-sm text-slate-500">
                        Total: <strong>${fn:length(avaliacoes)}</strong>
                    </span>
                </div>

                <c:choose>
                    <c:when test="${empty avaliacoes}">
                        <div class="bg-white rounded-2xl shadow p-6 text-slate-600">
                            Este cliente ainda não realizou avaliações.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-white rounded-2xl shadow divide-y">
                            <c:forEach var="av" items="${avaliacoes}">
                                <article class="p-5">
                                    <div class="flex items-center justify-between">
                                        <div>
                                            <h3 class="font-semibold text-slate-800">
                                                <c:out value="${empty av.tituloServico ? '—' : av.tituloServico}"/> ·
                                                <c:out value="${av.nomeProfissional}"/>
                                            </h3>
                                            <p class="text-sm text-slate-600">
                                                Nota: <strong>${av.nota}</strong>
                                                <span class="text-xs text-slate-400">· ${av.dataAvaliacao}</span>
                                            </p>
                                        </div>
                                    </div>
                                    <c:if test="${not empty av.comentario}">
                                        <p class="mt-3 text-slate-700 text-sm">${av.comentario}</p>
                                    </c:if>
                                </article>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>
    </body>
</html>
