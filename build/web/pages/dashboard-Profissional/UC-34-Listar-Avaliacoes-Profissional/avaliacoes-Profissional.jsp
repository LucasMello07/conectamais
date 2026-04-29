<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="conecta.entidades.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null || !"Profissional".equalsIgnoreCase(usuario.getTipoUsuario())) {
        response.sendRedirect(request.getContextPath() + "/pages/landing-Page/index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Conecta+: Minhas Avaliações</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="m-0 font-sans antialiased text-base leading-default bg-gray-50 text-slate-700" style="font-family:'Poppins',sans-serif;">

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
                    <a href="${pageContext.request.contextPath}/avaliacoes?acao=listarProfissional"
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
                <a href="${pageContext.request.contextPath}/perfil?acao=ver"
                   class="flex items-center gap-2 px-3 py-1 text-white font-semibold rounded-lg hover:bg-white/50 transition">
                    <i class="bi bi-person-circle"></i>
                    <span>Meu Perfil</span>
                </a>
            </nav>

            <section class="max-w-5xl mx-auto">
                <h2 class="text-2xl font-bold mb-6">Avaliações Recebidas</h2>

                <c:if test="${empty avaliacoes}">
                    <div class="bg-white rounded-2xl shadow p-8 text-center text-slate-500">
                        Você ainda não recebeu avaliações.
                    </div>
                    <div class="flex justify-end mt-6 pr-6">
                        <a href="${pageContext.request.contextPath}/agendamentos?acao=listarProfissional"
                           class="px-6 py-3 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg hover:opacity-90 transition shadow-lg">
                            Voltar
                        </a>
                    </div>
                </c:if>

                <c:if test="${not empty avaliacoes}">
                    <section class="space-y-6">
                        <c:forEach var="a" items="${avaliacoes}">
                            <div class="bg-white shadow-md rounded-2xl p-6">
                                <div class="flex justify-between items-start">
                                    <div>
                                        <h4 class="font-semibold text-lg">
                                            <i class="bi bi-person-circle mr-1"></i>
                                            <c:out value="${a.cliente.usuario.nomeCompleto}" default="Cliente"/>
                                        </h4>
                                        <p class="text-sm text-gray-500">
                                            Atendimento:
                                            <c:out value="${a.dataAgendamentoFmt}" default="--/--/----"/>
                                            <c:if test="${not empty a.agendamento.horarioAgendamento}">
                                                às <c:out value="${a.agendamento.horarioAgendamento}"/>
                                            </c:if>
                                        </p>

                                        <div class="flex items-center mt-2">
                                            <div class="flex text-yellow-500 mr-2">
                                                <c:set var="nv" value="${a.notaValor}"/>
                                                <c:forEach var="i" begin="1" end="5">
                                                    <i class="bi ${i <= nv ? 'bi-star-fill' : 'bi-star'}"></i>
                                                </c:forEach>
                                            </div>
                                            <span class="text-sm font-semibold text-slate-700">
                                                <c:out value="${a.nota}" />
                                            </span>
                                        </div>

                                        <c:if test="${not empty a.comentarioAvaliacao}">
                                            <p class="mt-3 text-gray-700">
                                                <c:out value="${a.comentarioAvaliacao}" />
                                            </p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </section>
                </c:if>
            </section>
        </main>
    </body>
</html>
