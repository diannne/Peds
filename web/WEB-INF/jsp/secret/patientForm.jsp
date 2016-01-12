<%-- 
    Document   : patientForm
    Created on : Jan 5, 2016, 10:17:47 PM
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
        <title>Patient Form | Edelweiss Pediatrics Patient Management</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/base.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/forms.css" var="formsCss" />
        <link href="${formsCss}" rel="stylesheet" />
        <spring:url value="/resources/css/changelists.css" var="changeCss" />
        <link href="${changeCss}" rel="stylesheet" />
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
                &rsaquo; ${f_name} ${l_name}
            </div>  


            <div id="content" class="colM">

                <h1>Change patient</h1>
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
                                        <input id="id_last_name" type="text" value="${l_name}" class="vTextField" name="l_name" maxlength="30" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label for="id_email">E-mail address:</label>
                                        <input name="email" value="${email}" class="vTextField" maxlength="45" type="text" id="id_email" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label>Telephone:</label>
                                        <input name="tele" value="${tele}" class="vTextField" maxlength="75" type="text" id="id_email" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label>Address:</label>
                                        <input name="addr" value="${addr}" class="vTextField" maxlength="255" type="text" id="id_email" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div>
                                        <label>City:</label>
                                        <input name="city" value="${city}" class="vTextField" maxlength="75" type="text" id="id_email" />
                                    </div>
                                </div>
                            </fieldset>

                        </div>
                        <div class="submit-row">
                            <input type="submit" value="Save" class="default" name="_save" />
                        </div>
                    </form>
                </div>   
                                    <br class="clear" />
                                     <br class="clear" />
                                      <br class="clear" />
            </div>
            <div id="content" class="flex">
                <div id="content-main">
                    <ul class="object-tools">
                        <li>
                            <spring:url value="/secret/patient/${id}/kid/add" var="add_k" htmlEscape="true"/>
                            <a href="${add_k}" class="historylink">Add children</a></li>   
                    </ul>
                    <div class="module" id="changelist">
                        <fieldset class="module aligned ">
                            <h2>Children</h2>

                            <spring:url value="/secret/patient/${id}/kid/runaction" var="add_r" htmlEscape="true"/> 
                            <form id="changelist-form" action="${add_r}" method="post">
                                <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>                             

                                <c:if test="${fn:length(kids) gt 0}">
                                    <div class="actions">
                                        <label>Action:</label>
                                        <select name="action">
                                            <option value="" selected="selected">None</option>
                                            <option value="delete_selected">Delete selected children</option>
                                        </select>

                                        <input type="hidden" class="select-across" name="select_across" />
                                        <button type="submit" class="button" title="Run the selected action" name="index">Go</button>
                                    </div>
                                    <div class="results">
                                        <table id="result_list">
                                            <thead>
                                                <tr>
                                                    <th scope="col"  class="action-checkbox-column">
                                            <div class="text">
                                                <span>
                                                    <input type="checkbox" id="action-toggle" />
                                                </span>
                                            </div>
                                            <div class="clear"></div>
                                            </th>
                                            <th scope="col"  class="sortable sorted ascending">
                                            <div class="sortoptions">
                                                <a class="sortremove" href="?o=" title="Remove from sorting"></a>

                                                <a href="?o=-1" class="toggle ascending" title="Toggle sorting"></a>
                                            </div>


                                            <div class="text"><a href="?o=-1">Name</a></div>
                                            <div class="clear"></div>
                                            </th>
                                            <th scope="col"  class="sortable">
                                            <div class="text"><a href="?o=2.1">Birth Date</a></div>
                                            <div class="clear"></div>
                                            </th>

                                            </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${kids}" var="admins">
                                                    <tr class="row1">
                                                        <td class="action-checkbox">
                                                            <input type="checkbox" name="_selected_action" 
                                                                   value="<c:out value="${admins.id}"/>" class="action-select"/>
                                                        </td>
                                                        <th>
                                                            <spring:url value="/secret/patient/${id}/kid/${admins.id}/" var="see_k" htmlEscape="true"/>
                                                            <a href="${see_k}" >                                                
                                                                <c:out value="${admins.name}"/> <c:out value="${l_name}"/>
                                                            </a>
                                                        </th>
                                                        <td><c:out value="${admins.birthDate}"/></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                                <p class="paginator">
                                    ${fn:length(kids)} children
                                </p>
                            </form>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
