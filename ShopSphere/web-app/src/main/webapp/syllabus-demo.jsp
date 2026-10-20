<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="x" uri="jakarta.tags.xml" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- 1. Traditional JSP Declaration: Class variable / method --%>
<%! 
    private int demoHitCount = 0; 

    public String getSyllabusNotice() {
        return "Demonstrating RTU Advanced Java Core Concepts";
    }
%>

<%-- 2. Traditional JSP Scriptlet: Executable Java code inside page --%>
<%
    demoHitCount++;
    String timestamp = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
    String sampleText = "Rajasthan Technical University Advanced Java Practical Exam";
%>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="RTU Syllabus Academic Demonstrations | ShopSphere"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<div class="mb-4">
    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 rounded-pill fw-semibold mb-2">
        <i class="bi bi-mortarboard-fill me-1"></i> RTU Syllabus Topic Showcase
    </span>
    <h3 class="fw-bold mb-1">Academic & Syllabus Practical Demonstrations</h3>
    <p class="text-muted small">Live exhibits of traditional JSP syntax, JSTL XML/Functions, java.net URLConnection, JNDI, and Applet history</p>
</div>

<!-- TOPIC 1: Traditional JSP Elements -->
<div class="card border-0 shadow-sm p-4 mb-4">
    <div class="d-flex align-items-center gap-2 mb-3">
        <span class="badge bg-primary fs-6">Topic 1</span>
        <h5 class="fw-bold mb-0">Traditional JSP Syntax Elements</h5>
    </div>
    <p class="text-muted small">
        Demonstration of JSP Declaration (<code>&lt;%! %&gt;</code>), Scriptlet (<code>&lt;% %&gt;</code>), 
        Expression (<code>&lt;%= %&gt;</code>), and Comments (<code>&lt;%-- --%&gt;</code>).
    </p>

    <div class="row g-3">
        <div class="col-md-6">
            <div class="bg-light p-3 rounded-3 border">
                <h6 class="fw-bold text-secondary mb-2">JSP Declaration Result</h6>
                <div class="small">Method Call: <code>getSyllabusNotice()</code></div>
                <div class="fw-semibold text-primary mt-1"><%= getSyllabusNotice() %></div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="bg-light p-3 rounded-3 border">
                <h6 class="fw-bold text-secondary mb-2">JSP Expression & Scriptlet Result</h6>
                <div class="small">Persistent Page Hit Counter: <code>demoHitCount</code></div>
                <div class="fw-semibold text-success mt-1">Total Hits: <%= demoHitCount %> (Evaluated at <%= timestamp %>)</div>
            </div>
        </div>
    </div>
</div>

<%-- TOPIC 2: JSTL XML Parsing (<x:parse> and <x:out>) --%>
<div class="card border-0 shadow-sm p-4 mb-4">
    <div class="d-flex align-items-center gap-2 mb-3">
        <span class="badge bg-success fs-6">Topic 2</span>
        <h5 class="fw-bold mb-0">JSTL XML Tag Library (&lt;x:parse&gt; &amp; &lt;x:forEach&gt;)</h5>
    </div>
    <p class="text-muted small">
        Demonstration of parsing an XML document feed directly in JSP without Java DOM boilerplate.
    </p>

    <x:parse xml="${xmlCatalog}" var="parsedDoc"/>

    <div class="table-responsive">
        <table class="table table-bordered table-sm align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase">
                    <th>Item ID</th>
                    <th>Book Title</th>
                    <th>Price (₹)</th>
                    <th>Stock</th>
                </tr>
            </thead>
            <tbody>
                <x:forEach select="$parsedDoc/catalog/item">
                    <tr>
                        <td><code><x:out select="@id"/></code></td>
                        <td class="fw-semibold"><x:out select="title"/></td>
                        <td>₹<x:out select="price"/></td>
                        <td><span class="badge bg-info text-dark"><x:out select="stock"/> in stock</span></td>
                    </tr>
                </x:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- TOPIC 3: JSTL Functions (fn:) -->
<div class="card border-0 shadow-sm p-4 mb-4">
    <div class="d-flex align-items-center gap-2 mb-3">
        <span class="badge bg-info text-dark fs-6">Topic 3</span>
        <h5 class="fw-bold mb-0">JSTL Standard EL Functions (fn: library)</h5>
    </div>
    <p class="text-muted small">
        Performing string and collection transformations in Expression Language.
    </p>

    <ul class="list-group list-group-flush small">
        <li class="list-group-item d-flex justify-content-between">
            <span>Original String:</span>
            <code>"<%= sampleText %>"</code>
        </li>
        <li class="list-group-item d-flex justify-content-between">
            <span><code>fn:toUpperCase()</code>:</span>
            <span class="fw-bold">${fn:toUpperCase(sampleText)}</span>
        </li>
        <li class="list-group-item d-flex justify-content-between">
            <span><code>fn:length()</code>:</span>
            <span class="badge bg-primary">${fn:length(sampleText)} characters</span>
        </li>
        <li class="list-group-item d-flex justify-content-between">
            <span><code>fn:contains(..., 'Advanced')</code>:</span>
            <span class="badge bg-success">${fn:contains(sampleText, 'Advanced') ? 'TRUE' : 'FALSE'}</span>
        </li>
    </ul>
</div>

<!-- TOPIC 4: java.net URL & URLConnection -->
<div class="card border-0 shadow-sm p-4 mb-4">
    <div class="d-flex align-items-center gap-2 mb-3">
        <span class="badge bg-warning text-dark fs-6">Topic 4</span>
        <h5 class="fw-bold mb-0">java.net URL & URLConnection Protocol Handler</h5>
    </div>
    <p class="text-muted small">
        Demonstration of using <code>java.net.URL</code> and <code>HttpURLConnection</code> to connect and read headers over HTTP protocol.
    </p>

    <div class="bg-dark text-light p-3 rounded-3 font-monospace small">
        ${urlDemoResult}
    </div>
</div>

<!-- TOPIC 5: JNDI (Java Naming and Directory Interface) -->
<div class="card border-0 shadow-sm p-4 mb-4">
    <div class="d-flex align-items-center gap-2 mb-3">
        <span class="badge bg-danger fs-6">Topic 5</span>
        <h5 class="fw-bold mb-0">JNDI Architecture & InitialContext Lookup</h5>
    </div>
    <p class="text-muted small">
        In J2EE / Jakarta EE, <code>InitialContext</code> is used to decouple database resources (DataSources, Connection Pools) from application code.
    </p>

    <div class="bg-light p-3 rounded-3 border font-monospace small">
        ${jndiResult}
    </div>
</div>

<!-- TOPIC 6: Applets Historical Transition Note -->
<div class="card border-0 shadow-sm p-4 mb-4">
    <div class="d-flex align-items-center gap-2 mb-3">
        <span class="badge bg-secondary fs-6">Topic 6</span>
        <h5 class="fw-bold mb-0">Applets vs Modern Web Containers (Evolution of Java Web)</h5>
    </div>
    <p class="text-secondary small mb-2">
        <strong>Historical Context (RTU Syllabus):</strong> Java Applets were client-side mini-programs downloaded by browser plugins running inside a sandboxed JVM (<code>java.applet.Applet</code> / <code>JApplet</code>).
    </p>
    <p class="text-secondary small mb-0">
        <strong>Modern Transition:</strong> Web browsers eliminated NPAPI plugin support for security and performance reasons. Enterprise Java migrated client logic to standard HTML5/CSS/JavaScript and backend business logic to <strong>Jakarta Servlets, JSP, Web Containers (Apache Tomcat), and RESTful microservices</strong> as fully implemented in this ShopSphere project.
    </p>
</div>

<jsp:include page="fragments/footer.jsp" />
