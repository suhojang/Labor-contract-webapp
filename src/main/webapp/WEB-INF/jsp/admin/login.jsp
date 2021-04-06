<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<META NAME=”ROBOTS” CONTENT=”NOINDEX,NOFOLLOW”>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta http-equiv="expires" content="-1" >
    

    <title>스마트 실손청구</title>
    <link href="/bootstrap/css/bootstrap.css" rel="stylesheet">
    <link href="/bootstrap/css/offcanvas.css" rel="stylesheet">
    <link href="/bootstrap/css/bootstrap-select.css" rel="stylesheet">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
    
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<script type="text/javaScript" language="javascript">
function actionLogin() {
    if (document.loginForm.admin_id.value =="") {
        alert("아이디를 입력하세요");
    } else if (document.loginForm.admin_pwd.value =="") {
        alert("비밀번호를 입력하세요");
    } else {
        document.loginForm.submit();
    }
}


function setCookie (name, value, expires) {
    document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
}

function getCookie(Name) {
    var search = Name + "=";
    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
        offset = document.cookie.indexOf(search);
        if (offset != -1) { // 쿠키가 존재하면
            offset += search.length;
            // set index of beginning of value
            end = document.cookie.indexOf(";", offset);
            // 쿠키 값의 마지막 위치 인덱스 번호 설정
            if (end == -1)
                end = document.cookie.length;
            return unescape(document.cookie.substring(offset, end));
        }
    }
    return "";
}

function saveid(form) {
    var expdate = new Date();
    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
    if (form.checkId.checked)
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
    else
        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
    setCookie("saveid", form.id.value, expdate);
}

function getid(form) {
    form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
}

function fnInit() {
    var message = document.loginForm.message.value;
    if (message != "") {
        alert(message);
    }
    getid(document.loginForm);
}
</script>
</head>
<body onLoad="fnInit();">
<div class="navbar navbar-fixed-top navbar-inverse" role="navigation">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#"><span class="glyphicon glyphicon-home"></span> 스마트 실손청구</a>
    </div>
    <div class="collapse navbar-collapse">
      <ul class="nav navbar-nav">
      </ul>
    </div>
  </div>
</div>
<div class="container">
<div class="row row-offcanvas row-offcanvas-right">
<div class="col-xs-12 col-sm-12">
<form class="form-horizontal" role="form" name="loginForm" action ="/admin/login.do" method="post">
<input type="hidden" name="message" value="${message}">
<div class="jumbotron">
  <p>
  <div class="form-group">
    <label for="inputEmail3" class="col-sm-1 control-label">아이디</label>
    <div class="col-sm-3">
      <input type="text" class="form-control" id="admin_id" name="admin_id" placeholder="아이디">
    </div>
  </div>
  <div class="form-group">
    <label for="inputPassword3" class="col-sm-1 control-label">비밀번호</label>
    <div class="col-sm-3">
      <input type="password" name="admin_pwd" id="admin_pwd" class="form-control" placeholder="비밀번호" style="ime-mode: disabled;" maxlength="50"  onKeyDown="javascript:if (event.keyCode == 13) { actionLogin(); }">
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-1 col-sm-10">
      <div class="checkbox">
        <label>
          <input type="checkbox" name="checkId" class="check2" onClick="javascript:saveid(document.loginForm);" id="checkId"> 아이디 저장
        </label>
      </div>
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-1 col-sm-10">
      <button type="submit" class="btn btn-default" onClick="actionLogin();">로그인</button>
    </div>
  </div>
  </p>
</div>
</form>
</div>
</div>
</div>
<script src="/js/jquery-1.9.1.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>
<script src="/bootstrap/js/offcanvas.js"></script>
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
<script src="/bootstrap/js/bootstrap-select.js"></script>    
<script>
$(function() {
	$(document).tooltip();
	$(document).keydown(function(e){
		  if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA"){        
			if(e.keyCode === 8){    
				return false;
			}
		  }
	});
	window.history.forward(0);
  });
</script>
</body>
</html>


