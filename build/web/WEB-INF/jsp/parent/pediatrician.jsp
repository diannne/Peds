<%-- 
    Document   : change
    Created on : Jan 3, 2016, 5:22:35 PM
    Author     : Diana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Pediatrician| Edelweiss Pediatrics</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/main.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/forms.css" var="formsCss" />
        <link href="${formsCss}" rel="stylesheet" />
        <spring:url value="/resources/css/base2.css" var="baseCss" />
        <link href="${baseCss}" rel="stylesheet" />
    </head>

    <body>
        <div id="container">
            <div id="title" class="clearfix">
                <spring:url value="home/" htmlEscape="true" var="logo"/>
                <a href="${home}">
                    <spring:url value="/resources/images/logo.jpg" htmlEscape="true" var="logo"/>
                    <img src="${logo}" height="48"/>
                </a>

                <h2 id="site-name">Edelweiss Pediatrics</h2>

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

            <div id="wrapper">
                <div id="nav">
                </div>
                <div id="workarea" class="clearfix">

                    <div id="presentation" class="clearfix">
                        <sec:authorize access="isAuthenticated()">

                            <spring:url value="medical-history/" var="hist_var" htmlEscape="true"/>
                            <a href="${hist_var}">
                                <div id="kids" class="menubox">
                                    <h2>Your kids history</h2>
                                    <p>Track medical history of your kids</p>
                                </div>
                            </a>
                        </sec:authorize>
                        <spring:url value="/specialties/" var="spec_var" htmlEscape="true"/>
                        <a href="${spec_var}">
                            <div id="spec" class="menubox">
                                <h2>Specialties</h2>
                                <p>Check out specialties at our clinic</p>
                            </div>
                        </a>
                        <spring:url value="/pediatricians/" var="peds_var" htmlEscape="true"/>
                        <a href="${peds_var}">
                            <div id="peds" class="menubox">
                                <h2>Pediatricians</h2>
                                <p>View pediatricians and their specialties</p>
                            </div>
                        </a>
                        <spring:url value="/contact/" var="contact_var" htmlEscape="true"/>
                        <a href="${contact_var}">
                            <div id="visit" class="menubox">
                                <h2>Make a visit</h2>
                                <p>See contact info and set up a consultation</p>
                            </div>
                        </a>
                        <br />
                        <div id="reports"></div>
                    </div>
                </div>
                <br class="clear" />
                <br class="clear" />
                <div id="workarea" class="clearfix">
                    <fieldset class="module aligned ">
                                <h2>Pediatrician - ${ped.firstName} ${ped.lastName}</h2>
                                <div class="form-row">
                                    <div>                  
                                        <label for="id_first_name">First name:</label>
                                        <input id="id_first_name" type="text" readonly="on" value="${ped.firstName}" class="vTextField" name="f_name" maxlength="30" />
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div>
                                        <label for="id_last_name">Last name:</label>
                                        <input id="id_last_name" type="text" value="${ped.lastName}" readonly="on" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label>Grade:</label>
                                        <input value="${ped.grade}" readonly="on" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label>Specialty:</label>
                                        <input name="addr" value="${ped.specialties.name}" readonly="on" />
                                    </div>
                                </div>                      
                            </fieldset>
                </div>
            </div>
            <br class="clear" />
            <div id="footer"></div>
        </div>
    </body>
</html>