<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<%
  conecta.entidades.Usuario usuarioLogado =
      (conecta.entidades.Usuario) session.getAttribute("usuarioLogado");
  if (usuarioLogado == null || !"Administrador".equalsIgnoreCase(usuarioLogado.getTipoUsuario())) {
      response.sendRedirect(request.getContextPath() + "/pages/landing-Page/index.jsp");
      return;
  }
%>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Conecta+: Denúncia • Detalhe</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="m-0 font-sans antialiased bg-gray-50 text-slate-600" style="font-family:'Poppins',sans-serif;">

        <!-- Sidebar -->
        <aside class="fixed inset-y-0 my-4 ml-4 block w-60 rounded-2xl bg-white p-4 text-slate-700 shadow-lg">
            <div class="h-20 flex items-center justify-center">
                <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
            </div>
            <ul class="flex flex-col mt-6 space-y-2">

                <li>
                    <a href="${pageContext.request.contextPath}/denuncias?acao=listar"
                       class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-flag-fill"></i>
                        </div>
                        <span>Painel de Denúncias</span>
                    </a>
                </li>

                <li>
                    <!-- aponta para o servlet de usuários moderados -->
                    <a href="${pageContext.request.contextPath}/usuarios"
                       class="flex items-center gap-3 p-2 rounded-lg hover:bg-gray-100 transition">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <span>Usuários Moderados</span>
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
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Denúncias</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Detalhe da Denúncia #<c:out value="${denuncia.idDenuncia}"/></h6>
                </div>
                <a href="${pageContext.request.contextPath}/denuncias?acao=listar"
                   class="px-3 py-1 rounded-lg bg-white/20 hover:bg-white/30 text-white font-semibold inline-flex items-center gap-2">
                    <i class="bi bi-arrow-left"></i> Voltar
                </a>
            </nav>

            <c:if test="${not empty param.ok}">
                <div class="mb-4 p-3 rounded-lg bg-green-100 text-green-800 border border-green-200">Ação registrada com sucesso.</div>
            </c:if>
            <c:if test="${not empty param.err}">
                <div class="mb-4 p-3 rounded-lg bg-red-100 text-red-800 border border-red-200"><c:out value="${param.err}"/></div>
            </c:if>

            <section class="w-full">
                <div class="bg-white shadow-md rounded-2xl p-6">

                    <c:choose>
                        <c:when test="${denuncia.status eq 'Pendente'}">
                            <c:set var="badge" value="bg-yellow-100 text-yellow-700"/>
                        </c:when>
                        <c:when test="${denuncia.status eq 'Banimento'}">
                            <c:set var="badge" value="bg-red-100 text-red-700"/>
                        </c:when>
                        <c:when test="${denuncia.status eq 'Suspensao'}">
                            <c:set var="badge" value="bg-orange-100 text-orange-700"/>
                        </c:when>
                        <c:when test="${denuncia.status eq 'Invalidada'}">
                            <c:set var="badge" value="bg-gray-100 text-gray-700"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="badge" value="bg-green-100 text-green-700"/>
                        </c:otherwise>
                    </c:choose>

                    <div class="flex items-center gap-2 mb-4">
                        <span class="px-2 py-1 rounded text-sm ${badge}">
                            Status: <c:out value="${denuncia.status}"/>
                        </span>
                        <span class="text-slate-400 text-sm">
                            Denúncia #<c:out value="${denuncia.idDenuncia}"/>
                        </span>
                    </div>

                    <div class="grid md:grid-cols-2 gap-4 mb-6">
                        <div class="p-4 rounded-xl bg-slate-50">
                            <h3 class="font-semibold mb-2 flex items-center gap-2"><i class="bi bi-person"></i> Cliente</h3>
                            <p><span class="font-medium">Nome:</span> <c:out value="${denuncia.clienteNome}"/></p>
                            <p><span class="font-medium">Email:</span> <c:out value="${denuncia.clienteEmail}"/></p>
                        </div>
                        <div class="p-4 rounded-xl bg-slate-50">
                            <h3 class="font-semibold mb-2 flex items-center gap-2"><i class="bi bi-briefcase"></i> Profissional</h3>
                            <p><span class="font-medium">Nome:</span> <c:out value="${denuncia.profissionalNome}"/></p>
                            <p><span class="font-medium">Email:</span> <c:out value="${denuncia.profissionalEmail}"/></p>
                        </div>
                    </div>

                    <div class="grid md:grid-cols-2 gap-4 mb-6">
                        <div>
                            <label class="block mb-1 font-medium">Motivo</label>
                            <input type="text" class="w-full border rounded-lg p-2 bg-gray-100"
                                   value="<c:out value='${denuncia.motivo}'/>" readonly/>
                        </div>
                        <div>
                            <label class="block mb-1 font-medium">Ação atual</label>
                            <input type="text" class="w-full border rounded-lg p-2 bg-gray-100"
                                   value="<c:out value='${empty denuncia.acaoTomada ? "NENHUMA" : denuncia.acaoTomada}'/>" readonly/>
                        </div>
                    </div>

                    <div class="mb-6">
                        <label class="block mb-1 font-medium">Descrição</label>
                        <textarea rows="6" class="w-full border rounded-lg p-3 bg-gray-100" readonly>
                            <c:out value="${denuncia.descricao}"/></textarea>
                    </div>

                    <!-- Formulário -->
                    <form method="post" action="${pageContext.request.contextPath}/denuncias" class="mt-2">
                        <input type="hidden" name="acao" value="moderar"/>
                        <input type="hidden" name="id_denuncia" value="${denuncia.idDenuncia}"/>

                        <div class="grid md:grid-cols-3 gap-4">
                            <div>
                                <label class="block mb-1 font-medium">Tipo de ação</label>
                                <!-- valores compatíveis com o backend/DAO -->
                                <select name="tipo_acao" class="w-full border rounded-lg p-2" required>
                                    <option value="SUSPENDER">Suspender</option>
                                    <option value="BANIR">Banir</option>
                                    <option value="INVALIDAR">Invalidar</option>
                                </select>
                            </div>

                            <div>
                                <label class="block mb-1 font-medium">Aplicar em</label>
                                <select name="aplicar_em" class="w-full border rounded-lg p-2">
                                    <option value="profissional" selected>Profissional</option>
                                    <option value="cliente">Cliente</option>
                                </select>
                            </div>

                            <div>
                                <label class="block mb-1 font-medium">Prazo (suspensão)</label>
                                <input type="date" name="prazo_suspensao" class="w-full border rounded-lg p-2"/>
                            </div>
                        </div>

                        <div class="mt-4">
                            <label class="block mb-1 font-medium">Observação do moderador</label>
                            <textarea name="observacao" rows="4" class="w-full border rounded-lg p-3"
                                      placeholder="Descreva o racional da decisão..."></textarea>
                        </div>

                        <div class="flex flex-wrap gap-2 mt-6">
                            <button type="submit"
                                    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition inline-flex items-center gap-2">
                                <i class="bi bi-check2-circle"></i> Confirmar ação
                            </button>
                            <a href="${pageContext.request.contextPath}/denuncias?acao=listar"
                               class="px-4 py-2 bg-slate-100 text-slate-700 rounded-lg hover:bg-slate-200 transition inline-flex items-center gap-2">
                                <i class="bi bi-x-circle"></i> Cancelar
                            </a>
                        </div>
                    </form>

                    <!-- Histórico -->
                    <c:if test="${not empty denuncia.dataModeracao}">
                        <div class="mt-8 p-4 rounded-xl bg-slate-50 border border-slate-200">
                            <h4 class="font-semibold mb-2 flex items-center gap-2">
                                <i class="bi bi-clock-history"></i> Última moderação
                            </h4>
                            <p class="text-sm">
                                <span class="font-medium">Ação: </span><c:out value="${denuncia.acaoTomada}"/> •
                                <span class="font-medium">Data: </span>
                                <fmt:formatDate value="${denuncia.dataModeracao}" pattern="dd/MM/yyyy"/>
                                <c:if test="${not empty denuncia.prazoSuspensao}">
                                    • <span class="font-medium">Prazo suspensão: </span>
                                    <fmt:formatDate value="${denuncia.prazoSuspensao}" pattern="dd/MM/yyyy"/>
                                </c:if>
                            </p>
                            <c:if test="${not empty denuncia.observacaoModeracao}">
                                <p class="text-sm mt-1"><span class="font-medium">Observação: </span>
                                    <c:out value="${denuncia.observacaoModeracao}"/></p>
                                </c:if>
                        </div>
                    </c:if>
                </div>
            </section>
        </main>
    </body>
</html>
