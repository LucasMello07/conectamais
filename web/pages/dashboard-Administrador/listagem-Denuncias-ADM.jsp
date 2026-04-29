<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  conecta.entidades.Usuario usuarioLogado = (conecta.entidades.Usuario) session.getAttribute("usuarioLogado");
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
        <title>Painel Administrador: Lista de Denúncias</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet"/>
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
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

                <!-- Item ativo -->
                <li>
                    <a href="${pageContext.request.contextPath}/denuncias?acao=listar"
                       class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-flag-fill"></i>
                        </div>
                        <span>Painel de Denúncias</span>
                    </a>
                </li>

                <li>
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

        <!-- Main Content -->
        <main class="ml-72 p-6">
            <!-- Navbar -->
            <nav class="w-full mb-6 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
                <div>
                    <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
                        <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Painel do Admistrador</a></li>
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Denúncias</li>
                    </ol>
                    <h6 class="mb-0 font-bold ">Lista de Denúncias</h6>
                </div>
            </nav>

            <c:if test="${param.ok eq '1'}">
                <div class="mb-4 p-3 rounded-lg bg-green-50 text-green-700 border border-green-200">
                    Ação registrada com sucesso.
                </div>
            </c:if>

            <!-- Tabela -->
            <section class="w-full">
                <div class="bg-white shadow-md rounded-2xl overflow-hidden">
                    <div class="p-4 border-b">
                        <h6 class="font-bold align-middle text-slate-700">Denúncias Recebidas</h6>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="p-3 text-center">Status</th>
                                    <th class="p-3 text-center">ID</th>
                                    <th class="p-3 text-center">Cliente</th>
                                    <th class="p-3 text-center">Profissional</th>
                                    <th class="p-3 text-center">Motivo</th>
                                    <th class="p-3 text-center">Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty denuncias}">
                                        <c:forEach var="d" items="${denuncias}">
                                            <tr class="border-b hover:bg-gray-50">
                                                <td class="p-3 text-center">
                                                    <c:set var="badge"
                                                           value="${d.status eq 'Pendente' ? 'bg-yellow-100 text-yellow-700' :
                                                                    (d.status eq 'Banimento' ? 'bg-red-100 text-red-700' :
                                                                    (d.status eq 'Suspensao' ? 'bg-orange-100 text-orange-700' :
                                                                    (d.status eq 'Invalidada' ? 'bg-gray-100 text-gray-700' : 'bg-green-100 text-green-700')))}"/>
                                                    <span class="px-2 py-1 rounded text-sm ${badge}">
                                                        <c:out value="${d.status}"/>
                                                    </span>
                                                </td>
                                                <td class="p-3 text-center">#<c:out value="${d.idDenuncia}"/></td>
                                                <td class="p-3 text-center"><c:out value="${d.clienteNome}"/></td>
                                                <td class="p-3 text-center"><c:out value="${d.profissionalNome}"/></td>
                                                <td class="p-3 text-center"><c:out value="${d.motivo}"/></td>
                                                <td class="p-3 text-center">
                                                    <a href="${pageContext.request.contextPath}/denuncias?acao=ver&id=${d.idDenuncia}"
                                                       class="px-3 py-1 text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition inline-flex items-center gap-2">
                                                        <i class="bi bi-eye"></i> Visualizar
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td class="p-6 text-center text-slate-500" colspan="6">Nenhuma denúncia encontrada.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>
    </body>
</html>
