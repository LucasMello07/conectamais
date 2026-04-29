<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <title>Conecta+: Resultados da Busca</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="m-0 font-sans antialiased text-base leading-default bg-gray-50 text-slate-600" style="font-family: 'Poppins', sans-serif;">

        <!-- Sidebar -->
        <aside class="fixed inset-y-0 my-4 ml-4 block w-60 rounded-2xl bg-white p-4 text-slate-700 shadow-lg">
            <div class="h-20 flex items-center justify-center">
                <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
            </div>
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
                        <span>Minhas Avaliações</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ranking?acao=listarTop" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-trophy-fill"></i>
                        </div>
                        <span>Top Profissionais</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-3 p-2 rounded-lg hover:bg-red-100 text-red-600 font-semibold transition">
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
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Busca</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Bem-vindo, <c:out value="${usuarioLogado.nomeCompleto}"/></h6>
                </div>
                <form action="${pageContext.request.contextPath}/buscar-profissionais" method="get" class="flex items-center gap-2 bg-white/20 rounded-lg p-1">
                    <input type="text" name="termo" value="${param.termo}" placeholder="Buscar por nome, cidade, estado ou habilidade..." class="px-3 py-1 w-96 rounded-lg text-black focus:outline-none" autocomplete="off">
                    <button type="submit" class="px-3 py-1 rounded-lg bg-white/20 hover:bg-white/30 text-white font-semibold flex items-center gap-2">
                        <i class="bi bi-search"></i> Buscar
                    </button>
                </form>
                <a href="${pageContext.request.contextPath}/perfil?acao=ver" class="flex items-center gap-2 px-3 py-1 text-white font-semibold rounded-lg hover:bg-white/50 transition">
                    <i class="bi bi-person-circle"></i>
                    <span>Meu Perfil</span>
                </a>
            </nav>

            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold">
                    Resultados da Busca
                    <c:if test="${not empty termo}">
                        <span class="text-slate-400 text-base font-normal">para "<c:out value='${termo}'/>"</span>
                    </c:if>
                </h2>
            </div>

            <!-- Lista de Resultados -->
            <c:if test="${not empty resultados}">
                <div class="grid md:grid-cols-2 gap-6">
                    <c:forEach var="p" items="${resultados}">
                        <div class="bg-white rounded-2xl shadow-md p-6 flex gap-4">
                            <div class="w-16 h-16 flex-shrink-0 rounded-full bg-gradient-to-tl from-blue-600 to-green-400 flex items-center justify-center text-white text-xl font-bold">
                                <i class="bi bi-person-fill"></i>
                            </div>
                            <div class="flex-1">
                                <h3 class="font-bold text-lg"><c:out value="${p.nomeCompleto}"/></h3>
                                <p class="text-sm text-gray-600">
                                    <c:out value="${p.cidade}"/><c:if test="${not empty p.estado}">/<c:out value="${p.estado}"/></c:if>
                                    </p>
                                    <p class="text-sm text-gray-600">Tel: <c:out value="${p.telefoneComercial}" default="—"/></p>

                                <c:if test="${not empty p.habilidadesCsv}">
                                    <div class="mt-2 flex flex-wrap gap-2">
                                        <c:forEach var="hb" items="${fn:split(p.habilidadesCsv,'||')}">
                                            <span class="px-2 py-0.5 text-xs rounded bg-blue-50 text-blue-700 border border-blue-100"><c:out value="${hb}"/></span>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <div class="mt-4 flex gap-3">
                                    <a href="${pageContext.request.contextPath}/profissionais?acao=perfil&id=${p.idProfissional}"
                                       class="px-3 py-1 text-sm bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition flex items-center gap-1">
                                        <i class="bi bi-person-badge"></i> Perfil
                                    </a>

                                    <a href="${pageContext.request.contextPath}/agendamentos?acao=novo&id_profissional=${p.idProfissional}"
                                       class="px-3 py-1 text-sm bg-green-100 text-green-700 rounded-lg hover:bg-green-200 transition flex items-center gap-1">
                                        <i class="bi bi-calendar-plus"></i> Agendar
                                    </a>

                                    <c:set var="isFav" value="${favMap[p.idProfissional] == true}"/>

                                    <c:choose>
                                        <c:when test="${isFav}">
                                            <a href="${pageContext.request.contextPath}/favoritos?acao=remover&id_profissional=${p.idProfissional}"
                                               class="px-3 py-1 text-sm border text-red-600 rounded-lg hover:bg-red-50 transition flex items-center gap-1"
                                               onclick="return confirm('Remover este profissional dos seus favoritos?');">
                                                <i class="bi bi-heartbreak"></i> Remover
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/favoritos" method="post" class="inline">
                                                <input type="hidden" name="acao" value="adicionar"/>
                                                <input type="hidden" name="id_profissional" value="${p.idProfissional}"/>
                                                <button class="px-3 py-1 text-sm border hover:bg-pink-50 text-pink-700 rounded-lg transition flex items-center gap-1" title="Adicionar aos favoritos">
                                                    <i class="bi bi-heart"></i> Favoritar
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="flex justify-end mt-6 pr-6">
                    <a href="${pageContext.request.contextPath}/agendamentos?acao=listarCliente" class="px-6 py-3 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg hover:opacity-90 transition shadow-lg">
                        Voltar
                    </a>
                </div>

                <!-- Paginação -->
                <c:if test="${total > limit}">
                    <div class="flex items-center justify-center gap-2 mt-8">
                        <c:set var="hasPrev" value="${page > 1}"/>
                        <c:set var="hasNext" value="${page * limit < total}"/>
                        <a class="px-3 py-1 rounded border text-sm <c:if test='${!hasPrev}'>opacity-40 pointer-events-none</c:if>"
                           href="${pageContext.request.contextPath}/buscar-profissionais?termo=${fn:escapeXml(termo)}&page=${page-1}&limit=${limit}">
                            « Anterior
                        </a>
                        <span class="px-3 py-1 text-sm text-slate-500">Página ${page}</span>
                        <a class="px-3 py-1 rounded border text-sm <c:if test='${!hasNext}'>opacity-40 pointer-events-none</c:if>"
                           href="${pageContext.request.contextPath}/buscar-profissionais?termo=${fn:escapeXml(termo)}&page=${page+1}&limit=${limit}">
                            Próxima »
                        </a>
                    </div>
                </c:if>
            </c:if>

            <c:if test="${empty resultados}">
                <div class="text-center text-slate-500 bg-white shadow-md rounded-2xl p-8">
                    Nenhum profissional encontrado para o termo pesquisado.
                </div>
            </c:if>
        </main>
    </body>
</html>
