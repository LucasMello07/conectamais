<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  conecta.entidades.Usuario usuarioLogado = (conecta.entidades.Usuario) session.getAttribute("usuarioLogado");
  if (usuarioLogado == null || !"Cliente".equalsIgnoreCase(usuarioLogado.getTipoUsuario())) {
      response.sendRedirect(request.getContextPath() + "/pages/landing-Page/index.jsp");
      return;
  }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Conecta+: Meu Perfil</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
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

        <!-- Main Content -->
        <main class="ml-72 p-6">
            <!-- Navbar -->
            <nav class="w-full mb-6 rounded-2xl bg-gradient-to-r from-blue-600 to-green-400 p-4 flex justify-between items-center text-white shadow-md">
                <div>
                    <ol class="flex flex-wrap pt-1 bg-transparent rounded-lg">
                        <li class="leading-normal text-sm opacity-80"><a href="javascript:;">Páginas</a></li>
                        <li class="text-sm pl-2 capitalize leading-normal before:pr-2 before:content-['/']">Gerenciar Perfil</li>
                    </ol>
                    <h6 class="mb-0 font-bold capitalize">Meu Perfil</h6>
                </div>
            </nav>

            <section class="bg-white shadow-md rounded-2xl p-6">
                <c:if test="${not empty sessionScope.flash}">
                    <div class="mb-4 p-3 rounded bg-green-100 text-green-800 border border-green-200">
                        ${sessionScope.flash}
                    </div>
                    <c:remove var="flash" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.flashErro}">
                    <div class="mb-4 p-3 rounded bg-red-100 text-red-800 border border-red-200">
                        ${sessionScope.flashErro}
                    </div>
                    <c:remove var="flashErro" scope="session"/>
                </c:if>

                <div class="flex items-center gap-4 mb-6">
                    <div class="w-20 h-20 rounded-full bg-gradient-to-r from-blue-600 to-green-400 flex items-center justify-center text-white text-3xl font-bold">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div>
                        <h2 class="text-xl font-bold">${usuario.nomeCompleto}</h2>
                        <p class="text-slate-500">${usuario.email}</p>
                    </div>
                </div>

                <!-- Formulário -->
                <form id="perfilForm" action="${pageContext.request.contextPath}/perfil" method="post" class="grid grid-cols-2 gap-6">
                    <input type="hidden" name="genero" value="${usuario.genero}">
                    <input type="hidden" name="acao" value="atualizar"/>

                    <div class="col-span-2 md:col-span-1">
                        <label class="block text-sm font-semibold mb-1">Nome completo</label>
                        <input type="text" name="nome_completo" value="${usuario.nomeCompleto}" disabled class="w-full p-2 border rounded-lg bg-gray-100" required>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold mb-1">Celular</label>
                        <input type="text" name="celular" value="${usuario.celular}" disabled class="w-full p-2 border rounded-lg bg-gray-100">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold mb-1">Estado</label>
                        <input type="text" name="estado" value="${usuario.estado}" disabled class="w-full p-2 border rounded-lg bg-gray-100" maxlength="2" placeholder="UF (ex.: SP)">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold mb-1">Cidade</label>
                        <input type="text" name="cidade" value="${usuario.cidade}" disabled class="w-full p-2 border rounded-lg bg-gray-100">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold mb-1">Bairro</label>
                        <input type="text" name="bairro" value="${usuario.bairro}" disabled class="w-full p-2 border rounded-lg bg-gray-100">
                    </div>

                    <div class="col-span-2">
                        <label class="block text-sm font-semibold mb-1">Endereço (Rua, Nº)</label>
                        <input type="text" name="endereco_rua" value="${usuario.enderecoRua}" disabled class="w-full p-2 border rounded-lg bg-gray-100">
                    </div>

                    <div>
                        <label class="block text-sm font-semibold mb-1">Email</label>
                        <input type="email" name="email" value="${usuario.email}" disabled class="w-full p-2 border rounded-lg bg-gray-100" required>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold mb-1">Senha</label>
                        <input type="password" value="********" disabled class="w-full p-2 border rounded-lg bg-gray-100">
                        <div class="mt-2">
                            <a href="${pageContext.request.contextPath}/perfil-senha" class="inline-flex items-center gap-1 text-sm text-purple-700 hover:text-purple-900">
                                <i class="bi bi-key"></i> Alterar senha
                            </a>
                        </div>
                    </div>
                </form>

                <div class="flex justify-end gap-4 mt-6">
                    <button id="editarBtn" type="button" class="px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-100 transition">
                        Editar Informações
                    </button>
                    <button id="salvarBtn" type="submit" form="perfilForm" disabled class="px-4 py-2 rounded-lg bg-gradient-to-r from-blue-600 to-green-400 text-white font-semibold opacity-50 cursor-not-allowed">
                        Salvar Alterações
                    </button>
                </div>
            </section>
        </main>
        <script>
            (function () {
                const editarBtn = document.getElementById("editarBtn");
                const salvarBtn = document.getElementById("salvarBtn");
                const inputs = document.querySelectorAll("#perfilForm input");

                function isSenhaField(inp) {
                    return inp.type === "password" || inp.name === "senha";
                }

                function maskPhone(value) {
                    if (!value)
                        return "";
                    let v = value.replace(/\D/g, "");
                    v = v.slice(0, 11);
                    if (v.length > 10) {
                        return v.replace(/^(\d{2})(\d{5})(\d{4}).*/, "($1) $2-$3");
                    } else if (v.length > 6) {
                        return v.replace(/^(\d{2})(\d{4})(\d{0,4}).*/, "($1) $2-$3");
                    } else if (v.length > 2) {
                        return v.replace(/^(\d{2})(\d{0,4}).*/, "($1) $2");
                    } else {
                        return v.replace(/^(\d{0,2}).*/, "($1");
                    }
                }

                function handlePhoneInput(e) {
                    const start = e.target.selectionStart;
                    const before = e.target.value;
                    e.target.value = maskPhone(e.target.value);
                    const diff = e.target.value.length - before.length;
                    try {
                        e.target.setSelectionRange(start + diff, start + diff);
                    } catch (e) {
                    }
                }

                const cel = document.querySelector('input[name="celular"]');
                if (cel) {
                    cel.value = maskPhone(cel.value || "");
                    cel.addEventListener("input", handlePhoneInput);
                    cel.addEventListener("blur", function () {
                        const digits = (cel.value || "").replace(/\D/g, "");
                        if (digits.length < 10) {
                            cel.setCustomValidity("Informe um telefone válido (DDD + número).");
                        } else {
                            cel.setCustomValidity("");
                        }
                    });
                }
                const form = document.getElementById('perfilForm');
                if (form) {
                    form.addEventListener('submit', function () {
                        const cel = form.querySelector('input[name="celular"]');
                        if (cel && cel.value) {
                            cel.value = (cel.value || '').replace(/\D/g, '').slice(0, 11);
                        }
                    });
                }

                editarBtn.addEventListener("click", () => {
                    inputs.forEach(input => {
                        if (isSenhaField(input))
                            return;
                        input.disabled = false;
                        input.classList.remove("bg-gray-100");
                        input.classList.add("focus:ring-2", "focus:ring-blue-500");
                    });
                    salvarBtn.disabled = false;
                    salvarBtn.classList.remove("opacity-50", "cursor-not-allowed");
                });
            })();
        </script>
    </body>
</html>
