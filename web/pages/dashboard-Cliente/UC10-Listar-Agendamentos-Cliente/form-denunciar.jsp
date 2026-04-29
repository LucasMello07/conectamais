<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        <title>Conecta+: Registrar Denúncia</title>
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

        <!-- Main -->
        <main class="ml-72 p-6">
            <!-- Navbar -->
            <nav class="w-full mb-6 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
                <div>
                    <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
                        <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Denúncia</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Bem-vindo, <c:out value="${usuarioLogado.nomeCompleto}"/></h6>
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

            <section class="max-w-3xl mx-auto mt-8">
                <div class="bg-white shadow-md rounded-2xl p-6">
                    <div class="flex items-center gap-2 mb-4">
                        <i class="bi bi-exclamation-triangle text-yellow-600 text-xl"></i>
                        <h2 class="text-xl font-bold text-slate-700">Registrar Denúncia</h2>
                    </div>

                    <c:if test="${not empty param.id_agendamento}">
                        <div class="mb-4 text-sm text-slate-600">
                            <span class="font-semibold">Agendamento:</span> #<c:out value="${param.id_agendamento}"/>
                            <c:if test="${not empty param.nome_prof}">
                                • <span class="font-semibold">Profissional:</span> <c:out value="${param.nome_prof}"/>
                            </c:if>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/denuncias">
                        <input type="hidden" name="acao" value="novo"/>
                        <input type="hidden" name="id_agendamento" value="${param.id_agendamento}"/>
                        <input type="hidden" name="id_profissional" value="${param.id_profissional}"/>

                        <div class="mb-4">
                            <label class="block font-medium mb-1">Motivo da denúncia</label>
                            <select name="motivo" class="w-full border rounded-lg p-2" required>
                                <option value="">Selecione...</option>
                                <option value="Abuso/Assédio">Abuso/Assédio</option>
                                <option value="Furto/Roubo">Furto/Roubo</option>
                                <option value="Agressão Física ou Verbal">Agressão Física ou Verbal</option>
                                <option value="Não comparecimento do Profissional">Não comparecimento do Profissional</option>
                                <option value="Cliente não encontrado">Cliente não encontrado</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="block font-medium mb-1">Descrição</label>
                            <textarea name="descricao" rows="6" maxlength="500"
                                      class="w-full border rounded-lg p-3"
                                      placeholder="Descreva o ocorrido com o máximo de detalhes..." required></textarea>
                        </div>

                        <div class="flex justify-end gap-3 mt-6">
                            <a href="${pageContext.request.contextPath}/agendamentos?acao=listarCliente"
                               class="px-4 py-2 rounded-lg bg-slate-200 text-slate-700 hover:bg-slate-300">
                                Cancelar
                            </a>
                            <button type="submit"
                                    class="px-4 py-2 rounded-lg bg-red-600 text-white hover:bg-red-700 flex items-center gap-2">
                                <i class="bi bi-send"></i> Enviar Denúncia
                            </button>
                        </div>
                    </form>
                </div>
            </section>
        </main>
    </body>
</html>
