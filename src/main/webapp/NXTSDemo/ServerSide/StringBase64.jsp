<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tradesign.crypto.provider.JeTS" %>
<%@ page import="tradesign.crypto.cert.*" %>
<%@ page import="tradesign.pki.pkix.*" %> 
<%@ page import="tradesign.pki.util.JetsUtil" %>
<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*" %>
<html>
<HEAD>
<link rel="stylesheet" href="../tradesign2.css" type="text/css">
<SCRIPT language="javascript">

	function plainTextchk()
	{
		if( document.myform.data.value == "" ){
			alert("Base64 인코딩 할 원문 데이타를 입력하세요!");
			document.myform.plainText.focus();
			return false;
		}
		document.myform.mode.value ="enc";
		document.myform.action="StringBase64.jsp";
		document.myform.method="post";
		document.myform.submit();
	}
	function signdatachk()
	{
		if( document.myform.data.value == "" || document.myform.b64encText.value == ""){
		
			alert("Base64 인코딩 할 원문 데이타를 입력후 Base64 인코딩 하신후 디코딩 주세요");
			return false;
		}
		
		document.myform.mode.value ="dec";
		document.myform.action="StringBase64.jsp";
		document.myform.method="post";
		document.myform.submit();
	}	
</SCRIPT>
</HEAD>
<body>

<%
	try{
		JeTS.installProvider("./tradesign3280.properties");
		
		// 원문 데이타	
		String data = new String(request.getParameter("data").getBytes("ISO-8859-1"), "UTF-8");
		
		// base64enc, base64dec 모드 설정
		String Signmode = request.getParameter("mode");
		String Strb64_enc = "", Strb64_dec = "";
		
		if( Signmode.equals("enc")){
			byte[] b64_enc = JetsUtil.encodeBase64(data.getBytes());
			
			// Base64 인코딩 데이타
			Strb64_enc = new String(b64_enc);
		
		}
		else{
		
			
			Strb64_enc = new String(request.getParameter("b64encText").getBytes("ISO-8859-1"));
			// Base64 디코딩 후 나온 원문 데이타
			Strb64_dec = new String(JetsUtil.decodeBase64(Strb64_enc.getBytes()));
			
		}
		
		
%>
<form name="myform">
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 원본 데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="data" rows="6" cols="90" ><%= data %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" onClick="JavaScript:plainTextchk()" Value="Base64 인코딩" style="width:150">
    </td>
  </tr>
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== Base64 encoding ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="b64encText" rows="6" cols="90" ><%= Strb64_enc %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" onClick="JavaScript:signdatachk()" Value="Base64 디코딩" style="width:150">
    </td>
  </tr>
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== Base64 decoding ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="b64decText" rows="6" cols="90" ><%= Strb64_dec %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
     <INPUT TYPE="button" Value="화면 지우기" onClick="location.href='./StringBase64.html'">
    </td>
  </tr>
</table>
<input type="hidden" name="mode">
</form>
<%

	}//end of try
	catch(Exception e)
	{
		e.printStackTrace();
		String ret = e.getMessage();
		out.print("에러 : " + ret);
	}
%>
</BODY>
</HTML>
  
