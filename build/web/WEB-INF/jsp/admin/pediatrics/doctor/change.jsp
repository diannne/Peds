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
        <title>Select doctors to change | Edelweiss Pediatrics admin</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/base.css" var="mainCss" />
        <link href="${mainCss}" rel="stylesheet" />
        <spring:url value="/resources/css/changelists.css" var="changeCss" />
        <link href="${changeCss}" rel="stylesheet" />
    </head>
    <body class="change-list">
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
                <spring:url value="/admin/peds/" var="peds" htmlEscape="true"/>
                <a href="${peds}">Pediatrics</a>
                &rsaquo; Doctors
            </div>
            <!-- Content -->
            <div id="content" class="flex">
                <h1>Select doctor to change</h1>
                <div id="content-main">
                    <ul class="object-tools">
                        <li>
                            <spring:url value="/admin/peds/doctor/add" var="add_dr" htmlEscape="true"/>
                            <a href="${add_dr}" class="addlink">Add doctor</a>
                        </li>
                    </ul>

                    <div class="module" id="changelist">
                        <div id="toolbar">
                            <form id="changelist-search" action="search" method="post">
                                <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>
                                <input type="hidden"  name="columns"   value="firstName|lastName"/>
                                <input type="hidden"  name="table"   value="pediatricians"/>
                                <div>
                                    <input type="text" size="40" name="q_text" value="${q_text}"/>
                                    <input type="submit" value="Search" />
                                </div>
                            </form>
                        </div>


                        <form id="changelist-form" action="runaction" method="post">
                            <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>
                            <c:if test="${fn:length(list) gt 0}">
                                <div class="actions">
                                    <label>Action: 
                                        <select name="action">
                                            <option value="" selected="none_selected">None</option>
                                            <option value="delete_selected">Delete selected doctors</option>
                                        </select>
                                    </label>
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
                                        <div class="text"><a href="?o=3.1">Grade</a></div>
                                        <div class="clear"></div>
                                        </th>
                                        <th scope="col"  class="sortable">
                                        <div class="text"><a href="?o=3.1">Specialty</a></div>
                                        <div class="clear"></div>
                                        </th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${list}" var="drs">
                                                <tr class="row1">
                                                    <td class="action-checkbox">
                                                        <input type="checkbox" name="_selected_action" 
                                                               value="<c:out value="${drs.id}"/>" class="action-select"/>
                                                    </td>
                                                    <th>
                                                        <spring:url value="/admin/peds/doctor/change/${drs.id}" var="index" htmlEscape="true"/>
                                                        <a href="${index}" >
                                                            <c:out value="${drs.firstName}"/> <c:out value="${drs.lastName}"/>
                                                        </a>
                                                    </th>
                                                    <td><c:out value="${drs.grade}"/></td>
                                                    <td><c:out value="${drs.specialties.name}"/></td>                                                    
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                            <p class="paginator">
                                ${fn:length(list)} doctors
                            </p>
                            <input type="hidden"  name="table"   value="pediatricians"/>
                            <input type="hidden"  name="column"   value="id"/>
                        </form>
                    </div>
                </div>
                <br class="clear" />
            </div>
            <div id="footer"></div>
        </div>
    </body>
</html>
