<%@ page contentType="text/html;charset=UTF-8" errorPage = "/jsp/common/error/error.jsp"%><%@ 
 include file="/jsp/include/declare.jspf" %><%@
 include file="/jsp/include/header.jspf" %><%
 /***********************************************************************
 *프로그램명 : CLA_LGN_MAIN.jsp
 *설명 : 전자근로계약 시스템 메인화면
 *작성자 : 장수호
 *작성일자 : 2017.03.14
 *
 *수정자		수정일자		                                                            수정내용
 *----------------------------------------------------------------------
 *
 ***********************************************************************/
%>
<script type="text/javascript">
$().ready(function(){
	window_width = $(window).width();
	if (window_width >= 992){
		big_image = $('.wrapper > .header');
		$(window).on('scroll', materialKitDemo.checkScrollForParallax);
	}
});
</script>
<body class="index-page">
<%@include file="/jsp/include/navigator.jsp" %>
<div class="wrapper">
	<div class="header header-filter" style="margin:0; background-image: url('<%=IMG_PATH%>bg_demo2.jpg');">
		<div class="container">
			<div class="row">
				<div class="col-md-8 col-md-offset-2">
					<div class="brand">
						<h1>DEMO</h1>
						<h3>고용주와 구직자간에 안전하고 편리하게 사용할 수 있는 전자근로계약시스템 입니다.</h3>
					</div>
				</div>
			</div>

		</div>
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