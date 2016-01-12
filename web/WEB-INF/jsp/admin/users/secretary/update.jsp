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
        <title>Change secretary | Edelweiss Pediatrics admin</title>
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
                <spring:url value="/admin/" var="home" htmlEscape="true"/>
                <a href="${home}">Home</a>
                &rsaquo;
                <spring:url value="/admin/users/" var="users" htmlEscape="true"/>
                <a href="${users}">Users</a>
                &rsaquo;
                <spring:url value="/admin/users/secretary/change/" var="l_to_s" htmlEscape="true"/>
                <a href="${l_to_s}">Secretaries</a>
                &rsaquo;
                ${username}
            </div>

            <!-- Content -->
            <div id="content" class="colM">

                <h1>Change ${username}</h1>
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
                    <form action="" method="post" id="user_form">
                        <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>

                        <div>
                            <fieldset class="module aligned wide">
                                <div class="form-row field-username">
                                    <div>
                                        <label class="required">Username:</label>
                                        <input type="text" readonly="readonly" name="username" value="${username}" maxlength="45" />
                                        <p class="help">You cannot change this.</p>
                                    </div>
                                </div>
                                <div class="form-row field-password1">
                                    <div>
                                        <label class="required">Password:</label>
                                        <input type="password" name="pass" value="pass" />
                                        <p class="help">You cannot change this.</p>
                                    </div>
                                </div>
                                <div class="form-row field-username">
                                    <label class="required">Active:</label>
                                    <c:if test="${enabled eq 1}">
                                        <input type="checkbox" checked="on" value="on" 
                                               name="enabled" class="action-select"/>
                                    </c:if>
                                    <c:if test="${enabled != 1}">
                                        <input type="checkbox" name="enabled" class="action-select"/>
                                    </c:if>
                                </div>
                                <input type="hidden" name="role" value="ROLE_SECRET"/>
                            </fieldset>
                            <div class="submit-row">
                                <input type="submit" value="Save" class="default" name="_save" />
                                <input type="submit" value="Discard Changes" class="default" name="_discard" />
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
