<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page isErrorPage="true"%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1"/>
	<title></title>
</head>
<body>
오류페이지<br>
에러타입 : <%=exception.getClass().getName() %><br>
에러 메시지 : <%=exception.getMessage() %>
</body>
</html>
