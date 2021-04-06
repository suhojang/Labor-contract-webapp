<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%!
	public void replaceTag(String menu){
		if ( menu != null  ) {
			menu = menu.replaceAll("<","&lt;");
			menu = menu.replaceAll(">","&gt;");
		}else {
			  return;
		}
	}
%>
<%
	String menu01 = request.getParameter("menu01");
	//String menu02 = request.getParameter("menu02");
	replaceTag(menu01);
	//replaceTag(menu02);
%>
<c:if test="${loginVO == null}">
	<jsp:forward page="/admin/"/>
</c:if>

<div class="navbar navbar-fixed-top navbar-inverse" role="navigation">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="/admin/userList.do"><span class="glyphicon glyphicon-home"></span> 스마트 실손청구</a>
    </div>
    <div class="collapse navbar-collapse">
      <ul class="nav navbar-nav">
        <li class="<%=menu01 %>">
       	  <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-phone"></span> 사용자<span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu">
            <li><a href="/admin/userList.do">고객</a></li>
          </ul>
        </li>
        <%-- 
        <li class="<%=menu02 %>">
       	  <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-phone"></span> 앱로그<span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu">
            <li><a href="/admin/userList.do">고객</a></li>
          </ul>
        </li> --%>
      </ul>
		<c:if test="${loginVO != null}">
	      <ul class="nav navbar-nav navbar-right">
	      	<li><a href="/admin/logout.do"><span class="glyphicon glyphicon-eye-open"></span> 로그아웃</a></li>
	      </ul>
		</c:if>
    </div>
  </div>
</div>
