<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Conecta+: Top Profissionais</title>
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

                <!-- Ativo -->
                <li>
                    <a href="${pageContext.request.contextPath}/ranking?acao=listarTop"
                       class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
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

        <!-- Main Content -->
        <main class="ml-72 p-6">
            <!-- Navbar -->
            <nav class="w-full mb-6 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
                <div>
                    <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
                        <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Ranking</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Top Profissionais</h6>
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

                <div class="flex items-center gap-4">
                    <a href="${pageContext.request.contextPath}/pages/dashboard-Cliente/UC-22-Gerenciar-Perfil-Cliente/perfil-Cliente.jsp"
                       class="flex items-center gap-2 px-3 py-1 text-white font-semibold rounded-lg hover:bg-white/50 transition">
                        <i class="bi bi-person-circle"></i>
                        <span>Meu Perfil</span>
                    </a>
                </div>
            </nav>

            <section class="w-full mb-6">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

                    <div class="bg-white shadow-md rounded-2xl p-4">
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="text-sm font-semibold">Profissionais envolvidos</p>
                                <h5 class="text-xl font-bold">
                                    <c:out value="${fn:length(listaRanking)}" />
                                </h5>
                            </div>
                            <div class="w-12 h-12 flex items-center justify-center rounded-lg bg-gradient-to-tl from-blue-600 to-green-400">
                                <i class="bi bi-trophy-fill text-white text-xl"></i>
                            </div>
                        </div>
                    </div>

                </div>
            </section>

            <!-- Tabela -->
            <section class="w-full">
                <div class="bg-white shadow-md rounded-2xl overflow-hidden">
                    <div class="p-2 border-b">
                        <h6 class="font-bold align-middle text-slate-700">Profissionais Favoritados</h6>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="p-3 text-center">Posição</th>
                                    <th class="p-3">Nome do Profissional</th>
                                    <th class="p-3 text-center">Avaliação</th>
                                    <th class="p-3 text-center">Qtd. Avaliações</th>
                                    <th class="p-3 text-center">Favoritos</th>
                                    <th class="p-3 text-center">Ações</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="r" items="${listaRanking}">
                                    <tr class="border-t hover:bg-gray-50">
                                        <!-- Posição -->
                                        <td class="p-3 text-center">
                                            <c:out value="${r.posicao}"/>º
                                        </td>

                                        <!-- Nome -->
                                        <td class="p-3">
                                            <c:out value="${r.nomeCompleto}"/>
                                        </td>

                                        <td class="p-3 text-center">
                                            <c:set var="media" value="${r.mediaNota != null ? r.mediaNota : 0}" />
                                            <c:set var="full"  value="${media - (media % 1)}" />
                                            <c:set var="half"  value="${(media - full) >= 0.5}" />

                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= full}">
                                                        <i class="bi bi-star-fill text-yellow-500"></i>
                                                    </c:when>
                                                    <c:when test="${!(i <= full) && half}">
                                                        <i class="bi bi-star-half text-yellow-500"></i>
                                                        <c:set var="half" value="false"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-star text-yellow-500"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <span class="ml-1 text-sm text-slate-500">
                                                (<fmt:formatNumber value="${media}" minFractionDigits="1" maxFractionDigits="2"/>)
                                            </span>
                                        </td>

                                        <td class="p-3 text-center">
                                            <c:out value="${r.qtdAvaliacoes}"/>
                                        </td>

                                        <td class="p-3 text-center">
                                            <c:out value="${r.qtdFavoritos}"/>
                                        </td>

                                        <td class="p-3 text-center">
                                            <div class="flex gap-3 justify-center">
                                                <!-- Visitar perfil do profissional -->
                                                <a href="${pageContext.request.contextPath}/profissionais?acao=perfil&id=${r.idProfissional}"
                                                   class="p-2 text-slate-600 hover:text-slate-900"
                                                   title="Visitar perfil do profissional">
                                                    <i class="bi bi-person-badge"></i>
                                                </a>

                                                <a href="${pageContext.request.contextPath}/agendamentos?acao=novo&id_profissional=${r.idProfissional}"
                                                   class="p-2 text-blue-600 hover:text-blue-800"
                                                   title="Agendar atendimento">
                                                    <i class="bi bi-calendar-plus"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty listaRanking}">
                                    <tr>
                                        <td colspan="6" class="p-6 text-center text-slate-500">Nenhum profissional ranqueado.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>
    </body>
</html>
