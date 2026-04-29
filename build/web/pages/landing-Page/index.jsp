<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Conecta+: Página Inicial</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fav-icon.png">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
        <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>

    <body class="font-sans bg-gray-50 text-slate-700" style="font-family: 'Poppins', sans-serif;">

        <!-- Header -->
        <header class="fixed top-0 w-full bg-white shadow-md z-50">
            <div class="max-w-7xl mx-auto flex justify-between items-center p-4">
                <img src="${pageContext.request.contextPath}/img/logo-completa.png" alt="Logo Conecta+" class="h-10">
                <nav class="hidden md:flex space-x-6 font-semibold">
                    <a href="#inicio" class="hover:text-blue-600">Início</a>
                    <a href="#como-funciona" class="hover:text-blue-600">Como Funciona</a>
                    <a href="#empresa" class="hover:text-blue-600">Nossa Empresa</a>
                    <a href="#contato" class="hover:text-blue-600">Fale Conosco</a>
                </nav>
                <div class="flex space-x-4">
                    <a href="${pageContext.request.contextPath}/pages/landing-Page/login.jsp" 
                       class="px-4 py-2 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg shadow hover:opacity-90">
                        Login
                    </a>
                    <a href="${pageContext.request.contextPath}/pages/landing-Page/tipo-Cadastro.jsp" 
                       class="px-5 py-2 bg-gradient-to-r from-green-400 to-blue-600 text-white rounded-lg shadow hover:opacity-90">
                        Cadastre-se
                    </a>
                </div>

        </header>

        <main class="pt-20">

            <!-- Hero Section -->
            <section id="inicio" class="max-w-7xl mx-auto px-6 py-12 flex flex-col md:flex-row items-center gap-8">
                <div class="flex-1 md:pr-8">
                    <h1 class="text-2xl md:text-4xl font-bold mb-4 leading-tight">
                        Conectando pessoas a 
                        profissionais de forma rápida e segura
                    </h1>
                    <p class="text-base md:text-lg mb-6 text-justify">
                        Encontre o profissional ideal para o seu serviço ou ofereça seus talentos para quem precisa.
                    </p>
                    <a href="${pageContext.request.contextPath}/pages/landing-Page/tipo-Cadastro.jsp" 
                       class="inline-block px-6 py-3 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg font-semibold shadow hover:opacity-90 transition">
                        Trabalhe Conosco
                    </a>
                </div>
                <div class="flex-1 flex justify-center -mt-40">
                    <img src="${pageContext.request.contextPath}/img/banner1.png" alt="Conecta+ Hero" 
                         class="max-w-sm md:max-w-md w-auto h-auto object-contain">
                </div>
            </section>


            <!-- Como Funciona -->
            <section id="como-funciona" class="bg-white py-20">
                <div class="max-w-7xl mx-auto px-6 text-center">
                    <h2 class="text-3xl font-bold mb-10">Como Funciona</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <div class="p-6 rounded-2xl shadow-md bg-gray-50">
                            <i class="bi bi-search text-4xl text-blue-600 mb-4"></i>
                            <h3 class="font-semibold text-lg mb-2">Busque</h3>
                            <p>Encontre profissionais qualificados na sua região com rapidez e segurança.</p>
                        </div>
                        <div class="p-6 rounded-2xl shadow-md bg-gray-50">
                            <i class="bi bi-calendar-check text-4xl text-green-600 mb-4"></i>
                            <h3 class="font-semibold text-lg mb-2">Agende</h3>
                            <p>Marque seus serviços com praticidade e tenha tudo organizado em sua agenda.</p>
                        </div>
                        <div class="p-6 rounded-2xl shadow-md bg-gray-50">
                            <i class="bi bi-star text-4xl text-yellow-500 mb-4"></i>
                            <h3 class="font-semibold text-lg mb-2">Avalie</h3>
                            <p>Ajude outros usuários avaliando os profissionais após cada atendimento.</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Nossa Empresa -->
            <section id="empresa" class="max-w-7xl mx-auto px-6 py-20 flex flex-col md:flex-row items-center gap-10">
                <div class="flex-1">
                    <h2 class="text-3xl font-bold mb-6">Nossa Empresa</h2>
                    <p class="mb-6">
                        O Conecta+ nasceu com o propósito de aproximar clientes e profissionais em um ambiente seguro, 
                        moderno e eficiente, promovendo conexões que facilitam o acesso a serviços 
                        de forma prática e confiável.<br/>
                        <br/>
                        Desenvolvido para oferecer uma experiência simples e intuitiva, o Conecta+ permite que usuários 
                        encontrem rapidamente o profissional ideal para suas necessidades, 
                        enquanto os prestadores de serviço ganham mais visibilidade, autonomia e oportunidades de negócio.<br/>
                        <br/>
                        Com uma base sólida de usuários e processos em constante aprimoramento, a plataforma já auxiliou 
                        centenas de pessoas na busca por soluções ágeis e seguras, reforçando seu compromisso 
                        com a inovação, transparência e qualidade no atendimento. <br/>
                    </p>
                    <div class="flex space-x-4 text-2xl">
                        <a href="#" class="text-blue-600 hover:text-blue-800"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="text-sky-500 hover:text-sky-700"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="text-pink-600 hover:text-pink-800"><i class="bi bi-instagram"></i></a>
                    </div>
                </div>
            </section>

            <!-- Ranking Profissionais -->
            <section id="ranking" class="bg-gray-50 py-20">
                <div class="max-w-7xl mx-auto px-6">
                    <h2 class="text-3xl font-bold text-center mb-10">Top Profissionais</h2>
                    <div class="overflow-x-auto">
                        <table class="w-full bg-white rounded-2xl shadow-md overflow-hidden">
                            <thead class="bg-gradient-to-r from-blue-600 to-green-400 text-white">
                                <tr>
                                    <th class="p-3 text-left">Posição</th>
                                    <th class="p-3 text-left">Nome</th>
                                    <th class="p-3 text-left">Avaliação</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="border-b hover:bg-gray-50">
                                    <td class="p-3">1</td>
                                    <td class="p-3">Maria Silva</td>
                                    <td class="p-3">⭐ 4.9</td>
                                </tr>
                                <tr class="border-b hover:bg-gray-50">
                                    <td class="p-3">2</td>
                                    <td class="p-3">João Souza</td>
                                    <td class="p-3">⭐ 4.8</td>
                                </tr>
                                <tr class="hover:bg-gray-50">
                                    <td class="p-3">3</td>
                                    <td class="p-3">Ana Oliveira</td>
                                    <td class="p-3">⭐ 4.7</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>


            <!-- Fale Conosco -->
            <section id="contato" class="max-w-7xl mx-auto px-6 py-20">
                <h2 class="text-3xl font-bold text-center mb-10">Fale Conosco</h2>
                <form class="max-w-2xl mx-auto space-y-4">
                    <input type="text" placeholder="Nome" class="w-full border p-3 rounded-lg" required>
                    <input type="email" placeholder="Email" class="w-full border p-3 rounded-lg" required>
                    <input type="text" placeholder="Celular" class="w-full border p-3 rounded-lg" required>
                    <textarea placeholder="Mensagem" class="w-full border p-3 rounded-lg" rows="5" required></textarea>
                    <button type="submit" class="w-full py-3 bg-gradient-to-r from-blue-600 to-green-400 text-white rounded-lg font-semibold hover:opacity-90">
                        Enviar Mensagem
                    </button>
                </form>
            </section>

        </main>

        <!-- Footer -->
        <footer class="bg-white border-t py-6 mt-10">
            <div class="max-w-7xl mx-auto px-6 flex flex-col md:flex-row justify-between items-center">
                <img src="${pageContext.request.contextPath}/img/fav-icon.png" alt="Logo Conecta+" class="h-8 mb-4 md:mb-0">
                <p class="text-sm text-gray-600">© 2025 Conecta+. Todos os direitos reservados.</p>
                <div class="flex space-x-4 text-lg mt-4 md:mt-0">
                    <a href="#" class="text-blue-600 hover:text-blue-800"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="text-sky-500 hover:text-sky-700"><i class="bi bi-twitter"></i></a>
                    <a href="#" class="text-pink-600 hover:text-pink-800"><i class="bi bi-instagram"></i></a>
                </div>
            </div>
        </footer>

    </body>
</html>
