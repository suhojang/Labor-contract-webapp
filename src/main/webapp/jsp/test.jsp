<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
function fn_fileName(){
	var selection	=  window.getSelection();
	alert(selection);
	alert(selection.getRangeAt(0));
	alert(selection.toString());
	alert(document.getElementById("file").value);
}
</script>
<body>
<!--  onchange="this.select(); document.getElementById('fileName').value=document.selection.createRange().text.toString();" 

onchange="fn_fileName(this.value);"
-->
<input type="file" name="file" id="file" value="" onchange="this.select();fn_fileName();"/>
<input type="text" name="fileName" id="fileName" value=""/>
</body>
</html>