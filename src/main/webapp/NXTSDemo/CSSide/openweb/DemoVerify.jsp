<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tradesign.crypto.provider.*" %>
<%@ page import="tradesign.pki.pkix.X509Certificate" %> 
<%@ page import="tradesign.pki.pkix.X509CRL" %>
<%@ page import="tradesign.pki.pkix.SignedData" %>
<%@ page import="tradesign.pki.util.JetsUtil" %>

<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*" %>

<html>
<link rel="stylesheet" href="../../tradesign2.css" type="text/css">
<body>

<%	
    /*
     이 스크립트는 demosign.html 로부터 수신한 서명데이터(SignedData)에 대해서 서명검증/해석을 수행합니다.
     서명데이터는 Base64인코딩된 텍스트형태이기때문에 스트링으로 넘겨받습니다.
    */


	// DemoSign.htm 로부터 수신한 서명데이터(SignedData)를 스트링으로 받습니다.
	String message = new String(request.getParameter("data1").getBytes("ISO-8859-1"), "utf-8");
	
	
	// 인증서 검증 포함 여부 체크
	String VerifyType = request.getParameter("certVerifyType");

     // TradeSign PKIT 툴킷 사용을 위해 프로바이더를 등록합니다.
	JeTS.installProvider("./tradesign3280.properties");
	
	// 서명데이터(SignedData)는 바이너리형태이지만, 송수신을 위해 Base64인코딩되어 텍스트형태로 변환되어 있습니다.
	// 이를 다시 Base64디코딩을 통해 원형으로 복구합니다.		
	
	byte[] content = JetsUtil.base64ToBytes(message);

	// 위에서 디코딩되어 복원된 서명데이터를 서명검증/해석하기 위해 SignData를 선언한다.
	String ret = null;
	
	String expyn[] = null;
	String expday[] = null;
	String expreason[] = null; 
	String CertDn[] = null; 
	String IssuerDn[] = null; 
	
	try {
		SignedData sd =  new SignedData(content);        
		
		String plaintext = new String(sd.getContent());
		                
		X509Certificate[] certs = sd.verify();
		
		expyn  = new String[certs.length];
		expday  = new String[certs.length];
		expreason  = new String[certs.length];
		CertDn  = new String[certs.length];
		IssuerDn  = new String[certs.length];
			
		for (int i = 0; i < certs.length; i++)
		{
		    // crl 통한 검증 포함
			if (VerifyType.equals("2"))
			{
				X509CRL crl = new X509CRL(certs[i].getCrlDp(), true);
				boolean r= crl.isRevoked(certs[i].getSerialNumber());
				
				if(r){
					expyn[i] = "폐지됨";
					expday[i] = crl.getRevokedDate().toString();
					if( crl.getRevokedReason() == null ) expreason[i] = "없음";
					else expreason[i] = crl.getRevokedReason();
					
				}	
				else{
					expyn[i] = "유효함";
				}	
		
			}
			
			CertDn[i] = certs[i].getSubjectDNStr();
			IssuerDn[i] = certs[i].getIssuerDNStr();
			
		}	
		
		// 서명 시각
		String SignTime = sd.getSigningTime().toString();
		
		
%>
<form name="myform">
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 서버 검증후 나온 원문데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="plainText" rows="6" cols="90" ><%= plaintext %></textarea>
    </td>
</tr>
</table>

<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
<%
	for (int i = 0; i < CertDn.length; i++)
	{
		out.print("<tr><td align='left'><b>서명자 : "+ CertDn[i] + "</b></td></tr>");
		out.print("<tr><td align='left'><b>발급자 : "+ IssuerDn[i] + "</b></td></tr>");
	}	
%>
	<tr>
		<td align='left'><b>서명시각 : <%= SignTime %></b></td>
	</tr>
<%
    	
	if (VerifyType.equals("2"))
	{
		for (int i = 0; i < CertDn.length; i++)
		{
			out.print("<tr><td align='left'><b>폐지여부 : "+ expyn[i] + "</b></td></tr>");
			out.print("<tr><td align='left'><b>폐지일 : "+ expday[i] + "</b></td></tr>");
			out.print("<tr><td align='left'><b>폐지사유 : "+ expreason[i] + "</b></td></tr>");
		}
	}
%>
    	
  <tr>
    <td align="right">
      <INPUT TYPE="button" Value="이전으로" onClick="location.href='./DemoSign.jsp'">
    </td>
  </tr>	
</table>

<%
	}
	catch (Exception e) {
	e.printStackTrace();
	ret = e.getMessage();
	out.print("에러 : " + ret);
}
%>
