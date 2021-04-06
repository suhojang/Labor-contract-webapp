<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tradesign.crypto.provider.JeTS" %>
<%@ page import="tradesign.crypto.cert.*" %>
<%@ page import="tradesign.pki.pkix.EnvelopedData" %> 
<%@ page import="tradesign.pki.pkix.X509Certificate" %> 
<%@ page import="tradesign.pki.util.JetsUtil" %>
<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*" %>

<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html charset=utf-8">
<TITLE>TSToolkit Demo</TITLE>
<link rel="stylesheet" href="../tradesign2.css" type="text/css">
<SCRIPT language="javascript">

	function plainTextchk()
	{
		
		if( document.myform.plainText.value == "" ){
			alert("Envelop할 원문 데이타를 입력하세요!");
			document.myform.plainText.focus();
			return false;
		}
		
		document.myform.mode.value ="envelop";
		document.myform.action="StringEnvelopAndEnvelopVerify.jsp";
		document.myform.method="post";
		document.myform.submit();

	}
	function signdatachk()
	{
		if( document.myform.plainText.value == "" || document.myform.envText.value == ""){
		
			alert("Envelop할 원문 데이타를 입력후 Envelop 하신후 검증해 주세요");
			return false;
		}
		
		document.myform.mode.value ="develop";
		document.myform.action="StringEnvelopAndEnvelopVerify.jsp";
		document.myform.method="post";
		document.myform.submit();
	}	
</SCRIPT>
</HEAD>
<BODY>

<%
	try{
		JeTS.installProvider("./tradesign3280.properties");
		
		// 원문 데이타	
		String plaintext = new String(request.getParameter("plainText").getBytes("ISO-8859-1"), "UTF-8");
		
		String Signmode = request.getParameter("mode");
		
		String Strenv_msg = "", Strdev_msg = "";
		
		if( Signmode.equals("envelop")){
				
			//EnvelopedData 객체 생성
			EnvelopedData ed = new EnvelopedData(plaintext.getBytes(), null);

			// 수신자의 인증서 설정
			ed.addRecipient(JeTS.getServerkmCert(0));
		
			// byte[] 배열 형식의 envelope 데이타 생성
			byte[] env_msg = ed.envelop();
		
			//화면에 표시할 envelope 데이타
			Strenv_msg = new String(JetsUtil.encodeBase64(env_msg));
		}
		else{
			Strenv_msg = new String(request.getParameter("envText").getBytes("ISO-8859-1"));
			
			// Envelope 해제
			EnvelopedData ed = new EnvelopedData(JetsUtil.decodeBase64(Strenv_msg.getBytes()));
			
			// 수신자의 비밀키와 암호 설정
			ed.setupCipher(JeTS.getServerkmCert(0), JeTS.getServerkmPriKey(0), JeTS.getServerKmKeyPassword(0));

			// Devlope 후 원본데이타 추출
			byte[] dev_msg = ed.getContent();
		
			//화면에 표시할 devlope 데이타
			Strdev_msg = new String(dev_msg);
		}

%>
<form name="myform">
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 원문데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="plainText" rows="6" cols="90" ><%= plaintext %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" onClick="JavaScript:plainTextchk()" Value="Envelop 하기" style="width:150">
    </td>
  </tr>
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== envelope 데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="envText" rows="6" cols="90" ><%= Strenv_msg %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" onClick="JavaScript:signdatachk()" Value="Develop 하기" style="width:150">
    </td>
  </tr>
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== Develop 후 나온 원문데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="devText" rows="6" cols="90" ><%= Strdev_msg %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" Value="화면 지우기" onClick="location.href='./StringEnvelopAndEnvelopVerify.html'">
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
