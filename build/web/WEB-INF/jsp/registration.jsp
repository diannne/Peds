<%-- 
    Document   : registration
    Created on : Jan 1, 2016, 7:51:48 PM
    Author     : Diana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration | Edelweiss Pediatrics </title> 
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/base.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/forms.css" var="formsCss" />
        <link href="${formsCss}" rel="stylesheet" />
        <spring:url value="/resources/css/register.css" var="registerCss" />
        <link href="${registerCss}" rel="stylesheet" />
    </head>

    <body class="login">

        <!-- Container -->
        <div id="container">


            <!-- Header -->
            <div id="header">
                <div id="branding">
                    <h1 id="site-name">Edelweiss Pediatrics</h1>
                </div>
                <div id="user-tools">
                    <sec:authorize access="isAuthenticated()">
                        Welcome, <strong><sec:authentication property="principal.username" /></strong>!
                        <br class="clear" />
                        <spring:url value="/logout" var="url" htmlEscape="true"/>
                        <spring:url value="/change_pass/" var="pass" htmlEscape="true"/>

                        <a href="${pass}">Change password |</a>
                        <a href="${url}">Log out</a>
                    </sec:authorize>
                    <sec:authorize access="isAnonymous()">
                        Welcome, <strong>guest</strong>!
                        <br class="clear" />
                        <spring:url value="/login" var="url" htmlEscape="true"/>
                        <spring:url value="/register" var="pass" htmlEscape="true"/>

                        <a href="${url}">Log In |</a>
                        <a href="${pass}">Register</a>
                    </sec:authorize>

                </div>
            </div>
            
                <div id="content" >
<sec:authorize access="isAuthenticated()">
                    <div class="message_box">
                        <div class="alert">
                            <h2>It looks like you&#x27;re already logged in!</h2>
                            <p>Only continue if you want to create a new account.</p>
                        </div>
                    </div>
                    </sec:authorize>

                    <h1><strong>Register Now</strong> (it's free)</h1>
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

                    <form:form action="register"  modelAttribute="parent" commandName="parent" method="post">
                        <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>

                        <div>
                            <fieldset class="module aligned ">

                                <div class="form-row">
                                    <div> 
                                        <label for="first_name">First Name:</label>
                                        <form:input path="firstName" tabindex="1" required="required" />
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div> 
                                        <label for="last_name">Last Name:</label>
                                        <form:input path="lastName" tabindex="2" required="required"/>
                                    </div>
                                </div>
                            </fieldset>
                            <fieldset class="module aligned ">

                                <div class="form-row">
                                    <div> 
                                        <label for="email">Email:</label>
                                        <form:input path="email" tabindex="3" required="required"/>
                                        <form:errors path="email" cssClass="errors"/>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div> 
                                        <label for="telephone">Telephone:</label>
                                        <form:input path="telephone" tabindex="4" required="required"/>
                                        <form:errors path="telephone" cssClass="errors"/>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div> 
                                        <label for="address">Address</label>
                                        <form:input path="address" tabindex="5" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div> 
                                        <label for="city">City</label>
                                        <form:input path="city" tabindex="6" />
                                    </div>
                                </div>
                            </fieldset>
                            <fieldset class="module aligned ">

                                <div class="form-row">
                                    <div> 
                                        <label for="password">Create a password:</label>
                                        <form:input path="password" type="password" tabindex="7" required="required"/>
                                        <form:errors path="password" cssClass="errors"/>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div> 
                                        <label for="password_conf">Confirm password:</label>
                                        <input type="password" name="pass_conf" tabindex="8" required="required"/>

                                    </div>
                                </div>
                                <c:if test="${not empty captchaimage}">
                                    <div class="form-row">
                                        <div> 
                                            Type what you see below:
                                            </br>
                                            <img src="data:image/png;base64,${captchaimage}"/>
                                            </br>
                                            <input type='text' name='j_captcha' />
                                        </div>
                                    </div>
                                </c:if>
                                <div class="submit-row">
                                    <input type="submit" value="Submit">
                                </div>
                            </fieldset> 
                        </div>
                    </form:form>
                </div>
            </div>
    </body>
</html>
