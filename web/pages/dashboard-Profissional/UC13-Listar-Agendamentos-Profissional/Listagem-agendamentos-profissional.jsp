<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="conecta.entidades.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null || !"Profissional".equals(usuario.getTipoUsuario())) {
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

    <body class="m-0 font-sans antialiased font-normal text-base leading-default bg-gray-50 text-slate-600" style="font-family: 'Poppins', sans-serif;">

        <aside class="fixed inset-y-0 my-4 ml-4 block w-60 rounded-2xl bg-white p-4 text-slate-700 shadow-lg">
            <div class="h-20 flex items-center justify-center">
                <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
            </div>
            <ul class="flex flex-col mt-6 space-y-2">
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

        <main class="ml-72 p-6">
            <nav class="w-full mb-6 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
                <div>
                    <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
                        <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Minha Agenda</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Bem-vindo, <c:out value="${usuarioLogado.nomeCompleto}"/></h6>
                </div>
                <div class="flex items-center gap-4">
                    <a href="${pageContext.request.contextPath}/perfil?acao=ver"
                       class="flex items-center gap-2 px-3 py-1 text-white font-semibold rounded-lg hover:bg-white/50 transition">
                        <i class="bi bi-person-circle"></i>
                        <span>Meu Perfil</span>
                    </a>
                </div>
            </nav>

            <c:set var="alertSucesso" value="${not empty sucesso ? sucesso :
                                               (not empty param.sucesso ? param.sucesso :
                                               (param.conc_ok eq '1' ? 'Agendamento concluído com sucesso!' :
                                               (param.cancel_ok eq '1' ? 'Agendamento cancelado com sucesso!' : null)))}" />
            <c:set var="alertErro" value="${not empty erro ? erro :
                                            (not empty param.erro ? param.erro :
                                            (param.conc_err eq '1' ? 'Não foi possível concluir o agendamento.' :
                                            (param.cancel_err eq '1' ? 'Não foi possível cancelar o agendamento.' : null)))}" />
            <c:if test="${not empty alertErro}">
                <div class="mb-4 p-2 text-sm text-red-600 bg-red-100 border border-red-300 rounded-lg">
                    <i class="bi bi-exclamation-triangle-fill mr-1"></i> ${alertErro}
                </div>
            </c:if>
            <c:if test="${not empty alertSucesso}">
                <div class="mb-4 p-2 text-sm text-green-700 bg-green-100 border border-green-300 rounded-lg">
                    <i class="bi bi-check-circle-fill mr-1"></i> ${alertSucesso}
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
                                    <th class="p-3 text-center">Nome do Cliente</th>
                                    <th class="p-3 text-center">Data</th>
                                    <th class="p-3 text-center">Horário</th>
                                    <th class="p-3 text-center">Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ag" items="${agendamentos}">
                                    <tr class="border-t hover:bg-gray-50">
                                        <td class="p-3 text-center">
                                            <div class="flex justify-center items-center">
                                                <c:set var="cor"
                                                       value="${ag.statusAgendamento eq 'Concluído' ? 'bg-green-500' :
                                                                (ag.statusAgendamento eq 'Pendente' ? 'bg-yellow-500' :
                                                                (ag.statusAgendamento eq 'Cancelado' ? 'bg-red-500' : 'bg-slate-400'))}" />
                                                <div class="w-3 h-3 rounded-full ${cor}"></div>
                                            </div>
                                        </td>

                                        <td class="p-3 text-center">#<c:out value="${ag.idAgendamento}"/></td>

                                        <td class="p-3 text-center">
                                            <c:out value="${ag.cliente.usuario.nomeCompleto}" default="Cliente"/>
                                        </td>

                                        <td class="p-3 text-center">
                                            <fmt:formatDate value="${ag.dataAgendamento}" pattern="dd/MM/yyyy"/>
                                        </td>

                                        <td class="p-3 text-center">
                                            <c:out value="${ag.horarioAgendamento}" />
                                        </td>

                                        <td class="p-3 text-center">
                                            <div class="flex gap-3 justify-center">
                                                <a href="${pageContext.request.contextPath}/clientes?acao=perfil&id=${ag.cliente.idCliente}"
                                                   class="p-2 text-slate-600 hover:text-slate-900"
                                                   title="Visitar perfil do cliente">
                                                    <i class="bi bi-person-badge"></i>
                                                </a>

                                                <c:if test="${ag.statusAgendamento eq 'Pendente'}">
                                                    <a class="p-2 text-green-600 hover:text-green-800 js-action"
                                                       data-href="${pageContext.request.contextPath}/agendamentos?acao=concluir&id=${ag.idAgendamento}"
                                                       data-label="Concluir"
                                                       data-msg="Marcar como concluído?"
                                                       data-style="green"
                                                       title="Concluir">
                                                        <i class="bi bi-check2-circle"></i>
                                                    </a>
                                                </c:if>

                                                <c:if test="${ag.statusAgendamento eq 'Pendente'}">
                                                    <a class="p-2 text-red-600 hover:text-red-800 js-action"
                                                       data-href="${pageContext.request.contextPath}/agendamentos?acao=cancelar&id=${ag.idAgendamento}&origem=prof"
                                                       data-label="Cancelar"
                                                       data-msg="Cancelar este agendamento?"
                                                       data-style="red"
                                                       title="Cancelar">
                                                        <i class="bi bi-x-circle"></i>
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty agendamentos}">
                                    <tr>
                                        <td colspan="6" class="p-6 text-center text-slate-500">Nenhum agendamento encontrado.</td>
                                    </tr>
                                </c:if>
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

                function openModal(message, style, link, label) {
                    href = link;
                    msgEl.textContent = message || 'Confirmar ação?';
                    bConfirm.textContent = label || 'Confirmar';
                    bConfirm.className = 'px-4 py-2 rounded-lg text-white ' + (
                            style === 'red'
                            ? 'bg-gradient-to-r from-red-600 to-red-400 hover:opacity-90'
                            : 'bg-gradient-to-r from-green-600 to-green-400 hover:opacity-90'
                            );
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
                        openModal(el.dataset.msg, el.dataset.style, el.dataset.href, el.dataset.label);
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
