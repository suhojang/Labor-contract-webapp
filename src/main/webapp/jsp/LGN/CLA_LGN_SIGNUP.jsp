<%@ page contentType="text/html;charset=UTF-8" errorPage = "/jsp/common/error/error.jsp"%><%@ 
 include file="/jsp/include/declare.jspf" %><%@
 include file="/jsp/include/header.jspf" %><%
 /***********************************************************************
 *프로그램명 : CLA_LGN_SIGNUP.jsp
 *설명 : 전자근로계약 시스템 회원가입화면
 *작성자 : 장수호
 *작성일자 : 2017.03.15
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

function fn_signup(){
	var frm	= document.frm;
	if(!fn_validate(frm))
		return;
	frm.ID.value	= frm.ID.value.toLowerCase();
	frm.PWD.value	= frm.PWD.value.toLowerCase();
	frm.EML.value	= frm.EML.value.toLowerCase();
	
	frm.action		= "/LGN/INS_CLA_INFO.do";
	frm.submit();
}

function fn_checkID(frm){
	$.ajax({
		type: "POST"
		,url: "/LGN/CLA_LGN_IDCHK.do"
		,dataType: "json"
		,data: {
			"ID":frm.ID.value
			}
		,timeout:"10000"
		,success: function(data){
			if(data['CHECKED']=="Y"){
				alert("중복되는 아이디가 존재합니다.");
				return;
			}
			else
				fn_signup();
		}
		,error: function(request,status,error){
			alert("code:"+request.status+"\n"+"error:"+error);
			return false;
		}
	});
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
	if(frm.PWD2.value==""){
		alert("비밀번호 확인을 올바르게 입력하세요.");
		frm.PWD2.select();
		return false;
	}
	if(frm.HP.value==""){
		alert("핸드폰번호를 올바르게 입력하세요.");
		frm.HP.select();
		return false;
	}
	if(frm.EML.value==""){
		alert("이메일을 올바르게 입력하세요.");
		frm.EML.select();
		return false;
	}
	if(frm.NM.value==""){
		alert("대표자명을 올바르게 입력하세요.");
		frm.NM.select();
		return false;
	}
	if(frm.BSNM.value==""){
		alert("사업체명을 올바르게 입력하세요.");
		frm.BSNM.select();
		return false;
	}
	if(frm.ADDR.value==""){
		alert("사업체 주소를 올바르게 입력하세요.");
		frm.ADDR.select();
		return false;
	}
	if(frm.TEL.value==""){
		alert("회사연락처를 올바르게 입력하세요.");
		frm.TEL.select();
		return false;
	}
	if(frm.PWD.value != frm.PWD2.value){
		alert("비밀번호 확인을 올바르게 입력하세요.");
		frm.PWD2.select();
		return false;
	}
	if(!fn_imemode(IME_MODE_NUMENG,frm.ID,"아이디"))
		return false;
	if(frm.HP.value.length < 10){
		alert("핸드폰번호를 올바르게 입력하세요.");
		frm.HP.select();
		return false;
	}
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.HP,"담당자연락처"))
		return false;
	if(!fn_imemode(IME_MODE_EMAIL,frm.EML,"담당자이메일"))
		return false;
	if(frm.TEL.value.length < 9){
		alert("회사연락처를 올바르게 입력하세요.");
		frm.TEL.select();
		return false;
	}
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.TEL,"회사연락처"))
		return false;
	
	return true;
}
</script>
<body class="signup-page">
<%@include file="/jsp/include/navigator.jsp" %>
<div class="wrapper">
	<div class="header header-filter" style="margin:0; background-image: url('<%=IMG_PATH%>bg_demo2.jpg');">
		<div class="container">
			<div class="row">
				<div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3" style="margin-top:-50px;">
					<div class="card card-signup">
						<form class="form" name="frm" method="post" onsubmit="return false;">
							<div class="header header-primary text-center">
								<h4>회원가입</h4>
							</div>
							<div class="content">
							 	<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">perm_identity</i>
									</span>
									<input type="text" class="form-control" id="ID" name="ID" placeholder="아이디" maxlength="20" onkeydown="javascript:if(event.keyCode==13){document.frm.PWD.focus();}">
								</div>
								
								<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">lock_outline</i>
									</span>
									<input type="password" class="form-control" id="PWD" name="PWD" placeholder="비밀번호" maxlength="30" onkeydown="javascript:if(event.keyCode==13){document.frm.PWD2.focus();}"/>
								</div>
								
								<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">lock_outline</i>
									</span>
									<input type="password" class="form-control" id="PWD2" name="PWD2" placeholder="비밀번호 확인" maxlength="30" onkeydown="javascript:if(event.keyCode==13){document.frm.HP.focus();}"/>
								</div>
								
								<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">phone_android</i>
									</span>
									<input type="text" class="form-control" id="HP" name="HP" placeholder="담당자연락처(ex.01012345678)" maxlength="12" onkeydown="javascript:if(event.keyCode==13){document.frm.EML.focus();}">
								</div>
								
								<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">mail_outline</i>
									</span>
									<input type="text" class="form-control" id="EML" name="EML" placeholder="담당자이메일(ex.master@marster.com)" maxlength="50" onkeydown="javascript:if(event.keyCode==13){document.frm.NM.focus();}">
								</div>
								
								<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">face</i>
									</span>
									<input type="text" class="form-control" id="NM" name="NM" placeholder="대표자명" maxlength="10" onkeydown="javascript:if(event.keyCode==13){document.frm.BSNM.focus();}">
								</div>
								
								<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">domain</i>
									</span>
									<input type="text" class="form-control" id="BSNM" name="BSNM" placeholder="사업체명" maxlength="20" onkeydown="javascript:if(event.keyCode==13){document.frm.ADDR.focus();}">
								</div>

								<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">add_location</i>
									</span>
									<input type="text" class="form-control" id="ADDR" name="ADDR" placeholder="사업체 주소" maxlength="100" onkeydown="javascript:if(event.keyCode==13){document.frm.TEL.focus();}">
								</div>
								
								<div class="input-group">
									<span class="input-group-addon">
										<i class="material-icons">local_phone</i>
									</span>
									<input type="text" class="form-control" id="TEL" name="TEL" maxlength="12" placeholder="회사연락처(ex.0212345678)">
								</div>
							</div>
							<div class="footer text-center">
								<button class="btn btn-primary" onclick="javascript:fn_checkID(document.frm);">가입</button>
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