<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" errorPage = "/jsp/common/error/error.jsp"%><%@ 
 include file="/jsp/include/declare.jspf" %><%@
 include file="/jsp/include/header.jspf" %><%
 /***********************************************************************
 *프로그램명 : CLA_EDC_UPT.jsp
 *설명 : 전자근로계약 수정하기
 *작성자 : 장수호
 *작성일자 : 2017.03.20
 *
 *수정자		수정일자		                                                            수정내용
 *----------------------------------------------------------------------
 *
 ***********************************************************************/
%>
<%
	String today	= new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
	String newToday	= Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))+1+"-"+new SimpleDateFormat("MM-dd").format(new java.util.Date());
%>
<script type="text/javascript" src="<%=JS_PATH%>JPrototype.js"></script>
<script type="text/javascript" src="<%=JS_PATH%>signature.js"></script>
<%@include file="/NXTSDemo/CSSide/openweb/common.jsp" %>
<script src="/NXTSDemo/js/openweb/demo.js"></script>
<script type="text/javascript">
$().ready(function(){
	window_width = $(window).width();
	if (window_width >= 992){
		big_image = $('.wrapper > .header');
		$(window).on('scroll', materialKitDemo.checkScrollForParallax);
	}
});
</script>
<style>
.col-md-8 .title_reg{
	box-shadow: 0 16px 38px -12px rgba(0, 0, 0, 0.56), 0 4px 25px 0px rgba(0, 0, 0, 0.12), 0 8px 10px -5px rgba(0, 0, 0, 0.2);
    margin-left: 20px;
    margin-right: 20px;
    margin-top: -40px;
    padding: 20px 0;
    background: linear-gradient(60deg, #ab47bc, #7b1fa2);
    border-radius: 3px;
    text-align: center;
    -webkit-tap-highlight-color: rgba(255, 255, 255, 0);
    -webkit-tap-highlight-color: transparent;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
}
.table thead tr th, td {
	color : #000000;
	border: 0px;
	font-size: 14px;
	font-family: "Roboto", "Helvetica", "Arial", sans-serif;
	font-weight: bold;
}
</style>
<script type="text/javascript">
var signature	= null;
function fn_init(){
	if("<%=_OS%>"=="PC"){
		nxTSPKI.onInit(function(){ 
		});
		nxTSPKI.init(true);
	}
	
	document.getElementById("toggleBtn").setAttribute("class","navbar-toggle");
	document.getElementById("toggleBtn").setAttribute("className","navbar-toggle");
	
	var W	= 270;
	var H	= 200;
	$('#canvasDiv').html('');
	$('#canvasDiv').append("<canvas id='canvas' style='width:"+W+"px;height:"+H+"px;'>현재 브라우져는 HTML5를 지원하지 않습니다.</canvas>");
	signature	= new Signature($("#canvas"));
	signature.canvasWidth	= W;
	signature.canvasHeight	= H;
	
	signature.init_Sign_Canvas();
}

//서명완료
function fn_complete(frm){
	frm.MPAY.value		= fn_comma(frm.MPAY.value, false); 
	frm.BNSAMT.value	= fn_comma(frm.BNSAMT.value, false); 
	frm.OPAMT1.value	= fn_comma(frm.OPAMT1.value, false); 
	frm.OPAMT2.value	= fn_comma(frm.OPAMT2.value, false); 
	frm.OPAMT3.value	= fn_comma(frm.OPAMT3.value, false); 
	frm.OPAMT4.value	= fn_comma(frm.OPAMT4.value, false); 
		
	if(!fn_validate(frm))
		return;
	if(!signature.completeSignature())
		return;
	var imgData	= signature.getImageData();
	$("#SIGN_DATA").val(imgData.replace(/^data:image\/(png|jpg);base64,/, ""));
	
	fn_data_snd();
}

var sign_data;
function fn_data_snd(){
	$.ajax({
		type: "POST"
		,url: "/EDC/CLA_EDC_UPTDATA.do"
		,dataType: "json"
		,data: {
				"CNNO":$("#CNNO").val(),
				"SGNO":$("#SGNO").val(),
				"CRNO":$("#CRNO").val(),
				"WKNM":$("#WKNM").val(),
				"HP":$("#HP").val(),
				"EML":$("#EML").val(),
				"COLSD":$("#COLSD").val(),
				"COLED":$("#COLED").val(),
				"POS":$("#POS").val(),
				"COB":$("#COB").val(),
				"LABST":$("#LABST").val(),
				"LABET":$("#LABET").val(),
				"RSTST":$("#RSTST").val(),
				"RSTET":$("#RSTET").val(),
				"WKD":$("#WKD").val(),
				"HLD":$("#HLD").val(),
				"MPAY":$("#MPAY").val(),
				"BNSAMT":$("#BNSAMT").val(),
				"OPAMT1":$("#OPAMT1").val(),
				"OPAMT2":$("#OPAMT2").val(),
				"OPAMT3":$("#OPAMT3").val(),
				"OPAMT4":$("#OPAMT4").val(),
				"DPSDAT":$("#DPSDAT").val(),
				"MTHD":$(':radio[name="MTHD"]:checked').val(),
				"CNTDAT":$("#CNTDAT").val(),
				"SIGN_DATA":$("#SIGN_DATA").val()
		}
		,timeout:"60000"
		,success: function(data){
			if(data['RESULT']!="Y"){
				alert(data['MSG']);
				return;
			}
			else{
				if("<%=_OS%>"=="PC"){
					//문서서명하기
					fn_cert_sign(data);
				}else{
					document.location.href	= "/EDC/CLA_EDC_SEL01.do";
				}
			}
		}
		,error: function(request,status,error){
			alert(request+", "+status+", "+error);
		}
	});
}

//문서전자서명하기
function fn_cert_sign(data){
	sign_data	= data;
	//전자서명
	nxTSPKI.signData(data['HASH'], null, fn_cert_sign_complete);
}

function fn_cert_sign_complete(res){
	//전자서명 성공
	if(res.code == 0){
		$.ajax({
			type: "POST"
			,url: "/EDC/CLA_EDC_UPTCRTSIGN.do"
			,dataType: "json"
			,data: {
					"CNNO": sign_data['CNNO'],
					"CRNO":	sign_data['CRNO'],
					"PTH":	sign_data['SGNPTH'],
					"SIGNDATA":res.data['signedData'],
					"USRKN":"2"
			}
			,timeout:"60000"
			,success: function(data){
				alert(data['MSG']);
				document.location.href	= "/EDC/CLA_EDC_SEL01.do";
			}
			,error: function(request,status,error){
				alert(request+", "+status+", "+error);
			}
		});
	}
	//전자서명 실패
	else{
		alert("error code = " + res.code + ", message = " + res.errorMessage);
		document.location.href	= "/EDC/CLA_EDC_SEL01.do";
	}
}

function fn_validate(frm){
	if(frm.WKNM.value==""){
		alert("근로자명을 올바르게 입력하세요.");
		frm.WKNM.select();
		return false;
	}
	if(frm.HP.value==""){
		alert("근로자 핸드폰번호를 올바르게 입력하세요.");
		frm.HP.select();
		return false;
	}
	if(frm.EML.value==""){
		alert("근로자 이메일을 올바르게 입력하세요.");
		frm.EML.select();
		return false;
	}
	if(frm.COLSD.value==""){
		alert("근로계약시작일을 올바르게 입력하세요.");
		frm.COLSD.select();
		return false;
	}
	if(frm.COLED.value==""){
		alert("근로계약종료일을 올바르게 입력하세요.");
		frm.COLED.select();
		return false;
	}
	if(frm.POS.value==""){
		alert("근무장소를 올바르게 입력하세요.");
		frm.POS.select();
		return false;
	}
	if(frm.COB.value==""){
		alert("근무내용을 올바르게 입력하세요.");
		frm.COB.select();
		return false;
	}
	if(frm.LABST.value==""){
		alert("근로시작시간을 올바르게 입력하세요.");
		frm.LABST.select();
		return false;
	}
	if(frm.LABET.value==""){
		alert("근로종료시간을 올바르게 입력하세요.");
		frm.LABET.select();
		return false;
	}
	if(frm.RSTST.value==""){
		alert("휴게시작시간을 올바르게 입력하세요.");
		frm.RSTST.select();
		return false;
	}
	if(frm.RSTET.value==""){
		alert("휴게종료시간을 올바르게 입력하세요.");
		frm.RSTET.select();
		return false;
	}
	if(frm.WKD.value==""){
		alert("근무일수(매주)을 올바르게 입력하세요.");
		frm.WKD.select();
		return false;
	}
	if(frm.HLD.value==""){
		alert("휴일(요일)을 올바르게 입력하세요.");
		frm.HLD.select();
		return false;
	}
	if(frm.MPAY.value==""){
		alert("급여를 올바르게 입력하세요.");
		frm.MPAY.select();
		return false;
	}
	if(frm.DPSDAT.value==""){
		alert("입금지급일(매달)을 올바르게 입력하세요.");
		frm.DPSDAT.select();
		return false;
	}
	if(frm.CNTDAT.value==""){
		alert("계약일을 올바르게 입력하세요.");
		frm.CNTDAT.select();
		return false;
	}
	
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.HP,"근로자연락처"))
		return false;
	if(!fn_imemode(IME_MODE_EMAIL,frm.EML,"근로자이메일"))
		return false;
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.LABST,"근로시작시간"))
		return false;
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.LABET,"근로종료시간"))
		return false;
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.RSTST,"휴게시작시간"))
		return false;
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.RSTET,"휴게종료시간"))
		return false;
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.WKD,"근무일수(매주)"))
		return false;
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.MPAY,"급여"))
		return false;
	if(!fn_imemode(IME_MODE_NUMBERONLY,frm.DPSDAT,"입금지급일(매달)"))
		return false;
	return true;
}

function fn_cancel(frm){
	document.location.href	= "/EDC/CLA_EDC_SEL01.do";
}
</script>
<body class="landing-page" onload="javascript:fn_init();">
<%@include file="/jsp/include/navigator.jsp" %>
<div class="wrapper">
	<div class="header header-filter" style="padding-top:100px;margin:0; background-image: url('<%=IMG_PATH%>bg_demo2.jpg');">
		<div class="main main-raised" style="margin-top:0;">
			<div class="container"style="padding:0px;">
				<div class="section landing-section" style="padding:0px;">
	                <div class="row" style="margin:0px;">
	                    <div class="col-md-8 col-md-offset-2">
	                    	<div class="title_reg">
								<h4>전자근로계약서 작성</h4>
							</div>
	                        <form name="frm" method="post" onsubmit="return false;">
	                        	<input type="hidden" name="CNNO" id="CNNO" value="<c:out value="${result.CNNO}"/>" />
	                        	<input type="hidden" name="SGNO" id="SGNO" value="<c:out value="${result.SGNO}"/>" />
	                        	<input type="hidden" name="CRNO" id="CRNO" value="<c:out value="${result.CRNO}"/>" />
	                            <div class="row">
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">face</i>
										</span>
										<input type="text" class="form-control" id="WKNM" name="WKNM" value="<c:out value="${result.CLNM}"/>" placeholder="근로자명" maxlength="10" onkeydown="javascript:if(event.keyCode==13){document.frm.HP.focus();}">
									</div> 
									<div class="input-group">
										<span class="input-group-addon">
											<i class="material-icons">phone_android</i>
										</span>
										<input type="text" class="form-control" id="HP" name="HP" value="<c:out value="${result.CLHP}"/>" placeholder="근로자연락처(ex.01012345678)" maxlength="12" onkeydown="javascript:if(event.keyCode==13){document.frm.EML.focus();}">
									</div>
									<div class="input-group">
										<span class="input-group-addon">
											<i class="material-icons">mail_outline</i>
										</span>
										<input type="text" class="form-control" id="EML" name="EML" value="<c:out value="${result.CLEML}"/>" placeholder="근로자이메일(ex.master@marster.com)" maxlength="50" onkeydown="javascript:if(event.keyCode==13){document.frm.COLSD.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">date_range</i>
										</span>
										<input type="text" class="datepicker form-control" id="COLSD" name="COLSD" value="<c:out value="${result.COLSD}"/>" placeholder="근로계약시작일" maxlength="10" readonly="readonly" value="<%=today%>">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">date_range</i>
										</span>
										<input type="text" class="datepicker form-control" id="COLED" name="COLED" value="<c:out value="${result.COLED}"/>" placeholder="근로계약종료일" maxlength="10" readonly="readonly" value="<%=newToday%>">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">add_location</i>
										</span>
										<input type="text" class="form-control" id="POS" name="POS" value="<c:out value="${result.POS}"/>" placeholder="근무장소" maxlength="300" onkeydown="javascript:if(event.keyCode==13){document.frm.COB.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">content_paste</i>
										</span>
										<input type="text" class="form-control" id="COB" name="COB" value="<c:out value="${result.COB}"/>" placeholder="근무내용" maxlength="300" onkeydown="javascript:if(event.keyCode==13){document.frm.LABST.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">access_time</i>
										</span>
										<input type="text" class="form-control" id="LABST" name="LABST" value="<c:out value="${result.LABST}"/>" placeholder="근로시작시간(hhmm)" maxlength="4" onkeydown="javascript:if(event.keyCode==13){document.frm.LABET.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">access_time</i>
										</span>
										<input type="text" class="form-control" id="LABET" name="LABET" value="<c:out value="${result.LABET}"/>" placeholder="근로종료시간(hhmm)" maxlength="4" onkeydown="javascript:if(event.keyCode==13){document.frm.RSTST.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">access_time</i>
										</span>
										<input type="text" class="form-control" id="RSTST" name="RSTST" value="<c:out value="${result.RSTST}"/>" placeholder="휴게시작시간(hhmm)" maxlength="4" onkeydown="javascript:if(event.keyCode==13){document.frm.RSTET.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">access_time</i>
										</span>
										<input type="text" class="form-control" id="RSTET" name="RSTET" value="<c:out value="${result.RSTET}"/>" placeholder="휴게종료시간(hhmm)" maxlength="4" onkeydown="javascript:if(event.keyCode==13){document.frm.WKD.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">accessibility</i>
										</span>
										<input type="text" class="form-control" id="WKD" name="WKD" value="<c:out value="${result.WKD}"/>" placeholder="근무일수(매주)" maxlength="1" onkeydown="javascript:if(event.keyCode==13){document.frm.HLD.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">today</i>
										</span>
										<input type="text" class="form-control" id="HLD" name="HLD" value="<c:out value="${result.HLD}"/>" placeholder="휴일(요일)" maxlength="3" onkeydown="javascript:if(event.keyCode==13){document.frm.MPAY.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">attach_money</i>
										</span>
										<input type="text" class="form-control" id="MPAY" name="MPAY" value="<c:out value="${result.MPAY}"/>" placeholder="급여" maxlength="15" 
										onfocus="javascript:this.value=fn_comma(this.value,false);this.select();" 
										onblur="javascript:this.value=fn_comma(this.value,true);"  onkeydown="javascript:if(event.keyCode==13){document.frm.BNSAMT.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">attach_money</i>
										</span>
										<input type="text" class="form-control" id="BNSAMT" name="BNSAMT" value="<c:out value="${result.BNSAMT}"/>" placeholder="상여금액" maxlength="15"
										onfocus="javascript:this.value=fn_comma(this.value,false);this.select();" 
										onblur="javascript:this.value=fn_comma(this.value,true);"   
										onkeydown="javascript:if(event.keyCode==13){document.frm.OPAMT1.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">attach_money</i>
										</span>
										<input type="text" class="form-control" id="OPAMT1" name="OPAMT1" value="<c:out value="${result.OPAMT1}"/>" placeholder="기타급여금액1" maxlength="15"
										onfocus="javascript:this.value=fn_comma(this.value,false);this.select();" 
										onblur="javascript:this.value=fn_comma(this.value,true);"   
										onkeydown="javascript:if(event.keyCode==13){document.frm.OPAMT2.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">attach_money</i>
										</span>
										<input type="text" class="form-control" id="OPAMT2" name="OPAMT2" value="<c:out value="${result.OPAMT2}"/>" placeholder="기타급여금액2" maxlength="15" 
										onfocus="javascript:this.value=fn_comma(this.value,false);this.select();" 
										onblur="javascript:this.value=fn_comma(this.value,true);"  
										onkeydown="javascript:if(event.keyCode==13){document.frm.OPAMT3.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">attach_money</i>
										</span>
										<input type="text" class="form-control" id="OPAMT3" name="OPAMT3" value="<c:out value="${result.OPAMT3}"/>" placeholder="기타급여금액3" maxlength="15" 
										onfocus="javascript:this.value=fn_comma(this.value,false);this.select();" 
										onblur="javascript:this.value=fn_comma(this.value,true);"  
										onkeydown="javascript:if(event.keyCode==13){document.frm.OPAMT4.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">attach_money</i>
										</span>
										<input type="text" class="form-control" id="OPAMT4" name="OPAMT4" value="<c:out value="${result.OPAMT4}"/>" placeholder="기타급여금액4" maxlength="15" 
										onfocus="javascript:this.value=fn_comma(this.value,false);this.select();" 
										onblur="javascript:this.value=fn_comma(this.value,true);"  
										onkeydown="javascript:if(event.keyCode==13){document.frm.DPSDAT.focus();}">
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">date_range</i>
										</span>
										<input type="text" class="form-control" id="DPSDAT" name="DPSDAT" value="<c:out value="${result.DPSDAT}"/>" placeholder="입금지급일(매달)" maxlength="2" 
										onfocus="javascript:this.value=fn_comma(this.value,false);this.select();" 
										onblur="javascript:this.value=fn_comma(this.value,true);"  
										onkeydown="javascript:if(event.keyCode==13){document.frm.MTHD.focus();}">
									</div>
									<div class="radio" style="margin-left: 12px;">
										<c:if test="${result.MTD == '1' }">
											<label>
												<input type="radio" name="MTHD" value="1" checked>
												 직접지급
											</label>
											<label>
												<input type="radio" name="MTHD" value="2">
												예금통장에 입금
											</label>
										</c:if>
										<c:if test="${result.MTD == '2' }">
											<label>
												<input type="radio" name="MTHD" value="1">
												 직접지급
											</label>
											<label>
												<input type="radio" name="MTHD" value="2" checked>
												예금통장에 입금
											</label>
										</c:if>
									</div>
									<div class="input-group" style="padding-right: 10px;">
										<span class="input-group-addon">
											<i class="material-icons">date_range</i>
										</span>
										<input type="text" class="datepicker form-control" id="CNTDAT" name="CNTDAT" value="<c:out value="${result.CNTDAT}"/>" placeholder="계약일" maxlength="10" readonly="readonly" value="<%=today%>">
									</div>
									
									<div id='canvasDiv'style="width:270px;height:200px;border:1px #bebebe solid;margin-left: 55px;"></div>
									<input type="hidden" id='SIGN_DATA'/>
									
	                                <div class="col-md-4 col-md-offset-4 text-center">
	                                	<button class="btn btn-primary btn-raised" onclick="javascript:fn_init();">
											서명지우기
										</button>
										<button class="btn btn-primary btn-raised" onclick="javascript:fn_cancel(document.frm);">
											취소
										</button>
	                                    <button class="btn btn-primary btn-raised" onclick="javascript:fn_complete(document.frm);">
											완료
										</button>
	                                </div>
	                            </div>
	                        </form>
	                    </div>
	                </div>
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
</body>
</html>