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
        <title>Select secretaries to change | Edelweiss Pediatrics admin</title>
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
                <spring:url value="/admin/users" var="users" htmlEscape="true"/>
                <a href="${users}">Users</a>
                &rsaquo; Secretaries
            </div>
            <!-- Content -->
            <div id="content" class="flex">
                <h1>Select secretary to change</h1>
                <div id="content-main">
                    <ul class="object-tools">
                        <li>
                            <spring:url value="/admin/users/secretary/add" var="add_sec" htmlEscape="true"/>
                            <a href="${add_sec}" class="addlink">Add secretary</a>
                        </li>
                    </ul>

                    <div class="module" id="changelist">
                        <div id="toolbar">
                            <form id="changelist-search" action="../../search" method="post">
                                <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>
                                <input type="hidden"  name="class"   value="Users"/>
                                <input type="hidden"  name="role"   value="ROLE_SECRET"/>
                                <div>
                                    <input type="text" size="40" name="q_text" value="" id="searchbar" />
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
                                            <option value="" selected="selected">None</option>
                                            <option value="delete_selected">Delete selected secretaries</option>
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


                                        <div class="text"><a href="?o=-1">Username</a></div>
                                        <div class="clear"></div>
                                        </th>
                                        <th scope="col"  class="sortable">
                                        <div class="text"><a href="?o=2.1">Enabled</a></div>
                                        <div class="clear"></div>
                                        </th>
                                        <th scope="col"  class="sortable">
                                        <div class="text"><a href="?o=3.1">Role</a></div>
                                        <div class="clear"></div>
                                        </th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${list}" var="secr">
                                                <tr class="row1">
                                                    <td class="action-checkbox">
                                                        <input type="checkbox" name="_selected_action" 
                                                               value="<c:out value="${secr.username}"/>" class="action-select"/>
                                                    </td>
                                                    <th>
                                                        <a href="${secr.username}/" ><c:out value="${secr.username}"/></a>
                                                    </th>
                                                    <td><c:out value="${secr.enabled}"/></td>
                                                    <td>secretary</td>                                                
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                            <p class="paginator">
                                ${fn:length(list)} secretaries
                            </p>
                        </form>
                    </div>
                </div>
                <br class="clear" />
            </div>
            <div id="footer"></div>
        </div>
    </body>
</html>
