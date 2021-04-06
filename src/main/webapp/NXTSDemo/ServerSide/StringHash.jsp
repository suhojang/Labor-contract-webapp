<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tradesign.crypto.provider.JeTS" %>
<%@ page import="tradesign.crypto.cert.*" %>
<%@ page import="tradesign.pki.pkix.*" %> 
<%@ page import="tradesign.pki.util.JetsUtil" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*" %>

<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html charset=utf-8">
<TITLE>TSToolkit Demo</TITLE>
<link rel="stylesheet" href="../tradesign2.css" type="text/css">
<SCRIPT language="javascript">

	function ChkData()
	{
		if( document.myform.data.value == "" ){
			alert("HASH 할 원문 데이타를 입력하세요!");
			document.myform.data.focus();
			return false;
		}
		document.myform.submit();
	}
	
</SCRIPT>
</HEAD>
<BODY>
<%
	try{
		JeTS.installProvider("./tradesign3280.properties");
		
		// 원문 데이타	
		String data = new String(request.getParameter("data").getBytes("ISO-8859-1"), "UTF-8");
		
		// HASH 알고리즘
		String[] algs = {
			"MD5",
			"SHA-1",
			"HAS160"
		};
	
%>
<form name="myform">
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 원문데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="data" rows="6" cols="90" ><%= data %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" onClick="JavaScript:ChkData()" Value="Hash" style="width:150"  >
    </td>
  </tr>
</table>
<%
		for (int i = 0; i < algs.length; i++)
		{
			MessageDigest md = MessageDigest.getInstance(algs[i], "JeTS");
			byte[] result = md.digest(data.getBytes());
			String HashStr = new String(JetsUtil.encodeBase64(result));
%>		
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 해쉬알고리즘: <%= algs[i] %>&nbsp;&nbsp; &nbsp; HASH 데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="plainText" rows="6" cols="90" ><%= HashStr %></textarea>
    </td>
</tr>
</table>
<%
    	}

	}//end of try
	catch(Exception e)
	{
		e.printStackTrace();
		String ret = e.getMessage();
		out.print("에러 : " + ret);
	}
%>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="right">
      <INPUT TYPE="button" Value="화면 지우기" onClick="location.href='./StringHash.html'">
    </td>
  </tr>
</table>
</form>
</BODY>
</HTML>

