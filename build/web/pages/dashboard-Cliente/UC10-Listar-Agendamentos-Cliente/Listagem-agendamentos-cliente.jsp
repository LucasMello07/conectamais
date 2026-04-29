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
        <title>Conecta+: Minha Agenda</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="m-0 font-sans antialiased text-base leading-default bg-gray-50 text-slate-600" style="font-family: 'Poppins', sans-serif;">

        <aside class="fixed inset-y-0 my-4 ml-4 block w-60 rounded-2xl bg-white p-4 text-slate-700 shadow-lg">
            <div class="h-20 flex items-center justify-center">
                <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
            </div>
            <ul class="flex flex-col mt-6 space-y-2">
                <li>
                    <a href="${pageContext.request.contextPath}/agendamentos?acao=listarCliente"
                       class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
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
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Minha Agenda</li>
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

            <c:if test="${param.denuncia_ok == '1'}">
                <div class="mb-4 p-3 rounded-lg bg-green-50 text-green-700 border border-green-200">
                    Denúncia enviada com sucesso.
                </div>
            </c:if>
            <c:if test="${not empty param.denuncia_err}">
                <div class="mb-4 p-3 rounded-lg bg-red-50 text-red-700 border border-red-200">
                    <c:out value="${param.denuncia_err}"/>
                </div>
            </c:if>

            <section class="w-full mb-6">
                <div class="flex flex-wrap gap-6">
                    <div class="flex-1 min-w-[250px] bg-white shadow-md rounded-2xl p-4">
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="text-sm font-semibold">Agendamentos Pendentes</p>
                                <h5 class="text-xl font-bold"><c:out value="${qtdPendentes}" default="0"/></h5>
                            </div>
                            <div class="w-12 h-12 flex items-center justify-center rounded-lg bg-gradient-to-tl from-blue-600 to-green-400">
                                <i class="bi bi-calendar-event-fill text-white text-xl"></i>
                            </div>
                        </div>
                    </div>

                    <div class="flex-1 min-w-[250px] bg-white shadow-md rounded-2xl p-4">
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="text-sm font-semibold">Agendamentos Concluídos</p>
                                <h5 class="text-xl font-bold"><c:out value="${qtdConcluidos}" default="0"/></h5>
                            </div>
                            <div class="w-12 h-12 flex items-center justify-center rounded-lg bg-gradient-to-tl from-blue-600 to-green-400">
                                <i class="bi bi-calendar-check-fill text-white text-xl"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="w-full">
                <div class="bg-white shadow-md rounded-2xl overflow-hidden">
                    <div class="p-4 border-b">
                        <h6 class="font-bold align-middle text-slate-700">Histórico de Agendamentos</h6>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="p-3 text-center">Status</th>
                                    <th class="p-3 text-center">Cod.</th>
                                    <th class="p-3 text-center">Nome do Profissional</th>
                                    <th class="p-3 text-center">Data</th>
                                    <th class="p-3 text-center">Horário</th>
                                    <th class="p-3 text-center">Ações</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:choose>
                                    <c:when test="${empty agendamentos}">
                                        <tr>
                                            <td colspan="6" class="p-6 text-center text-slate-500">Nenhum agendamento encontrado.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="ag" items="${agendamentos}">
                                            <tr class="border-t hover:bg-gray-50" id="ag-${ag.idAgendamento}">
                                                <td class="p-3 text-center">
                                                    <div class="flex justify-center items-center">
                                                        <c:set var="cor"
                                                               value="${ag.statusAgendamento eq 'Concluído' ? 'bg-green-500' :
                                                                        (ag.statusAgendamento eq 'Pendente' ? 'bg-yellow-500' :
                                                                        (ag.statusAgendamento eq 'Cancelado' ? 'bg-red-500' : 'bg-slate-400'))}" />
                                                        <div class="w-3 h-3 rounded-full ${cor}"
                                                             title="${ag.statusAgendamento}"
                                                             aria-label="${ag.statusAgendamento}"></div>
                                                    </div>
                                                </td>

                                                <td class="p-3 text-center">#<c:out value="${ag.idAgendamento}"/></td>

                                                <td class="p-3 text-center">
                                                    <c:out value="${ag.profissional.usuario.nomeCompleto}" default="Profissional"/>
                                                </td>

                                                <td class="p-3 text-center">
                                                    <fmt:formatDate value="${ag.dataAgendamento}" pattern="dd/MM/yyyy"/>
                                                </td>

                                                <td class="p-3 text-center">
                                                    <c:out value="${ag.horarioAgendamento}" />
                                                </td>

                                                <td class="p-3 text-center">
                                                    <div class="flex gap-3 justify-center">
                                                        <a class="p-2 text-slate-600 hover:text-slate-900"
                                                           title="Visitar Perfil"
                                                           href="${pageContext.request.contextPath}/profissionais?acao=perfil&id=${ag.profissional.idProfissional}&hideAgendar=1">
                                                            <i class="bi bi-person-badge"></i>
                                                        </a>

                                                        <c:if test="${ag.statusAgendamento eq 'Concluído'}">
                                                            <c:choose>
                                                                <c:when test="${not ag.jaAvaliado}">
                                                                    <a class="p-2 text-red-600 hover:text-red-800"
                                                                       title="Fazer Avaliação"
                                                                       href="${pageContext.request.contextPath}/avaliacoes?acao=novo&id_agendamento=${ag.idAgendamento}&id_profissional=${ag.profissional.idProfissional}">
                                                                        <i class="bi bi-chat-left-quote"></i>
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a class="p-2 text-green-600 hover:text-green-800"
                                                                       title="Ver avaliação"
                                                                       href="${pageContext.request.contextPath}/avaliacoes?acao=listarCliente&highlight_ag=${ag.idAgendamento}">
                                                                        <i class="bi bi-chat-left-quote"></i>
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>

                                                        <c:if test="${ag.statusAgendamento eq 'Pendente'}">
                                                            <a class="p-2 text-red-600 hover:text-red-800 js-action"
                                                               title="Cancelar"
                                                               data-href="${pageContext.request.contextPath}/agendamentos?acao=cancelar&id=${ag.idAgendamento}&origem=cliente"
                                                               data-msg="Cancelar este agendamento?"
                                                               data-style="red">
                                                                <i class="bi bi-x-circle"></i>
                                                            </a>
                                                        </c:if>

                                                        <c:if test="${ag.statusAgendamento ne 'Cancelado'}">
                                                            <c:choose>
                                                                <c:when test="${ag.jaDenunciado}">
                                                                    <span class="inline-flex items-center justify-center text-green-600 text-lg" title="Denúncia registrada">
                                                                        <i class="bi bi-check-circle-fill"></i>
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a class="inline-flex items-center justify-center text-red-600 hover:text-red-800 text-lg"
                                                                       title="Denunciar"
                                                                       href="${pageContext.request.contextPath}/pages/dashboard-Cliente/UC10-Listar-Agendamentos-Cliente/form-denunciar.jsp?id_agendamento=${ag.idAgendamento}&id_profissional=${ag.profissional.idProfissional}">
                                                                        <i class="bi bi-shield-exclamation"></i>
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>

        <div id="confirmModal" class="fixed inset-0 z-50 hidden">
            <div class="absolute inset-0 bg-black/40 backdrop-blur-sm"></div>
            <div class="relative z-10 max-w-md mx-auto mt-32">
                <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
                    <div class="p-4 bg-gradient-to-r from-blue-600 to-green-400 text-white flex items-center gap-2">
                        <i class="bi bi-question-circle-fill text-lg"></i>
                        <span class="font-semibold">Confirmação</span>
                    </div>
                    <div class="p-5">
                        <p id="modalMsg" class="text-slate-700"></p>
                    </div>
                    <div class="p-4 flex justify-end gap-2 border-t">
                        <button id="mCancel" class="px-4 py-2 rounded-lg border border-slate-300 text-slate-700 hover:bg-gray-100">Voltar</button>
                        <button id="mConfirm" class="px-4 py-2 rounded-lg text-white">Confirmar</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            (function () {
                const modal = document.getElementById('confirmModal');
                const msgEl = document.getElementById('modalMsg');
                const bCancel = document.getElementById('mCancel');
                const bConfirm = document.getElementById('mConfirm');
                let href = null;

                function openModal(message, style, link) {
                    href = link;
                    msgEl.textContent = message || 'Confirmar ação?';
                    bConfirm.textContent = (style === 'red') ? 'Cancelar' : 'Confirmar';
                    bConfirm.className = 'px-4 py-2 rounded-lg text-white ' + ((style === 'red') ? 'bg-gradient-to-r from-red-600 to-red-400 hover:opacity-90' : 'bg-gradient-to-r from-green-600 to-green-400 hover:opacity-90');
                    modal.classList.remove('hidden');
                    document.body.classList.add('overflow-hidden');
                }
                function closeModal() {
                    modal.classList.add('hidden');
                    document.body.classList.remove('overflow-hidden');
                    href = null;
                }

                document.querySelectorAll('.js-action').forEach(el => {
                    el.addEventListener('click', (e) => {
                        e.preventDefault();
                        openModal(el.dataset.msg, el.dataset.style, el.dataset.href);
                    });
                });

                bCancel.addEventListener('click', closeModal);
                modal.addEventListener('click', (e) => {
                    if (e.target === modal)
                        closeModal();
                });
                document.addEventListener('keydown', (e) => {
                    if (e.key === 'Escape')
                        closeModal();
                });
                bConfirm.addEventListener('click', () => {
                    if (href)
                        window.location.href = href;
                });
            })();
        </script>
    </body>
</html>
