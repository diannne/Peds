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
        <title>Add kid | Edelweiss Pediatrics</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/main.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/forms.css" var="formsCss" />
        <link href="${formsCss}" rel="stylesheet" />
        <spring:url value="/resources/css/changelists.css" var="changeCss" />
        <link href="${changeCss}" rel="stylesheet" />
        <spring:url value="/resources/css/base2.css" var="baseCss" />
        <link href="${baseCss}" rel="stylesheet" />

        <spring:url value="/resources/css/jquery.datetimepicker.css" var="jqCss" />
        <link href="${jqCss}" rel="stylesheet" />
        <spring:url value="/resources/js/jquery.js" var="jqJS" />
        <spring:url value="/resources/js/jquery.datetimepicker.full.min.js" var="jqJS2" />

        <script src="${jqJS}"></script>
        <script src="${jqJS2}"></script>
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

                            <spring:url value="/medical-history/" var="hist_var" htmlEscape="true"/>
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
                    <h2>Complete kid profile</h2>
                    <div id="content-main">
                        <form action="" method="post" id="user_form">
                            <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>

                            <div>
                                <fieldset class="module aligned wide">
                                    <div class="form-row field-username">
                                        <div>
                                            <label class="required">First Name:</label>
                                            <input type="text" name="f_name" maxlength="30"/>
                                        </div>
                                    </div>
                                    <div class="form-row field-username">
                                        <div>
                                            <label class="required">Last Name:</label>
                                            <input type="text" readonly="on" name="l_name" maxlength="30" value="${parent.lastName}"/>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div>
                                            <label>Birth Date:</label>
                                            <input id="datetimepicker" name="datetimepicker" type="text">
                                        </div>
                                    </div>
                                    <script type="text/javascript">
                                        $('#datetimepicker').datetimepicker({timepicker: false, format: 'd/m/Y'});
                                    </script>
                                </fieldset>
                                <div class="submit-row">
                                    <input type="submit" value="Save" class="default" name="_save" />
                                    <input type="submit" value="Discard changes" class="default" name="_discard" />
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <br class="clear" />
            </div>
            <br class="clear" />
            <div id="footer"></div>
        </div>
    </body>
</html>
