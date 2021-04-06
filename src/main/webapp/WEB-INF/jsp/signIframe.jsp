<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" src="/js/jquery-1.11.2.js"></script>
<script type="text/javascript" src="/js/signature.js"></script>
<link rel="stylesheet" type="text/css" href="/css/layout.css" />
<link rel="stylesheet" type="text/css" href="/css/popup.css" />
<script type="text/javascript">
var signature	= null;
function fn_init(){
	var W	= 500;
	var H	= 200;
	$('#canvasDiv').html('');
	$('#canvasDiv').append("<canvas id='canvas' style='width:"+W+"px;height:"+H+"px;'>현재 브라우져는 HTML5를 지원하지 않습니다.</canvas>");
	signature	= new Signature($("#canvas"));
	signature.canvasWidth	= W;
	signature.canvasHeight	= H;
	
	signature.init_Sign_Canvas();
}
function fn_close(){
	fn_init();
	parent.fn_close_sign();
}

//서명완료
function fn_complete(){
	if(!signature.completeSignature())
		return;
	var imgData	= signature.getImageData();
	parent.fn_show_sign(imgData);
	
	fn_init();
	parent.fn_close_sign();
}
</script>
</head>
<body onload="javascript:fn_init();">
	<div style="height:500px;">
    	<h1>서명하기</h1>
        <div class="contents">
			<div>
				<div id='canvasDiv'style="width:300px;height:300px;border:1px #bebebe solid;">
				</div>
				<br/>
				<input type="button" value="닫기" onclick="javascript:fn_close();"/>
				<br/>
				<input type="button" value="지우기" onclick="javascript:fn_init();"/>
				<br/>
				<a href="javascript:fn_complete();">서명완료</a>
				<!-- <table style="width:100%;margin-top:10px;">
				<tr>
				<td style="width:50%">
					<span class="button btn_gray2"><input type="button" value="닫기" onclick="javascript:fn_close();"/></span>
					<span class="button btn_gray2"><input type="button" value="지우기" onclick="javascript:fn_init();"/></span>
				</td>
				<td style="width:50%; text-align:right;">
					<span class="button btn_orange"><a href="javascript:fn_complete();">서명완료</a></span>
				</td>
				</tr>
				</table> -->
			</div>
		</div>
	</div>
</body>
</html>