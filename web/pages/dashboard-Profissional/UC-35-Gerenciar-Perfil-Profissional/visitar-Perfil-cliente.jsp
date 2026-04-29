<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Conecta+: Perfil do Cliente</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="m-0 font-sans antialiased text-base leading-default bg-gray-50 text-slate-600" style="font-family:'Poppins',sans-serif;">

        <!-- Sidebar -->
        <aside class="fixed inset-y-0 my-4 ml-4 block w-60 rounded-2xl bg-white p-4 text-slate-700 shadow-lg">
            <div class="h-20 flex items-center justify-center">
                <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
            </div>
            <ul class="flex flex-col mt-6 space-y-2">
                <li>
                    <a href="${pageContext.request.contextPath}/agendamentos?acao=listarProfissional"
                       class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-calendar-event-fill"></i>
                        </div>
                        <span>Meus Agendamentos</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/habilidades?acao=listar"
                       class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-star-fill"></i>
                        </div>
                        <span>Minhas Habilidades</span>
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
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Visitar Perfil</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Perfil do Cliente</h6>
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
                <div class="bg-white shadow-md rounded-2xl p-6 flex flex-col md:flex-row gap-6">
                    <div class="w-32 h-32 rounded-full bg-gradient-to-tl from-blue-600 to-green-400"></div>
                    <div class="flex-1">
                        <h2 class="text-2xl font-bold">
                            <c:out value="${cliente.nomeCompleto}" default="Cliente"/>
                            <c:if test="${not empty cliente.idUsuario}">
                                <small class="text-slate-400">#<c:out value="${cliente.idUsuario}"/></small>
                            </c:if>
                        </h2>
                        <p class="text-gray-600">
                            <c:out value="${cliente.cidade}" default=""/> /
                            <c:out value="${cliente.estado}" default=""/>
                        </p>
                        <div class="text-gray-600">
                            <c:if test="${not empty cliente.email}">
                                <p>E-mail: <c:out value="${cliente.email}"/></p>
                            </c:if>
                            <c:if test="${not empty cliente.celular}">
                                <p>Celular: <c:out value="${cliente.celular}"/></p>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="bg-white shadow-md rounded-2xl p-6">
                    <h3 class="text-lg font-bold mb-2">Avaliações realizadas</h3>

                    <c:if test="${not empty avaliacoesDoCliente}">
                        <div class="space-y-2">
                            <c:forEach var="a" items="${avaliacoesDoCliente}">
                                <div class="p-3 border rounded-lg">
                                    <p class="font-semibold">
                                        Para: <c:out value="${a.profissionalNome}" default="Profissional"/>
                                        <span class="text-slate-400">— <c:out value="${a.dataAvaliacao}" default=""/></span>
                                    </p>
                                    <div class="text-yellow-500 mb-1">
                                        <c:forEach var="i" begin="1" end="5">
                                            <i class="bi ${i <= a.notaValor ? 'bi-star-fill' : 'bi-star'}"></i>
                                        </c:forEach>
                                    </div>
                                    <p class="text-sm text-gray-600"><c:out value="${a.comentario}" default="Sem comentário."/></p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${empty avaliacoesDoCliente}">
                        <div class="text-sm text-gray-600">Este cliente ainda não realizou avaliações.</div>
                    </c:if>
                </div>
            </section>
        </main>
    </body>
</html>
