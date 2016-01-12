<%-- 
    Document   : home
    Created on : Dec 13, 2015, 10:20:41 PM
    Author     : Diana
--%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Site administration | Edelweiss Pediatrics admin</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/base.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/dashboard.css" var="dashCss" />
        <link href="${dashCss}" rel="stylesheet" />
    </head>
    <body class="dashboard">
        <div id="container">
            <!-- Header -->
            <div id="header">
                <div id="branding">
                    <h1 id="site-name">Edelweiss Pediatrics administration</h1>
                </div>

                <div id="user-tools">
                    Welcome, <strong><sec:authentication property="principal.username" /></strong>!
                    <br class="clear" />
                    <spring:url value="/logout" var="url" htmlEscape="true"/>
                    <spring:url value="/change_pass/" var="pass" htmlEscape="true"/>

                    <a href="${pass}">Change password |</a>
                    <a href="${url}">Log out</a>
                </div>
            </div>
            <!-- Content -->
            <div id="content" class="colMS">
                <c:if test="${not empty message}">
                   <c:if test="${empty error}">

                    <div style="color:green">
                        ${message}<br />
                    </div>
                    </c:if>
                </c:if>
                <h1>Site administration</h1>
                
                <div id="content-main">
                    <div class="module">
                        <table>
                            <caption><a href="<spring:url value="/admin/users" htmlEscape="true" />" class="section">Users</a></caption>
                            <tr>
                                <th scope="row"><a href="<spring:url value="/admin/users/admin/change" htmlEscape="true" />">Admins</a></th>
                                <td><a href="<spring:url value="/admin/users/admin/add" htmlEscape="true" />" class="addlink">Add</a></td>
                                <td><a href="<spring:url value="/admin/users/admin/change" htmlEscape="true" />" class="changelink">Change</a></td>
                            </tr>
                            <tr>
                                <th scope="row"><a href="<spring:url value="/admin/users/secretary/change" htmlEscape="true" />">Secretaries</a></th>
                                <td><a href="<spring:url value="/admin/users/secretary/add" htmlEscape="true" />" class="addlink">Add</a></td>
                                <td><a href="/admin/users/secretary/change" class="changelink">Change</a></td>
                            </tr>
                        </table>
                    </div>
                    <div class="module">
                        <table>
                            <caption><a href="<spring:url value="/admin/peds" htmlEscape="true" />" class="section">Pediatrics</a></caption>
                            <tr>
                                <th scope="row"><a href="<spring:url value="/admin/peds/doctor/change" htmlEscape="true" />">Doctors</a></th>
                                <td><a href="<spring:url value="/admin/peds/doctor/add" htmlEscape="true" />" class="addlink">Add</a></td>
                                <td><a href="<spring:url value="/admin/peds/doctor/change" htmlEscape="true" />" class="changelink">Change</a></td>
                            <tr>
                                <th scope="row"><a href="<spring:url value="/admin/peds/specialty/change" htmlEscape="true" />">Specialties</a></th>
                                <td><a href="<spring:url value="/admin/peds/specialty/add" htmlEscape="true" />" class="addlink">Add</a></td>
                                <td><a href="/admin/peds/specialty/change" class="changelink">Change</a></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
