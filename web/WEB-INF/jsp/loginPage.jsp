<%-- 
    Document   : login
    Created on : Dec 27, 2015, 7:41:23 PM
    Author     : Diana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Log In | Edelweiss Pediatrics</title>
        <!-- FavIcon -->
        <spring:url value="resources/images/favicon.ico" var="favicon" />
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
                    <sec:authorize access="isAuthenticated()">
                        Welcome, <strong><sec:authentication property="principal.username" /></strong>!
                        <br class="clear" />
                        <spring:url value="/logout" var="url" htmlEscape="true"/>
                        <spring:url value="/change_pass/" var="pass" htmlEscape="true"/>
                        <spring:url value="/home" var="home" htmlEscape="true"/>

                        <a href="${home}">Home |</a>
                        <a href="${pass}">Change password |</a>
                        <a href="${url}">Log out</a>
                    </sec:authorize>
                    <sec:authorize access="isAnonymous()">
                        Welcome, <strong>guest</strong>!
                        <br class="clear" />
                        <spring:url value="/home" var="home" htmlEscape="true"/>
                        <spring:url value="/register" var="pass" htmlEscape="true"/>

                        <a href="${home}">Home |</a>
                        <a href="${pass}">Register</a>
                    </sec:authorize>

                </div>
            </div>
            <!-- Content -->
            <div id="content" class="colM">
                <div id="content-main">
                    <form method="post" action="<spring:url value='login'/>" >
                        <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>
                        <table>
                            <tbody>
                                <tr>
                                    <td>Username:</td>
                                    <td><input type='text' name='username' /></td>
                                </tr>
                                <tr>
                                    <td>Password:</td>
                                    <td><input type='password' name='password'></td>
                                </tr>
                            </tbody>
                        </table>
                        <div>                          
                            <input type="submit" value="Login" class="default" name="login" />
                        </div>

                </div>
                </form>
            </div>
            <br class="clear" />


            <div id="footer"></div>
        </div>
    </body>
</html>
