<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Conecta+: Nova Senha</title>
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

            <h2 class="text-2xl font-bold text-center text-slate-700 mb-6">Definir Nova Senha</h2>

            <!-- Mensagens de erro ou sucesso -->
            <c:if test="${not empty erro}">
                <p class="text-red-600 text-sm mb-4 text-center">${erro}</p>
            </c:if>
            <c:if test="${not empty mensagem}">
                <p class="text-green-600 text-sm mb-4 text-center">${mensagem}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/recuperar-senha" method="post" class="space-y-4">
                <input type="hidden" name="token" value="${param.token}" />

                <div>
                    <label class="block text-sm font-semibold text-slate-600 mb-1">Nova Senha</label>
                    <input type="password" name="senha" required minlength="8"
                           class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-600 mb-1">Confirmar Senha</label>
                    <input type="password" name="confirmarSenha" required minlength="8"
                           class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>

                <button type="submit" class="w-full py-2 mt-4 bg-gradient-to-r from-blue-600 to-green-400 text-white font-semibold rounded-lg hover:opacity-90 transition">
                    Salvar Nova Senha
                </button>
            </form>

            <div class="text-center mt-6 text-sm">
                <a href="${pageContext.request.contextPath}/pages/landing-Page/login.jsp" class="text-blue-600 hover:underline">
                    Voltar para Login
                </a>
            </div>
        </div>
    </body>
</html>
