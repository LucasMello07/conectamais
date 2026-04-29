<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Conecta+: Login</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <script src="https://cdn.tailwindcss.com"></script>
  </head>

  <body class="flex items-center justify-center min-h-screen bg-gray-50" style="font-family: 'Poppins', sans-serif;">
    
    <!-- Container Login -->
    <div class="w-full max-w-md bg-white rounded-2xl shadow-lg p-8">
      
      <!-- Logo -->
      <div class="flex justify-center mb-6">
        <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-12 object-contain">
      </div>

      <!-- Título -->
      <h2 class="text-2xl font-bold text-center text-slate-700 mb-6">Acesse sua conta</h2>
      
      <c:if test="${not empty erro}">
        <c:choose>
          <c:when test="${erro eq 'Senha incorreta!'}">
            <div class="mb-4 p-2 text-sm text-red-600 bg-red-100 border border-red-300 rounded-lg">
              <i class="bi bi-exclamation-triangle-fill mr-1"></i> ${erro}
            </div>
          </c:when>
          <c:when test="${erro eq 'Usuário não cadastrado!'}">
            <div class="mb-4 p-2 text-sm text-orange-600 bg-orange-100 border border-orange-300 rounded-lg">
              <i class="bi bi-person-x-fill mr-1"></i> ${erro}
            </div>
          </c:when>
          <c:when test="${fn:contains(erro, 'banido')}">
            <div class="mb-4 p-2 text-sm text-red-700 bg-red-200 border border-red-400 rounded-lg">
              <i class="bi bi-slash-circle-fill mr-1"></i> ${erro}
            </div>
          </c:when>
          <c:when test="${fn:contains(erro, 'suspenso')}">
            <div class="mb-4 p-2 text-sm text-yellow-700 bg-yellow-200 border border-yellow-400 rounded-lg">
              <i class="bi bi-pause-circle-fill mr-1"></i> ${erro}
            </div>
          </c:when>

          <c:otherwise>
            <div class="mb-4 p-2 text-sm text-gray-600 bg-gray-100 border border-gray-300 rounded-lg">
              <i class="bi bi-info-circle-fill mr-1"></i> ${erro}
            </div>
          </c:otherwise>
        </c:choose>
      </c:if>

      <!-- Formulário -->
      <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-4">
        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Email</label>
          <input type="email" name="email" required 
                 class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>

        <div>
          <label class="block text-sm font-semibold text-slate-600 mb-1">Senha</label>
          <input type="password" name="senha" required 
                 class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>

        <button type="submit" class="w-full py-2 mt-4 bg-gradient-to-r from-blue-600 to-green-400 text-white font-semibold rounded-lg hover:opacity-90 transition">
          Entrar
        </button>
      </form>

      <!-- Links extras -->
      <div class="flex justify-between items-center mt-6 text-sm">
        <a href="${pageContext.request.contextPath}/recuperar-senha" class="text-blue-600 hover:underline">Esqueci minha senha</a>
        <a href="${pageContext.request.contextPath}/pages/landing-Page/tipo-Cadastro.jsp" class="text-green-600 hover:underline">Cadastre-se</a>
      </div>
    </div>

  </body>
</html>
