<%-- 
    Document   : kidform
    Created on : Jan 6, 2016, 8:10:52 PM
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
        <title>Child Form | Edelweiss Pediatrics patient management</title>
        <spring:url value="/resources/images/favicon.ico" var="favicon" />
        <link rel="shortcut icon" href="${favicon}" />
        <spring:url value="/resources/css/base.css" var="baseCss" />
        <link href="${baseCss}" rel="stylesheet" />
        <spring:url value="/resources/css/changelists.css" var="changeCss" />
        <link href="${changeCss}" rel="stylesheet" />
        <spring:url value="/resources/css/forms.css" var="formsCss" />
        <link href="${formsCss}" rel="stylesheet" />

        <spring:url value="/resources/css/jquery.datetimepicker.css" var="jqCss" />
        <link href="${jqCss}" rel="stylesheet" />
        <spring:url value="/resources/js/jquery.js" var="jqJS" />
        <spring:url value="/resources/js/jquery.datetimepicker.full.min.js" var="jqJS2" />

        <script src="${jqJS}"></script>
        <script src="${jqJS2}"></script>
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
                <spring:url value="/secretary" var="home" htmlEscape="true"/>
                <a href="${home}">Home</a>
                <spring:url value="/secret/patient/${pid}/" var="par" htmlEscape="true"/>
                &rsaquo; <a href="${par}">${fp_name} ${lp_name}</a>
                &rsaquo;  ${f_name} ${l_name}
            </div> 


            <!-- Content -->

            <div id="content" class="colM">
                <h1>Viewing ${f_name} ${l_name}</h1>
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
                                        <input id="id_last_name" readonly="readonly" type="text" value="${l_name}" class="vTextField" name="l_name" maxlength="30" />
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div>
                                        <label>Birth Date:</label>
                                        <input id="datetimepicker" name="datetimepicker" type="text" value="${b_date}">
                                    </div>
                                </div>
                                <script type="text/javascript">
                                    $('#datetimepicker').datetimepicker({timepicker: false, format: 'd/m/Y'});
                                </script>
                            </fieldset>

                        </div>
                        <div class="submit-row">
                            <input type="submit" value="Save" class="default" name="_save" />
                            <input type="submit" value="Discard Changes" class="default" name="_discard" />
                        </div>
                    </form>
                </div>
            </div>
                                    <br class="clear" />
                                    <br class="clear" />
                                     <br class="clear" />
                                      <br class="clear" />
            <div id="content" class="flex">
                <div id="content-main">
                    <ul class="object-tools">
                        <li>
                            <spring:url value="./visit/add" var="add_visit" htmlEscape="true"/>
                            <a href="${add_visit}" class="addlink">Add clinical visit</a>
                        </li>
                    </ul>

                    <div class="module" id="changelist">
                        <fieldset class="module aligned ">
                            <h2>Clinical Visits</h2>
                            <spring:url value="./visit/delete" var="del_visit" htmlEscape="true"/>
                            <form id="changelist-form" action="${del_visit}" method="post">
                                <input type="hidden"  name="${_csrf.parameterName}"   value="${_csrf.token}"/>
                                <c:if test="${fn:length(visits) gt 0}">
                                    <div class="actions">
                                        <label>Action:</label>
                                        <select name="action">
                                            <option value="" selected="selected">None</option>
                                            <option value="delete_selected">Delete selected clinical visits</option>
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
                                            <div class="clear">

                                            </div>
                                            </th>

                                            <th scope="col"  class="sortable">
                                            <div class="text"><a href="?o=2.1">Date</a></div>
                                            <div class="clear"></div>
                                            </th>

                                            <th scope="col"  class="sortable sorted ascending">
                                            <div class="sortoptions">
                                                <a class="sortremove" href="?o=" title="Remove from sorting"></a>
                                                <a href="?o=-1" class="toggle ascending" title="Toggle sorting"></a>
                                            </div>
                                            <div class="text"><a href="?o=-1">Specialty</a></div>
                                            <div class="clear"></div>
                                            </th>

                                            <th scope="col"  class="sortable">
                                            <div class="text">Pediatrician</div>
                                            <div class="clear"></div>
                                            </th>

                                            <th scope="col">
                                            <div class="text">Reason</div>
                                            <div class="clear"></div>
                                            </th>

                                            <th scope="col">
                                            <div class="text">Prescription</div>
                                            <div class="clear"></div>
                                            </th>

                                            <th scope="col">
                                            <div class="text">Comments</div>
                                            <div class="clear"></div>
                                            </th>

                                            </tr>
                                            </thead>

                                            <tbody>
                                                <c:forEach items="${visits}" var="visits">
                                                    <tr class="row1">
                                                        <td class="action-checkbox">
                                                            <input type="checkbox" name="_selected_action" 
                                                                   value="<c:out value="${visits.id}"/>" class="action-select"/>
                                                        </td>
                                                        <th>
                                                            <spring:url value="visit/${visits.id}" var="vis_id"/>
                                                            <a href="${vis_id}" >
                                                                <c:out value="${visits.date}"/>
                                                            </a>
                                                        </th>
                                                        <td><c:out value="${visits.spec}"/></td>
                                                        <td><c:out value="${visits.ped}"/></td>
                                                        <td><c:out value="${visits.reason}"/></td>
                                                        <td><c:out value="${visits.prescription}"/></td>
                                                        <td><c:out value="${visits.comments}"/></td>                                                                                                 
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                                <p class="paginator">
                                    ${fn:length(visits)} clinical visits
                                </p>
                            </form>
                        </fieldset>
                    </div>
                </div>
                <br class="clear" />
            </div>
            <div id="footer"></div>
        </div>
    </body>
</html>

