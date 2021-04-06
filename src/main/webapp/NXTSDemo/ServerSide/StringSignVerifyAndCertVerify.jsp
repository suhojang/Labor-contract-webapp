<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tradesign.crypto.provider.JeTS" %>
<%@ page import="tradesign.crypto.cert.*" %>
<%@ page import="tradesign.pki.pkix.SignedData" %> 
<%@ page import="tradesign.pki.pkix.X509Certificate" %> 
<%@ page import="tradesign.pki.pkix.*" %> 
<%@ page import="tradesign.pki.util.JetsUtil" %>
<%@ page import="tradesign.crypto.cert.validator.PKIXCertPath" %>
<%@ page import="tradesign.crypto.cert.validator.ExtendedPKIXParameters" %>
<%@ page import="java.security.cert.CertPathValidator" %>
<%@ page import="java.security.cert.PKIXCertPathValidatorResult" %>
<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*" %>

<%
	try{
		
		JeTS.installProvider("./tradesign3280.properties");
		
		// 서명할 원문 데이타
		String plaintext = new String(request.getParameter("plainText").getBytes("ISO-8859-1"), "UTF-8");
		
		// 서명, 검증 모드 설정
		String Signmode = request.getParameter("mode");
		
		String Strsigned_msg = "", Strveryfi_msg = "", SignTime ="";
		
		String CertDn[] = null; 
		String Strcpvr[] = null;
		
		if( Signmode.equals("sign")){
		
			// 서명 암호화
			SignedData sd = new SignedData(plaintext.getBytes(), true);	
			
			sd.setsignCert(JeTS.getServerSignCert(0), JeTS.getServerSignPriKey(0), JeTS.getServerSignKeyPassword(0));
			byte[] signed_msg = sd.sign();
			
			X509Certificate[] certs = sd.verify();
			
			CertDn  = new String[certs.length];
			
			for (int i = 0; i < certs.length; i++)
			{
				CertDn[i] = certs[i].getSubjectDNStr();
			}
			
			Strsigned_msg = new String(JetsUtil.encodeBase64(signed_msg));
			
		}
		
		else if (Signmode.equals("verify")){
		
			// 서명 검증
			Strsigned_msg = new String(request.getParameter("signdata").getBytes("ISO-8859-1"));
			
			byte[] signed_msg = JetsUtil.decodeBase64(request.getParameter("signdata").getBytes("ISO-8859-1"));
			
			SignedData sd = new SignedData(signed_msg);
			
			byte[] veryfi_msg = sd.getContent();
			Strveryfi_msg = new String(veryfi_msg);
			
			X509Certificate[] certs = sd.verify();
			
			CertDn  = new String[certs.length];
			Strcpvr  = new String[certs.length];
			
			for (int i = 0; i < certs.length; i++)
			{
				CertDn[i] = certs[i].getSubjectDNStr();
				
				PKIXCertPath cp = new PKIXCertPath(certs[i], "PkiPath");
				ExtendedPKIXParameters cpp = new ExtendedPKIXParameters(JeTS.getTAnchorSet());
				CertPathValidator cpvi = CertPathValidator.getInstance("PKIX","JeTS");
				PKIXCertPathValidatorResult cpvr = (PKIXCertPathValidatorResult) cpvi.validate(cp, cpp);
						
				Strcpvr[i] = cpvr.toString();
				
			}
			
			// 서명 시각
			SignTime = "서명시각 : " + sd.getSigningTime().toString();
		
		}
%>

<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html charset=utf-8">
<TITLE>TSToolkit Demo</TITLE>
<link rel="stylesheet" href="../tradesign2.css" type="text/css">
<SCRIPT language="javascript">

	function plainTextchk()
	{
		
		if( document.myform.plainText.value == "" ){
			alert("서명할 원문 데이타를 입력하세요!");
			document.myform.plainText.focus();
			return false;
		}
		
		document.myform.mode.value ="sign";
		document.myform.action="StringSignVerifyAndCertVerify.jsp";
		document.myform.method="post";
		document.myform.submit();

	}
	function signdatachk()
	{
		if( document.myform.plainText.value == "" || document.myform.signdata.value == ""){
		
			alert("서명할 원문 데이타를 입력후 서명 하신후 검증해 주세요");
			return false;
		}
		
		
		document.myform.mode.value ="verify";
		document.myform.action="StringSignVerifyAndCertVerify.jsp";
		document.myform.method="post";
		document.myform.submit();
		
	}	
</SCRIPT>
</HEAD>
<BODY>
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
      <INPUT TYPE="button" onClick="JavaScript:plainTextchk()" Value="서명하기" style="width:150">
    </td>
  </tr>
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 서명데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="signdata" rows="6" cols="90" ><%= Strsigned_msg %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" onClick="JavaScript:signdatachk()" Value="검증하기" style="width:150">
    </td>
  </tr>
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 서명 검증 후 나온 원문 데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="verify_msg" rows="6" cols="90" ><%= Strveryfi_msg %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" Value="화면 지우기" onClick="location.href='./StringSignVerifyAndCertVerify.html'">
    </td>
  </tr>
</table>

<table border="0" width="670" cellpadding="3" cellspacing="0" >
  <tr><td align="left"><b><%= SignTime %></b></td></tr>
</table>

<table border="0" width="670" cellpadding="3" cellspacing="0" >
<%
	for (int i = 0; i < CertDn.length; i++)
	{
		out.print("<tr><td align='left'><b>인증서DN : "+ CertDn[i] + "</b></td></tr>");
	}	
%>
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 검증결과 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
<%
	if (Signmode.equals("verify")){

		for (int i = 0; i < Strcpvr.length; i++)
		{
			out.print("<textarea name='signedData' rows='10' cols='90'>"+ Strcpvr[i] +"</textarea>");
		}
	}	
%>
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
