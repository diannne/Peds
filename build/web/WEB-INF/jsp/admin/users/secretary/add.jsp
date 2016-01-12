<%-- 
    Document   : add
    Created on : Jan 4, 2016, 8:00:09 PM
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
        <title>Add secretary | Edelweiss Pediatrics admin</title>
    <spring:url value="/resources/images/favicon.ico" var="favicon" />
    <link rel="shortcut icon" href="${favicon}" />
    <spring:url value="/resources/css/base.css" var="mainCss" />
    <link href="${mainCss}" rel="stylesheet" />
    <spring:url value="/resources/css/forms.css" var="formsCss" />
    <link href="${formsCss}" rel="stylesheet" />
</head>
<body class="auth-user change-form">

    <!-- Container -->
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

        <div class="breadcrumbs">
            <spring:url value="/admin" var="home" htmlEscape="true"/>
            <a href="${home}">Home</a>
            &rsaquo;
            <spring:url value="/admin/users" var="users" htmlEscape="true"/>
            <a href="${users}">Users</a>
            &rsaquo;
            <spring:url value="/admin/users/secretary" var="sec" htmlEscape="true"/>
            <a href="${sec}">Secretaries</a>
            &rsaquo;
            Add secretary
        </div>

        <!-- Content -->
        <div id="content" class="colM">

            <h1>Add Secretary</h1>
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
                <form action="add" method="post" id="user_form">
                    <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>
                    
                    <div>
                        <fieldset class="module aligned wide">
                            <div class="form-row field-username">
                                <div>
                                    <label for="id_username" class="required">Username:</label>
                                    <input id="id_username" type="text" name="username" maxlength="30" />
                                    <p class="help">Required. 30 characters or fewer. Letters, digits and @/./+/-/_ only.</p>
                                </div>
                            </div>
                            <div class="form-row field-password1">
                                <div>
                                    <label for="id_password1" class="required">Password:</label>
                                    <input type="password" name="pass1" id="id_password1" />
                                </div>
                            </div>
                            <div class="form-row field-password2">
                                <div>
                                    <label for="id_password2" class="required">Password confirmation:</label>
                                    <input type="password" name="pass2" id="id_password2" />
                                    <p class="help">Enter the same password as above, for verification.</p>
                                </div>
                            </div>
                            <input type="hidden" name="role" value="ROLE_SECRET"/>
                        </fieldset>
                        <div class="submit-row">
                            <input type="submit" value="Save" class="default" name="_save" />
                        </div>
                    </div>
                </form>
            </div>
            <br class="clear" />
        </div>
        <div id="footer"></div>
    </div>
</body>
</html>
