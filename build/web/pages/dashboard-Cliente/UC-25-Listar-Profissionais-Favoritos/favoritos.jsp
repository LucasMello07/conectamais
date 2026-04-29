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
        <title>Conecta+: Meus Profissionais Favoritos</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
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
                    <a href="${pageContext.request.contextPath}/agendamentos?acao=listarCliente" class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-calendar-event-fill"></i>
                        </div>
                        <span>Meus Agendamentos</span>
                    </a>
                </li>
                <!-- Item ativo -->
                <li>
                    <a href="${pageContext.request.contextPath}/favoritos?acao=listar" class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
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
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Favoritos</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Profissionais Favoritos</h6>
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
                    <a href="${pageContext.request.contextPath}/perfil?acao=ver"
                       class="flex items-center gap-2 px-3 py-1 text-white font-semibold rounded-lg hover:bg-white/50 transition">
                        <i class="bi bi-person-circle"></i>
                        <span>Meu Perfil</span>
                    </a>
                </div>
            </nav>

            <c:if test="${not empty msg}">
                <div class="mb-4 p-3 rounded-lg bg-green-100 text-green-800">${msg}</div>
            </c:if>
            <c:if test="${not empty erro}">
                <div class="mb-4 p-3 rounded-lg bg-red-100 text-red-800">${erro}</div>
            </c:if>

            <!-- Tabela -->
            <section class="w-full">
                <div class="bg-white shadow-md rounded-2xl overflow-hidden">
                    <div class="p-4 border-b">
                        <h6 class="font-bold align-middle text-slate-700">Profissionais Favoritos</h6>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="p-3">Profissional</th>
                                    <th class="p-3">Cidade/UF</th>
                                    <th class="p-3 text-center">Telefone</th>
                                    <th class="p-3 text-center">Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="f" items="${favoritos}">
                                    <tr class="border-b hover:bg-gray-50 transition">
                                        <td class="p-3">
                                            <div class="flex items-center gap-3">
                                                <div class="w-9 h-9 rounded-full bg-gradient-to-tl from-blue-600 to-green-400"></div>
                                                <div class="flex flex-col">
                                                    <span class="font-semibold">
                                                        <c:out value="${f.profissional.usuario.nomeCompleto}" default="Profissional"/>
                                                    </span>
                                                    <small class="text-slate-500">#<c:out value="${f.profissional.idProfissional}"/></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="p-3">
                                            <c:out value="${f.profissional.usuario.cidade}" default=""/> /
                                            <c:out value="${f.profissional.usuario.estado}" default=""/>
                                        </td>
                                        <td class="p-3 text-center">
                                            <c:out value="${f.profissional.telefoneComercial}" default=""/>
                                        </td>
                                        <td class="p-3 text-center">
                                            <div class="flex gap-3 justify-center">
                                                <a class="p-2 text-slate-600 hover:text-slate-900"
                                                   title="Visitar Perfil"
                                                   <a href="${pageContext.request.contextPath}/profissionais?acao=perfil&id=${ag.profissional.idProfissional}&hideAgendar=1">
                                                        <i class="bi bi-person-badge"></i>
                                                    </a>
                                                    <!-- Remover favorito -->
                                                    <a href="${pageContext.request.contextPath}/favoritos?acao=remover&id_profissional=${f.profissional.idProfissional}"
                                                       class="p-2 text-red-600 hover:text-red-800 transition" title="Remover dos favoritos"
                                                       onclick="return confirm('Remover este profissional dos seus favoritos?');">
                                                        <i class="bi bi-heartbreak-fill"></i>
                                                    </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty favoritos}">
                                    <tr>
                                        <td colspan="4" class="p-6 text-center text-slate-500">Você ainda não favoritou nenhum profissional.</td>
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
