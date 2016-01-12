<%-- 
    Document   : patientForm
    Created on : Jan 5, 2016, 10:17:47 PM
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
        <title>Add kid | Edelweiss Pediatrics Patient Management</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/base.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/forms.css" var="formsCss" />
        <link href="${formsCss}" rel="stylesheet" />
    </head>
    <body>
    <body class="auth-user change-form">

        <!-- Container -->
        <div id="container">


            <!-- Header -->
            <div id="header">
                <div id="branding">
                    <h1 id="site-name">Edelweiss Pediatrics</h1>
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
                <spring:url value="/secretary" var="home" htmlEscape="true"/>
                <a href="${home}">Home</a>
                <spring:url value="/secret/patient/${id}/" var="par" htmlEscape="true"/>
                &rsaquo; <a href="${par}">${fp_name} ${lp_name}</a>
                &rsaquo;  Add kid
            </div>  


            <div id="content" class="colM">

                <h1>Add kid to parent</h1>
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
                            <fieldset class="module aligned ">
                                <h2>Personal information</h2>
                                <div class="form-row">
                                    <div>                  
                                        <label for="id_first_name">First name:</label>
                                        <input id="id_first_name" type="text" value="${f_name}" class="vTextField" name="f_name" maxlength="30" />
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div>
                                        <label for="id_last_name">Last name:</label>
                                        <input id="id_last_name" type="text" value="${lp_name}" class="vTextField" name="l_name" maxlength="30" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label for="id_bdate" class="required">Birth Date:</label>
                                        <input name="b_date" value="${b_date}" class="vTextField" maxlength="45" type="text" id="id_email" />
                                    </div>
                                    
                                </div>
                        </div>
                        </fieldset>
                                    <fieldset class="module aligned ">
                            <h2>Clinic Visits</h2>
                        </fieldset>
                     <div class="submit-row">
                            <input type="submit" value="Save" class="default" name="_save" />
                        </div>
                </div>
            </div>
        </div>
    </body>
</html>
