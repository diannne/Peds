<%-- 
    Document   : changePass
    Created on : Jan 3, 2016, 1:58:55 AM
    Author     : Diana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Password Change</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/base.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/login.css" var="loginCss" />
        <link href="${loginCss}" rel="stylesheet" />

        <spring:url value="/resources/css/buttons.css" var="buttonsCss" />
        <link href="${buttonsCss}" rel="stylesheet" />
    </head>
    <body class="login">

        <!-- Container -->
        <div id="container">
            <!-- Header -->
            <div id="header">
                <div id="branding">
                    <h1 id="site-name">Edelweiss Pediatrics</h1>
                </div>
                <c:if test="${'failure' eq param.error}">
                    <div style="color:red">
                        ${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message}. Try again! <br />
                    </div>
                </c:if>

                <c:if test="${param.logout != null}">
                    <div class="alert alert-success">
                        <p> Successfully logged out!</p>
                    </div>
                </c:if>

                <div id="user-tools">

                    Welcome, <strong><sec:authentication property="principal.username" /></strong>!
                    <br class="clear" />
                    <spring:url value="/logout" var="url" htmlEscape="true"/>
                    <spring:url value="/home" var="home" htmlEscape="true"/>

                    <a href="${home}">Home |</a>
                    <a href="${url}">Log out</a>

                </div>
            </div>


            <div id="content" class="colM">
                <div id="content-main">
                    <!--                    <form action="/change_pass/" method="post">-->
                    <form method="post" action="" >
                        <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>
                        <h1>Password change</h1>

                        <c:if test="${not empty message}">
                            <div style="color:red">
                                ${message} Try again! <br />
                            </div>
                        </c:if>
                        <fieldset class="module aligned wide">

                            <div class="form-row">

                                <label for="id_old_password" class="required">Old password:</label>
                                <input type="password" name="old_password" id="id_old_password" />
                            </div>

                            <div class="form-row">

                                <label for="id_new_password1" class="required">New password:</label>
                                <input type="password" name="new_password1" required="true" id="id_new_password1" />
                            </div>

                            <div class="form-row">

                                <label for="id_new_password2" class="required">Password (again):</label>
                                <input type="password" name="new_password2" required="true" id="id_new_password2" />
                            </div>

                        </fieldset>

                        <div class="submit-row">
                            <input type="submit" value="Change my password" class="default" />
                        </div>
                    </form></div>
                <br class="clear" />
            </div>
            <!-- END Content -->

            <div id="footer"></div>
        </div>
    </body>
</html>
