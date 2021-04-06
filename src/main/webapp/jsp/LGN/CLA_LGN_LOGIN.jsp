<%@ page contentType="text/html;charset=UTF-8" errorPage = "/jsp/common/error/error.jsp"%><%@ 
 include file="/jsp/include/declare.jspf" %><%@
 include file="/jsp/include/header.jspf" %><%
 /***********************************************************************
 *프로그램명 : CLA_LGN_LOGIN.jsp
 *설명 : 전자근로계약 시스템 로그인화면
 *작성자 : 장수호
 *작성일자 : 2017.03.16
 *
 *수정자		수정일자		                                                            수정내용
 *----------------------------------------------------------------------
 *
 ***********************************************************************/
%>
<script type="text/javascript" src="<%=JS_PATH%>JPrototype.js"></script>
<script type="text/javascript">
$().ready(function(){
	window_width = $(window).width();
	if (window_width >= 992){
		big_image = $('.wrapper > .header');
		$(window).on('scroll', materialKitDemo.checkScrollForParallax);
	}
});

function fn_init() {
	frm.ID.value	= "";
	frm.PWD.value	= "";
	
	var message = "${message}";
	if(message != "") {
		alert(message);
	}
	
	fn_getID(document.frm);
}

function setCookie(name, value, expires) {
    document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
}

function getCookie(name) {
    var search = name + "=";
    if (document.cookie.length > 0) {
        offset = document.cookie.indexOf(search);
        if (offset != -1) {
            offset += search.length;
            end = document.cookie.indexOf(";", offset);
            if (end == -1)
                end = document.cookie.length;
            return unescape(document.cookie.substring(offset, end));
        }
    }
    return "";
}

function fn_saveID(frm) {
    var expdate = new Date();
    if (frm.CHECK_ID.checked)
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30);
    else
        expdate.setTime(expdate.getTime() - 1);
    setCookie("SAVE_ID", frm.ID.value, expdate);
}

function fn_getID(frm) {
	frm.CHECK_ID.checked = ((frm.ID.value = getCookie("SAVE_ID")) != "");
}

function fn_login(){
	var frm	= document.frm;
	if(!fn_validate(frm))
		return;
	frm.ID.value	= frm.ID.value.toLowerCase();
	frm.PWD.value	= frm.PWD.value.toLowerCase();
	frm.action		= "/LGN/CLA_LGN_CHECK.do";
	frm.submit();
}

function fn_validate(frm){
	if(frm.ID.value==""){
		alert("아이디를 올바르게 입력하세요.");
		frm.ID.select();
		return false;
	}
	if(frm.PWD.value==""){
		alert("비밀번호를 올바르게 입력하세요.");
		frm.PWD.select();
		return false;
	}
	if(!fn_imemode(IME_MODE_NUMENG,frm.ID,"아이디"))
		return false;
	return true;
}
</script>
<body class="signup-page" onload="javascript:fn_init();">
<%@include file="/jsp/include/navigator.jsp" %>
<div class="wrapper">
	<div class="header header-filter" style="margin:0; background-image: url('<%=IMG_PATH%>bg_demo2.jpg');">
		<div class="container">
			<div class="row">
				<div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3" style="margin-top:-50px;">
					<div class="card card-signup">
						<form class="form" name="frm" method="post" onsubmit="return false;">
							<div class="header header-primary text-center">
								<h4>로그인</h4>
							</div>
							<div class="content">
							 	<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">perm_identity</i>
									</span>
									<input type="text" class="form-control" id="ID" name="ID" placeholder="아이디" onkeydown="javascript:if(event.keyCode==13){document.frm.PWD.focus();}">
								</div>
								
								<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">lock_outline</i>
									</span>
									<input type="password" class="form-control" id="PWD" name="PWD" placeholder="비밀번호" onkeydown="javascript:if(event.keyCode==13){fn_login();}"/>
								</div>
								<div class="checkbox" style="margin-left: 35px;">
									<label>
										<input type="checkbox" id="CHECK_ID" name="optionsCheckboxes" onClick="javascript:fn_saveID(document.frm);">
										아이디 저장
									</label>
								</div>
							</div>
							<div class="footer text-center">
								<button class="btn btn-primary" onclick="javascript:fn_login();">로그인</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<footer class="footer footer-transparent">
		    <div class="container">
		        <div class="copyright pull-center">
		            &copy; (주)한국공인인증서비스. ALL RIGHTS RESERVED.
		        </div>
		    </div>
		</footer>
	</div>
</div>
</body>
</html>