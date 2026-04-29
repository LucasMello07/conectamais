<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.*" %>
<%@ page import="conecta.entidades.Usuario" %>
<%@ page import="conecta.dto.ModeracaoUsuarioDTO" %>

<%!
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;")
                .replace("<","&lt;")
                .replace(">","&gt;")
                .replace("\"","&quot;")
                .replace("'","&#39;");
    }
%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null || !"Administrador".equalsIgnoreCase(usuario.getTipoUsuario())) {
        response.sendRedirect(request.getContextPath() + "/pages/landing-Page/index.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<ModeracaoUsuarioDTO> moderacoes = (List<ModeracaoUsuarioDTO>) request.getAttribute("moderacoes");
    if (moderacoes == null) moderacoes = Collections.emptyList();

    Integer qtdSuspensos = (Integer) request.getAttribute("qtdSuspensos");
    Integer qtdBanidos   = (Integer) request.getAttribute("qtdBanidos");
    Integer qtdInvalidas = (Integer) request.getAttribute("qtdInvalidas");
    if (qtdSuspensos == null) qtdSuspensos = 0;
    if (qtdBanidos   == null) qtdBanidos   = 0;
    if (qtdInvalidas == null) qtdInvalidas = 0;

    final SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
    final String cp = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Conecta+: Usuários Moderados</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="m-0 font-sans antialiased bg-gray-50 text-slate-600" style="font-family: 'Poppins', sans-serif;">

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
                    <a href="<%=cp%>/usuarios"
                       class="flex items-center gap-3 p-2 rounded-lg border-2 border-blue-600 bg-blue-50">
                        <div class="w-8 h-8 flex items-center justify-center rounded-md bg-gradient-to-tl from-blue-600 to-green-400 text-white">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <span>Usuários Moderados</span>
                    </a>
                </li>
                <li>
                    <a href="<%=cp%>/logout"
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
                        <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Usuários Moderados</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Bem-vindo, <%=esc(usuario.getNomeCompleto())%></h6>
                </div>
            </nav>

            <section class="w-full mb-6">
                <div class="flex flex-wrap gap-6">
                    <div class="flex-1 min-w-[250px] bg-white shadow-md rounded-2xl p-4">
                        <p class="text-sm font-semibold">Usuários Suspensos</p>
                        <h5 class="text-xl font-bold"><%=qtdSuspensos%></h5>
                    </div>
                    <div class="flex-1 min-w-[250px] bg-white shadow-md rounded-2xl p-4">
                        <p class="text-sm font-semibold">Usuários Banidos</p>
                        <h5 class="text-xl font-bold"><%=qtdBanidos%></h5>
                    </div>
                    <div class="flex-1 min-w-[250px] bg-white shadow-md rounded-2xl p-4">
                        <p class="text-sm font-semibold">Denúncias Invalidadas</p>
                        <h5 class="text-xl font-bold"><%=qtdInvalidas%></h5>
                    </div>
                </div>
            </section>

            <!-- Tabela -->
            <section class="w-full">
                <div class="bg-white shadow-md rounded-2xl overflow-hidden">
                    <div class="p-4 border-b">
                        <h6 class="font-bold align-middle text-slate-700">Controle de Usuários</h6>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="p-3 text-center">Status</th>
                                    <th class="p-3 text-center">ID</th>
                                    <th class="p-3 text-center">Usuário</th>
                                    <th class="p-3 text-center">Última Ação</th>
                                    <th class="p-3 text-center">Data</th>
                                    <th class="p-3 text-center">Opções</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                  if (moderacoes.isEmpty()) {
                                %>
                                <tr>
                                    <td colspan="6" class="p-6 text-center text-slate-500">Nenhum usuário moderado encontrado.</td>
                                </tr>
                                <%
                                  } else {
                                    for (ModeracaoUsuarioDTO mod : moderacoes) {
                                      String status = mod.getStatusUsuario();
                                      String classe = "bg-green-100 text-green-700";
                                      String texto  = "Ativo";
                                      if ("BANIDO".equalsIgnoreCase(status)) { classe = "bg-red-100 text-red-700"; texto = "Banido"; }
                                      else if ("SUSPENSO".equalsIgnoreCase(status)) { classe = "bg-yellow-100 text-yellow-700"; texto = "Suspenso"; }
                                %>
                                <tr class="border-b hover:bg-gray-50">
                                    <td class="p-3 text-center">
                                        <span class="px-2 py-1 rounded <%=classe%> text-sm"><%=texto%></span>
                                    </td>
                                    <td class="p-3 text-center">#<%=mod.getIdUsuario()%></td>
                                    <td class="p-3 text-center"><%=esc(mod.getNomeUsuario())%></td>
                                    <td class="p-3 text-center"><%=esc(mod.getTipoAcao())%></td>
                                    <td class="p-3 text-center"><%=mod.getDataAcao() != null ? df.format(mod.getDataAcao()) : "-"%></td>
                                    <td class="p-3 text-center">
                                        <%
                                          if ("SUSPENSO".equalsIgnoreCase(status)) {
                                        %>
                                        <form method="post" action="<%=cp%>/usuarios" style="display:inline">
                                            <input type="hidden" name="acao" value="desbloquear"/>
                                            <input type="hidden" name="id" value="<%=mod.getIdUsuario()%>"/>
                                            <button type="submit" class="text-blue-600 hover:text-blue-800" title="Desbloquear Usuário">
                                                <i class="bi bi-unlock text-xl"></i>
                                            </button>
                                        </form>
                                        <%
                                          }
                                        %>
                                    </td>
                                </tr>
                                <%
                                    }
                                  }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </main>
    </body>
</html>
