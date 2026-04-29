<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Conecta+: Minhas Habilidades</title>
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
                       class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-calendar-event-fill"></i>
                        </div>
                        <span>Meus Agendamentos</span>
                    </a>
                </li>

                <!-- Item ativo -->
                <li>
                    <a href="${pageContext.request.contextPath}/habilidades?acao=listar&id_profissional=${idProfissional}"
                       class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
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

        <!-- Main Content -->
        <main class="ml-72 p-6">
            <!-- Navbar -->
            <nav class="w-full mb-4 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
                <div>
                    <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
                        <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Especialidades</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Minhas Habilidades</h6>
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
                                               (param.del_ok eq '1' ? 'Habilidade excluída com sucesso!' :
                                               (param.new_ok eq '1' ? 'Habilidade cadastrada com sucesso!' :
                                               (param.upd_ok eq '1' ? 'Habilidade atualizada com sucesso!' : null))))}" />
            <c:set var="alertErro" value="${not empty erro ? erro :
                                            (not empty param.erro ? param.erro :
                                            (param.del_err eq '1' ? 'Não foi possível excluir a habilidade.' : null))}" />
            <c:set var="alertAviso" value="${not empty aviso ? aviso : (not empty param.aviso ? param.aviso : null)}" />
            <c:set var="alertInfo" value="${not empty info ? info : (not empty param.info ? param.info : null)}" />

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

            <c:if test="${not empty alertAviso}">
                <div class="mb-4 p-2 text-sm text-yellow-700 bg-yellow-100 border border-yellow-300 rounded-lg">
                    <i class="bi bi-exclamation-circle-fill mr-1"></i> ${alertAviso}
                </div>
            </c:if>

            <c:if test="${not empty alertInfo}">
                <div class="mb-4 p-2 text-sm text-slate-700 bg-slate-100 border border-slate-300 rounded-lg">
                    <i class="bi bi-info-circle-fill mr-1"></i> ${alertInfo}
                </div>
            </c:if>
            <!-- /ALERTAS -->

            <section class="w-full mb-6 flex justify-end">
                <a href="${pageContext.request.contextPath}/habilidades?acao=novo&id_profissional=${idProfissional}"
                   class="px-4 py-2 bg-gradient-to-r from-blue-600 to-green-400 text-white font-semibold rounded-lg shadow-md hover:opacity-90 transition flex items-center gap-2">
                    <i class="bi bi-plus-circle"></i> Nova Habilidade
                </a>
            </section>

            <!-- Tabela -->
            <section class="w-full">
                <div class="bg-white shadow-md rounded-2xl overflow-hidden">
                    <div class="p-4 border-b">
                        <h6 class="font-bold align-middle text-slate-700">Minhas Habilidades</h6>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="p-3 text-center">Status</th>
                                    <th class="p-3 text-center">Cod.</th>
                                    <th class="p-3 text-center">Título</th>
                                    <th class="p-3 text-center">Descrição</th>
                                    <th class="p-3 text-center">Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="h" items="${habilidades}">
                                    <tr class="border-b hover:bg-gray-50 transition">
                                        <td class="p-3 text-center">
                                            <c:choose>
                                                <c:when test="${h.status == 'Ativo'}">
                                                    <span class="inline-block w-3 h-3 rounded-full bg-green-500" title="Ativo"></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-block w-3 h-3 rounded-full bg-red-500" title="Inativo"></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="p-3 text-center">#${h.idHabilidade}</td>
                                        <td class="p-3 text-center">${h.titulo}</td>
                                        <td class="p-3 text-center">${h.descricao}</td>

                                        <!-- editar/excluir -->
                                        <td class="p-3">
                                            <div class="flex items-center justify-center gap-3">
                                                <a href="${pageContext.request.contextPath}/habilidades?acao=editar&id=${h.idHabilidade}"
                                                   class="p-2 text-blue-600 hover:text-blue-800 transition" title="Editar">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>

                                                <!-- Botão excluir com modal -->
                                                <a href="${pageContext.request.contextPath}/habilidades?acao=excluir&id=${h.idHabilidade}&id_profissional=${idProfissional}"
                                                   class="p-2 text-red-600 hover:text-red-800 transition js-del"
                                                   data-href="${pageContext.request.contextPath}/habilidades?acao=excluir&id=${h.idHabilidade}&id_profissional=${idProfissional}"
                                                   data-title="${fn:escapeXml(h.titulo)}"
                                                   title="Excluir">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty habilidades}">
                                    <tr>
                                        <td colspan="5" class="p-6 text-center text-slate-500">Nenhuma habilidade cadastrada.</td>
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
                        <i class="bi bi-trash-fill text-lg"></i>
                        <span class="font-semibold">Confirmar exclusão</span>
                    </div>
                    <div class="p-5">
                        <p class="text-slate-700 mb-2">Deseja excluir esta habilidade?</p>
                        <p class="text-slate-500 text-sm">Habilidade: <span id="modalSkill" class="font-semibold"></span></p>
                    </div>
                    <div class="p-4 flex justify-end gap-2 border-t">
                        <button id="btnCancel" class="px-4 py-2 rounded-lg border border-slate-300 text-slate-700 hover:bg-gray-100">Cancelar</button>
                        <button id="btnConfirm" class="px-4 py-2 rounded-lg text-white bg-gradient-to-r from-red-600 to-red-400 hover:opacity-90">Excluir</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
