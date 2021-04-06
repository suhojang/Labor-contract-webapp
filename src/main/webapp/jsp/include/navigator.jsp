<%@ page contentType="text/html;charset=UTF-8" errorPage = "/jsp/common/error/error.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ page import="kcert.web.vo.ClientVO"%>
<!DOCTYPE html>
<html>
<%
try{
	ClientVO clientVO	= (ClientVO)session.getAttribute("clientVO");
%>
<c:if test="${menuCode != null && menuCode != '9999'}">
	<%
		if(clientVO==null || clientVO.getID()==null){
			clientVO	= new ClientVO();
			out.println("<script>try{document.location.href='/LGN/CLA_LGN_LOGIN.do';}catch(e){}</script>");
		}
	%>
</c:if>
<script type="text/javascript">
function alert_show(msg){
	$("#modal_msg").html(msg);
	
    $("#myModal").modal({
    	  keyboard : false
    	 ,backdrop : 'static'
    });
}
function alert_hide(){
    $("#myModal").modal('hide');
}
</script>
<body>
<!-- Navbar -->
<nav class="navbar navbar-default" role="navigation">
	<div class="container-fluid">
    	<div class="navbar-header">
    		<button type="button" id="toggleBtn" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
    		</button>
    		<a class="navbar-brand" style="font-weight: bold;font-family: Gulim;" href="/CLA_LGN_MAIN.do"><i class="material-icons">home</i> 전자근로계약 시스템</a>
    	</div>
    	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
    		<ul class="nav navbar-nav">
        		<li class="dropdown">
        			<a href="javascript:void(0);" class="dropdown-toggle" style="font-size: 14px;font-weight: bold;" data-toggle="dropdown"><i class="material-icons">picture_as_pdf</i> 전자계약서<b class="caret"></b></a>
        			<ul class="dropdown-menu">
					  <li><a href="/EDC/CLA_EDC_REG.do"><i class="material-icons">event_note</i> 작성하기</a></li>
        			</ul>
        		</li>
        		
        		<li class="dropdown">
        			<a href="javascript:void(0);" class="dropdown-toggle" style="font-size: 14px;font-weight: bold;" data-toggle="dropdown"><i class="material-icons">search</i> 계약문서 관리<b class="caret"></b></a>
        			<ul class="dropdown-menu">
					  <li><a href="/EDC/CLA_EDC_SEL01.do"><i class="material-icons">search</i> 작성한 문서</a></li>
					  <li><a href="/EDC/CLA_EDC_SEL02.do"><i class="material-icons">search</i> 전자서명한 문서</a></li>
					  <li><a href="/EDC/CLA_EDC_SEL03.do"><i class="material-icons">search</i> 전송한 문서</a></li>
					  <li><a href="/EDC/CLA_EDC_SEL04.do"><i class="material-icons">search</i> 반려된 문서</a></li>
					  <li><a href="/EDC/CLA_EDC_SEL05.do"><i class="material-icons">search</i> 계약성립 문서</a></li>
        			</ul>
        		</li>
        		
        		<li class="dropdown">
        			<a href="javascript:void(0);" class="dropdown-toggle" style="font-size: 14px;font-weight: bold;" data-toggle="dropdown"><i class="material-icons">search</i> 재계약 관리<b class="caret"></b></a>
        			<ul class="dropdown-menu">
					  <li><a href="/EDC/CLA_EDC_SEL06.do"><i class="material-icons">search</i> 근로계약 만료대상(30일전)</a></li>
					  <li><a href="/EDC/CLA_EDC_SEL07.do"><i class="material-icons">search</i> 근로계약 만료자</a></li>
        			</ul>
        		</li>
        		
        		<%if(clientVO==null || clientVO.getID()==null){%>
		       		<li><a href="/LGN/CLA_LGN_LOGIN.do" style="font-size: 14px;font-weight: bold;"><i class="material-icons">person</i> 로그인</a></li>
		       		<li><a href="/LGN/CLA_LGN_SIGNUP.do" style="font-size: 14px;font-weight: bold;"><i class="material-icons">person_add</i> 회원가입</a></li>
        		<%}else{%>
        			<!-- <li><a href="/MPG/CLA_MPG_INFO.do" style="font-size: 14px;font-weight: bold;"><i class="material-icons">person_pin</i> 정보수정</a></li> -->
		       		<li><a href="/LGN/CLA_LGN_LGNOUT.do" style="font-size: 14px;font-weight: bold;"><i class="material-icons">person_outline</i> 로그아웃</a></li>
        		<%}%>
    		</ul>
    	</div>
	</div>
</nav>
<!-- End Navbar -->

<!-- Modal Core -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel"><b>알림</b></h4>
      </div>
      <div class="modal-body" id="modal_msg"></div>
      <div class="modal-footer">
        <button type="button" class="btn btn-info btn-simple" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>
<%}catch(Exception e){e.printStackTrace();}%>