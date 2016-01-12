<%-- 
    Document   : main
    Created on : Jan 3, 2016, 5:09:53 PM
    Author     : Diana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Users administration | Edelweiss Pediatrics admin</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/base.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/dashboard.css" var="dashCss" />
        <link href="${dashCss}" rel="stylesheet" />
    </head>
    <body class="dashboard">

        <div id="container">
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
            <!-- END Header -->
            <div class="breadcrumbs">
                <spring:url value="/admin" var="home" htmlEscape="true"/>
                <a href="${home}">Home</a>
                &rsaquo;
                Users
            </div>
            <!-- Content -->
            <div id="content" class="colMS">
                <h1>Users administration</h1>
                <c:if test="${not empty message}">
                    <div style="color:red">
                        ${message} Try again! <br />
                    </div>
                </c:if>
                <c:if test="${not empty info}">
                    <div style="color:green">
                        ${info}<br />
                    </div>
                </c:if>
                <div id="content-main">
                    <div class="module">
                        <table>
                            <caption><a href="" class="section">Users</a></caption>
                            <tr>
                                <spring:url value="/admin/users/admin/change/" htmlEscape="true" var="this_var"/>
                                <th scope="row"><a href="${this_var}">Admins</a></th>
                                <td><a href="<spring:url value="/admin/users/admin/add/" htmlEscape="true" />" class="addlink">Add</a></td>
                                <td><a href="${this_var}" class="changelink">Change</a></td>
                            </tr>
                            <tr>
                                <th scope="row"><a href="<spring:url value="/admin/users/secretary/change/" htmlEscape="true" />">Secretaries</a></th>
                                <td><a href="<spring:url value="/admin/users/secretary/add/" htmlEscape="true" />" class="addlink">Add</a></td>
                                <td><a href="<spring:url value="/admin/users/secretary/change/" htmlEscape="true" />" class="changelink">Change</a></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <br class="clear" />
            </div>
            <div id="footer"></div>
        </div>
    </body>
</html>
