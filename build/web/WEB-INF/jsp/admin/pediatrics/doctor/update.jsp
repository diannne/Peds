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
        <title>Update Doctor | Edelweiss Pediatrics admin</title>
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
            <spring:url value="/admin/peds" var="peds" htmlEscape="true"/>
            <a href="${peds}">Pediatrics</a>
            &rsaquo;
            <spring:url value="/admin/peds/doctor/change/" var="doctor" htmlEscape="true"/>
            <a href="${doctor}">Doctors</a>
            &rsaquo;
            Update doctor
        </div>

        <!-- Content -->
        <div id="content" class="colM">

            <h1>Update doctor</h1>
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
                                    <label class="required">First Name:</label>
                                    <input type="text" name="f_name" maxlength="30" value="${f_name}"/>
                                </div>
                            </div>
                            <div class="form-row field-username">
                                <div>
                                    <label class="required">Last Name:</label>
                                    <input type="text" name="l_name" maxlength="30" value="${l_name}"/>
                                </div>
                            </div>
                            <div class="form-row">
                                <div>
                                    <label class="required">Specialty:</label>
                                    <div class="actions">
                                        <select name="action" data-selected="${spec}" selected="${spec}">
                                            <c:forEach items="${list}" var="specs">
                                                <c:if test="${spec eq specs.name}">
                                                    <option selected="selected" name="spec" value="<c:out value="${specs.name}"/>">
                                                        <c:out value="${specs.name}"/>
                                                    </option>
                                                </c:if>
                                                <c:if test="${spec != specs.name}">
                                                    <option name="spec" value="<c:out value="${specs.name}"/>">
                                                        <c:out value="${specs.name}"/>
                                                    </option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div>
                                    <label class="required">Grade:</label>
                                    <input type="text" name="grade" maxlength="80" value="${grade}"/>
                                </div>
                            </div>    
                        </fieldset>
                        <div class="submit-row">
                            <input type="submit" value="Save" class="default" name="_save" />
                            <input type="submit" value="Discard changes" class="default" name="_discard" />
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
