<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="score" required="true" type="java.lang.Integer" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<span class="rating-stars">
    <c:forEach begin="1" end="5" var="i">
        <c:choose>
            <c:when test="${i <= score}">
                <i class="bi bi-star-fill text-warning"></i>
            </c:when>
            <c:otherwise>
                <i class="bi bi-star text-muted"></i>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</span>
