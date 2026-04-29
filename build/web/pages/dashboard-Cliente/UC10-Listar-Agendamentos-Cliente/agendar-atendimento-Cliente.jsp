<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
  conecta.entidades.Usuario usuario = (conecta.entidades.Usuario) session.getAttribute("usuarioLogado");
  if (usuario == null || !"Cliente".equalsIgnoreCase(usuario.getTipoUsuario())) {
      response.sendRedirect(request.getContextPath() + "/pages/landing-Page/index.jsp");
      return;
  }
%>

<c:if test="${empty habilidadesAtivasDoProfissional and not empty param.id_profissional}">
    <c:redirect url="${pageContext.request.contextPath}/agendamentos">
        <c:param name="acao" value="novo"/>
        <c:param name="id_profissional" value="${param.id_profissional}"/>
    </c:redirect>
</c:if>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="minDate" />

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Conecta+: Agendar Atendimento</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 text-slate-700 antialiased" style="font-family: 'Poppins', sans-serif;">

        <c:set var="idProfissional" value="${empty idProfissional ? param.id_profissional : idProfissional}" />

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
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Agendar Atendimento</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Agende, <c:out value="${usuarioLogado.nomeCompleto}"/></h6>
                </div>
                <a href="${pageContext.request.contextPath}/perfil?acao=ver"
                   class="flex items-center gap-2 px-3 py-1 text-white font-semibold rounded-lg hover:bg-white/50 transition">
                    <i class="bi bi-person-circle"></i>
                    <span>Meu Perfil</span>
                </a>
            </nav>

            <section class="max-w-2xl mx-auto">
                <h2 class="text-2xl font-bold mb-4">Agendar Atendimento</h2>

                <c:if test="${not empty erroAgendar}">
                    <div class="mb-4 p-3 rounded-lg bg-red-50 text-red-700 border border-red-200">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span class="ml-2"><c:out value="${erroAgendar}"/></span>
                    </div>
                </c:if>

                <c:if test="${empty habilidadesAtivasDoProfissional}">
                    <div class="mb-4 p-3 rounded-lg bg-yellow-50 text-yellow-700 border border-yellow-200">
                        Nenhuma habilidade ativa para este profissional.
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/agendamentos" method="post"
                      class="bg-white rounded-2xl shadow p-6 space-y-4">
                    <input type="hidden" name="acao" value="criar"/>
                    <input type="hidden" name="id_profissional" value="${idProfissional}"/>

                    <div>
                        <label class="block text-sm font-medium mb-1">Habilidade</label>
                        <select name="id_habilidade" class="border rounded px-3 py-2 w-full" required>
                            <option value="" disabled ${empty idHabilidade ? 'selected' : ''}>Selecione...</option>
                            <c:forEach var="h" items="${habilidadesAtivasDoProfissional}">
                                <option value="${h.idHabilidade}" ${idHabilidade == h.idHabilidade ? 'selected' : ''}>
                                    <c:out value="${h.titulo}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold mb-1">Data</label>
                        <input type="date" name="data_agendamento"
                               value="${fn:escapeXml(data)}"
                               min="${minDate}"
                               class="w-full px-3 py-2 rounded-lg border border-slate-300 focus:outline-none" required/>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold mb-1">Horário</label>
                        <input type="time" name="horario_agendamento"
                               value="${fn:escapeXml(hora)}"
                               class="w-full px-3 py-2 rounded-lg border border-slate-300 focus:outline-none" required/>
                    </div>

                    <div class="pt-2">
                        <button type="submit"
                                class="px-4 py-2 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg hover:opacity-90 transition">
                            Confirmar Agendamento
                        </button>
                    </div>
                </form>

                <div class="flex justify-end mt-6 pr-6">
                    <a href="${pageContext.request.contextPath}/buscar-profissionais"
                       class="px-6 py-3 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg hover:opacity-90 transition shadow-lg">
                        Voltar
                    </a>
                </div>
            </section>
        </main>
    </body>
</html>
