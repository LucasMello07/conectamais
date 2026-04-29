<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="overflow-x-auto">
    <table class="w-full bg-white rounded-2xl shadow-md overflow-hidden border-collapse">
        <thead class="bg-gradient-to-r from-blue-600 to-green-400 text-white">
            <tr>
                <th class="p-3 text-center">Posição</th>
                <th class="p-3 text-left">Nome do Profissional</th>
                <th class="p-3 text-center">Avaliação</th>
                <th class="p-3 text-center">Qtd. Avaliações</th>
                <th class="p-3 text-center">Favoritos</th>
                <th class="p-3 text-center">Ações</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach var="r" items="${listaRanking}">
                <tr class="border-t hover:bg-gray-50">
                    <td class="p-3 text-center font-semibold">
                        <c:out value="${r.posicao}"/>º
                    </td>
                    <td class="p-3">
                        <c:out value="${r.nomeCompleto}"/>
                    </td>

                    <td class="p-3 text-center">
                        <c:set var="media" value="${r.mediaNota != null ? r.mediaNota : 0}" />
                        <c:set var="full"  value="${media - (media % 1)}" />
                        <c:set var="half"  value="${(media - full) >= 0.5}" />

                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= full}">
                                    <i class="bi bi-star-fill text-yellow-500"></i>
                                </c:when>
                                <c:when test="${!(i <= full) && half}">
                                    <i class="bi bi-star-half text-yellow-500"></i>
                                    <c:set var="half" value="false"/>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-star text-yellow-500"></i>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <span class="ml-1 text-sm text-slate-500">
                            (<fmt:formatNumber value="${media}" minFractionDigits="1" maxFractionDigits="2"/>)
                        </span>
                    </td>

                    <td class="p-3 text-center">
                        <c:out value="${r.qtdAvaliacoes}"/>
                    </td>

                    <td class="p-3 text-center">
                        <c:out value="${r.qtdFavoritos}"/>
                    </td>

                    <td class="p-3 text-center">
                        <div class="flex gap-3 justify-center">
                            <a href="${pageContext.request.contextPath}/profissionais?acao=perfil&id=${r.idProfissional}"
                               class="p-2 text-slate-600 hover:text-slate-900"
                               title="Visitar perfil do profissional">
                                <i class="bi bi-person-badge"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/agendamentos?acao=novo&id_profissional=${r.idProfissional}"
                               class="p-2 text-blue-600 hover:text-blue-800"
                               title="Agendar atendimento">
                                <i class="bi bi-calendar-plus"></i>
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty listaRanking}">
                <tr>
                    <td colspan="6" class="p-6 text-center text-slate-500">
                        Nenhum profissional ranqueado.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>
