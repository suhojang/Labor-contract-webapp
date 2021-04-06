<%@page import="java.util.Date"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="kcert.bill.PropertiesInfo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" errorPage = "/jsp/common/error/error.jsp"%><%@ 
 include file="/jsp/include/declare.jspf" %><%@
 include file="/jsp/include/header.jspf" %><%
 /***********************************************************************
 *프로그램명 : CLA_EDC_SEL02.jsp
 *설명 : 전자근로계약 조회하기
 *작성자 : 장수호
 *작성일자 : 2017.03.17
 *
 *수정자		수정일자		                                                            수정내용
 *----------------------------------------------------------------------
 *
 ***********************************************************************/
%>
<%
	Properties prop	= new Properties();
	try{
		prop.load(new FileInputStream(new File(PropertiesInfo.properties_Path)));
	}catch(Exception e){
		e.printStackTrace();
	}
	String src	= prop.getProperty("CERTPDF.SRC");
	
%>
<script type="text/javascript" src="<%=JS_PATH%>JPrototype.js"></script>
<%@include file="/NXTSDemo/CSSide/openweb/common.jsp" %>
<script type="text/javascript">
$().ready(function(){
	window_width = $(window).width();
	if (window_width >= 992){
		big_image = $('.wrapper > .header');
		$(window).on('scroll', materialKitDemo.checkScrollForParallax);
	}
});
</script>
<script type="text/javascript">
var obj	= new Object();
function fn_init(){
	
}

function fn_linkPage(pageNo){
	frm.pageNo.value	= pageNo;
	frm.action	= "/EDC/CLA_EDC_SEL02.do";
	frm.submit();
}

function fn_open_pdf(cnno,sts){
	var loc	= location.protocol+"//"+document.location.host;
	var filePath	= "";
	if (sts=="99") {
		filePath	= loc+"/pdf/A01/complete/"+cnno+".pdf";
	}else{
		filePath	= loc+"/pdf/A01/"+cnno+".pdf";
	}
	var frm	= document.viewer;
	frm.target	= "_blank";
	frm.file.value	= filePath;
	frm.action	= loc + "/pdfjs/web/viewer.html";
	frm.submit();
}

function fn_mail_send(cnno, email, bsnm){
	$.ajax({
		type: "POST"
		,url: "/EDC/CLA_SND_MAIL.do"
		,dataType: "json"
		,data: {
				"CNNO": 	cnno,
				"EMAIL":	email,
				"BSNM":		bsnm,
				"LOC":		document.location.host
		}
		,timeout:"60000"
		,success: function(data){
			if(data['success']!="Y"){
				alert(data['MSG']);
				return;
			}
			else{
				alert("근로자에게 메일전송이 완료되었습니다.");
				document.location.href	= "/EDC/CLA_EDC_SEL03.do";
			}
		}
		,error: function(request,status,error){
			alert(request+", "+status+", "+error);
		}
	});
}

function fn_edc_delete(cnno,clnm){
	if(!confirm("근로자 [" + clnm + "]님의 전자근로계약 정보를 삭제 하시겠습니까?"))
		return;
	//삭제 ajax 통신
	$.ajax({
		type: "POST"
		,url: "/EDC/CLA_EDC_DEL.do"
		,dataType: "json"
		,data: {
				"CNNO": 	cnno
		}
		,timeout:"60000"
		,success: function(data){
			if(data['RESULT']!="Y"){
				alert(data['MSG']);
				return;
			}
			else{
				alert("근로자 [" + clnm + "]님의 전자근로계약 정보가 삭제되었습니다.");
				document.location.href	= "/EDC/CLA_EDC_SEL02.do";
			}
		}
		,error: function(request,status,error){
			alert(request+", "+status+", "+error);
		}
	});
}
</script>
<body class="landing-page" onload="javascript:fn_init();">
<%@include file="/jsp/include/navigator.jsp" %>
<form name="viewer" method="get" onsubmit="return false;">
	<input type="hidden" id="file" name="file" />
</form>
<div class="wrapper">
	<div class="header header-filter" style="margin:0; background-image: url('<%=IMG_PATH%>bg_demo2.jpg');">
		<form name="frm" method="post" onsubmit="return false;">
			<input type="hidden" name="cnno" id="cnno" value="" />
			<input type="hidden" name="pageNo" id="pageNo" value="" />
			<div class="container">
				<table class="table">
				    <thead>
				        <tr>
				            <th class="text-center">일련번호</th>
				            <th class="text-center">근로자명</th>
				            <th class="text-center">계약기간</th>
				            <th class="text-center">금액</th>
				            <th class="text-center">Actions</th>
				        </tr>
				    </thead>
				    <tbody>
				    	<c:if test="${empty result}">
							<tr>
								<td colspan="5" class="text-center">전자근로계약서 전자서명 내역이 없습니다.</td>
							</tr>
						</c:if>
						<c:if test="${!empty result}">
							<c:forEach var="result" items="${result}" varStatus="status">
							<tr>
								<td class="text-center"><c:out value="${result.cnno}"/></td>
								<td class="text-center"><c:out value="${result.clnm}"/></td>
								<td class="text-center"><c:out value="${result.colsd}"/> ~ <c:out value="${result.coled}"/></td>
								<td class="text-center"><c:out value="${result.mpay}"/> 원</td>
								<td class="td-actions text-right">
									<%
										if("PC".equals(_OS)){
									%>
							                <button type="button" rel="tooltip" title="전자문서 열람" class="btn btn-danger btn-simple btn-xs" onclick="javascript:fn_open_pdf('<c:out value="${result.cnno}"/>','<c:out value="${result.sts}"/>');">
							                    <i class="fa fa-file-pdf-o"></i>
							                </button>
							                <button type="button" rel="tooltip" title="근로자에게 전송" class="btn btn-info btn-simple btn-xs" onclick="javascript:fn_mail_send('<c:out value="${result.cnno}"/>','<c:out value="${result.cleml}"/>','<c:out value="${result.bsnm}"/>');">
							                    <i class="fa fa-mail-reply-all"></i>
							                </button>
							                <button type="button" rel="tooltip" title="근로계약서 삭제" class="btn btn-danger btn-simple btn-xs" onclick="javascript:fn_edc_delete('<c:out value="${result.cnno}"/>','<c:out value="${result.clnm}"/>');">
							                    <i class="fa fa-times"></i>
							                </button>
									<%		
										}else{
									%>
							                <button type="button" rel="tooltip" title="전자문서 열람" class="btn btn-danger btn-simple btn-xs" onclick="javascript:fn_open_pdf('<c:out value="${result.cnno}"/>','<c:out value="${result.sts}"/>');">
							                    <i class="fa fa-file-pdf-o"></i>
							                </button>
							                <button type="button" rel="tooltip" title="근로계약서 삭제" class="btn btn-danger btn-simple btn-xs" onclick="javascript:fn_edc_delete('<c:out value="${result.cnno}"/>','<c:out value="${result.clnm}"/>');">
							                    <i class="fa fa-times"></i>
							                </button>
									<%		
										}
									%>
					            </td>
				            </tr>
							</c:forEach>
						</c:if>
				    </tbody>
				</table>
				<!--페이지 -->
				<div id="paging" align="center">
					<ui:pagination paginationInfo = "${paginationInfo}"
							   type="image"
							   jsFunction="fn_linkPage"
							   />
			     </div>
			</div>
		</form>
	</div>
	<footer class="footer footer-transparent">
        <div class="container">
            <div class="copyright">
                &copy; (주)한국공인인증서비스. ALL RIGHTS RESERVED.
            </div>
        </div>
    </footer>
</div>
</body>
</html>