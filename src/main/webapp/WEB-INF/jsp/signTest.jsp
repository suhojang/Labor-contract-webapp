<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" src="/js/jquery-1.11.2.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/signature.js"></script>
<script type="text/javascript">
var signature	= null;
function fn_init(){
	var W	= 300;
	var H	= 200;
	$('#canvasDiv').html('');
	$('#canvasDiv').append("<canvas id='canvas' style='width:"+W+"px;height:"+H+"px;'>현재 브라우져는 HTML5를 지원하지 않습니다.</canvas>");
	signature	= new Signature($("#canvas"));
	signature.canvasWidth	= W;
	signature.canvasHeight	= H;
	
	signature.init_Sign_Canvas();
}

//서명완료
function fn_complete(){
	if(!signature.completeSignature())
		return;
	var imgData	= signature.getImageData();
	$("#SIGN_DATA").val(imgData.replace(/^data:image\/(png|jpg);base64,/, ""));
	
	fn_init();
	fn_img_create();
}

function fn_img_create(){
	$.ajax({
		type: "POST"
		,url: "/SIGN_IMGDATA_SND.do"
		,dataType: "jsonp"
		,data: {
				"SIGN_DATA":$("#SIGN_DATA").val()
		}
		,timeout:"60000"
		,success: function(data){
			alert(data['MSG']);
		}
		,error: function(request,status,error){
			alert(request+", "+status+", "+error);
		}
	});
}
</script>
</head>
<body onload="javascript:fn_init();">
	<div id='canvasDiv'style="width:300px;height:200px;border:1px #bebebe solid;"></div>
	<input type="hidden" id='SIGN_DATA'/>
	<br/>
	<input type="button" value="이미지 생성" onclick="javascript:fn_complete();"/>
</body>
</html>