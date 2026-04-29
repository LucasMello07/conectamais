<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Conecta+: Recuperar Senha</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="flex items-center justify-center min-h-screen bg-gray-50" style="font-family: 'Poppins', sans-serif;">
        <div class="w-full max-w-md bg-white rounded-2xl shadow-lg p-8">
            <div class="flex justify-center mb-6">
                <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
            </div>

            <h2 class="text-2xl font-bold text-center text-slate-700 mb-2">Recuperar Senha</h2>
            <p class="text-sm text-gray-600 text-center mb-6">
                Informe seu e-mail cadastrado e enviaremos um link para redefinição de senha.
            </p>

            <!-- Alertas -->
            <c:if test="${not empty erro}">
                <div class="mb-4 p-3 rounded-lg text-sm bg-red-50 text-red-700 border border-red-200 text-center">
                    ${erro}
                </div>
            </c:if>
            <c:if test="${not empty mensagem}">
                <div class="mb-4 p-3 rounded-lg text-sm bg-green-50 text-green-700 border border-green-200 text-center">
                    ${mensagem}
                </div>
            </c:if>

            <form id="formRecuperar" action="${pageContext.request.contextPath}/recuperar-senha" method="post" class="space-y-4" novalidate>
                <div>
                    <label for="email" class="block text-sm font-semibold text-slate-600 mb-1">E-mail</label>
                    <input
                        id="email"
                        type="email"
                        name="email"
                        required
                        autocomplete="email"
                        inputmode="email"
                        value="${fn:escapeXml(param.email)}"
                        class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="seuemail@exemplo.com"
                        >
                </div>

                <button id="btnEnviar" type="submit"
                        class="w-full py-2 mt-4 bg-gradient-to-r from-blue-600 to-green-400 text-white font-semibold rounded-lg hover:opacity-90 transition disabled:opacity-50 disabled:cursor-not-allowed">
                    Enviar Link de Recuperação
                </button>
            </form>

            <div class="flex justify-between items-center mt-6 text-sm">
                <a href="${pageContext.request.contextPath}/pages/landing-Page/login.jsp" class="text-blue-600 hover:underline">
                    Voltar para Login
                </a>
                <a href="${pageContext.request.contextPath}/pages/landing-Page/tipo-Cadastro.jsp" class="text-green-600 hover:underline">
                    Cadastre-se
                </a>
            </div>
        </div>

        <script>
            // Evita duplo envio e dá feedback
            (function () {
                const form = document.getElementById('formRecuperar');
                const btn = document.getElementById('btnEnviar');
                form.addEventListener('submit', function () {
                    btn.disabled = true;
                    const original = btn.textContent;
                    btn.dataset.original = original;
                    btn.textContent = 'Enviando...';
                });
            })();
        </script>
    </body>
</html>
