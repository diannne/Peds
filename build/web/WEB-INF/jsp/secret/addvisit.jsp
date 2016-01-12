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
        <title>Add visit | Edelweiss Pediatrics Patient Management</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/base.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/forms.css" var="formsCss" />
        <link href="${formsCss}" rel="stylesheet" />
        <spring:url value="/resources/css/jquery.datetimepicker.css" var="jqCss" />
        <link href="${jqCss}" rel="stylesheet" />
        <spring:url value="/resources/js/jquery.js" var="jqJS" />
        <spring:url value="/resources/js/jquery.datetimepicker.full.min.js" var="jqJS2" />

        <script src="${jqJS}"></script>
        <script src="${jqJS2}"></script>
    </head>

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
                &rsaquo;  Add clinical visit
            </div>  

            <div id="content" class="colM">
                <h1>Add clinical visit to kid</h1>
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
                                <h2>Visit information</h2>
                                <div class="form-row">
                                    <div>                  
                                        <label>Kid's Name:</label>
                                        <input readonly="readonly" type="text" value="${fp_name} ${lp_name}" required="required"  class="vTextField" name="f_name" maxlength="30" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label>Specialty:</label>
                                        <div class="actions" >
                                            <select name="action" id="action" onchange="this.form.submit();">
                                                <c:forEach items="${spec_list}" var="specs">
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
                                        <label>Pediatrician:</label>
                                        <select name="ped_action" id="ped_action">
                                            <c:forEach items="${peds_list}" var="peds">
                                                <c:if test="${doc eq peds.id}">
                                                    <option selected="selected" name="<c:out value="${peds.id}"/>" value="<c:out value="${peds.id}"/>">
                                                        <c:out value="${peds.firstName} ${peds.lastName}"/>
                                                    </option>
                                                </c:if>
                                                <c:if test="${doc != peds.id}">
                                                    <option name="<c:out value="${peds.id}"/>" value="<c:out value="${peds.id}"/>">
                                                        <c:out value="${peds.firstName} ${peds.lastName}"/>
                                                    </option>
                                                </c:if>
                                            </c:forEach>
                                        </select>

                                    </div>
                                </div>


                                <div class="form-row">
                                    <div>
                                        <label>Date:</label>
                                        <input id="datetimepicker1" name="datetimepicker1" type="text" >
                                    </div>
                                </div>
                                <script type="text/javascript">
                                    $('#datetimepicker1').datetimepicker({timepicker: false, format: 'd/m/Y'});
                                </script>

                                <div class="form-row">
                                    <div>
                                        <label>Start time:</label>
                                        <input id="datetimepicker2" name="datetimepicker2" type="text" >                                        
                                    </div>
                                </div>
                                <script type="text/javascript">
                                    jQuery('#datetimepicker2').datetimepicker({
                                        datepicker: false,
                                        format: 'H:i'
                                    });
                                </script>

                                <div class="form-row">
                                    <div>
                                        <label>End time:</label>
                                        <input id="datetimepicker3" name="datetimepicker3" type="text" >
                                    </div>
                                </div>
                                <script type="text/javascript">
                                    jQuery('#datetimepicker3').datetimepicker({
                                        datepicker: false,
                                        format: 'H:i'
                                    });
                                </script>
                            </fieldset>
                            <fieldset class="module aligned ">
                                <h2>Visit Concerns</h2>
                                <div class="form-row">
                                    <div>                  
                                        <label>Reason:</label>
                                        <input type="text" value="${reason}" class="vTextField" name="reason" maxlength="255" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label>Prescription:</label>
                                        <input type="text" value="${pres}" class="vTextField" name="spec" maxlength="255" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label>Comments:</label>
                                        <input type="text" value="${comm}" class="vTextField" name="comm" maxlength="255" />
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
            </div>
        </div>
    </body>
</html>
