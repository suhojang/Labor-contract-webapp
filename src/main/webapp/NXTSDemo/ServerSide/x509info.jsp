<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tradesign.crypto.provider.JeTS" %>
<%@ page import="tradesign.crypto.cert.*" %>
<%@ page import="tradesign.pki.pkix.*" %> 
<%@ page import="tradesign.pki.pkix.SignedData" %> 
<%@ page import="tradesign.pki.pkix.X509Certificate" %> 
<%@ page import="java.security.cert.CertificateNotYetValidException" %> 
<%@ page import="java.security.cert.CertificateExpiredException" %> 
<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*" %>

<html>
<link rel="stylesheet" href="../tradesign2.css" type="text/css">
<body>

<%
    
	try{
		JeTS.installProvider("./tradesign3280.properties");

		int certver;
		String certexpstart = "", certexpend = "", certvalidity="", certserial = "", certdn = "", certissuerdn="", certsignalg = "";
		String crldp = "", cpsuri = "", certoid = "", certaia = "", certalt = "";
		
		/* 사용자 인증서 파일 업로드 및 파싱후 byte[] der 에 할당 - 시작	*/
		String contentType = request.getContentType();
			
		DataInputStream in = new DataInputStream(request.getInputStream());
		int formDataLength = request.getContentLength();
        
		byte dataBytes[] = new byte[formDataLength];
			
		int byteRead = 0;
		int totalBytesRead = 0;
			
		while (totalBytesRead < formDataLength) {
			byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
			totalBytesRead += byteRead;
		}
        
		String file = new String(dataBytes);
        
		int lastIndex = contentType.lastIndexOf("=");
		String boundary = contentType.substring(lastIndex + 1,contentType.length());
        
		int pos;
		pos = file.indexOf("filename=\"");
		pos = file.indexOf("\n", pos) + 1;
		pos = file.indexOf("\n", pos) + 1;
		pos = file.indexOf("\n", pos) + 1;
        
		int boundaryLocation = file.indexOf(boundary, pos) - 4;
		int startPos = ((file.substring(0, pos)).getBytes()).length;
		int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;
			
		byte[] der = new byte[endPos - startPos];
			
		System.arraycopy(dataBytes, startPos, der , 0, (endPos - startPos)); 	
		
		/* 사용자 인증서 파일 업로드 및 파싱후 byte[] der 에 할당 - 끝	*/ 
				
		tradesign.pki.pkix.X509Certificate cert = new tradesign.pki.pkix.X509Certificate (der);
		
		//버전
		certver = cert.getVersion();
		//유효기간시작일
		certexpstart = cert.getNotBefore().toString();
		//유효기간종료일
		certexpend = cert.getNotAfter().toString();	
		
		//유효성 여부
		try {
			cert.checkValidity();
			certvalidity = "유효함";
		}
		catch(CertificateNotYetValidException e1) {
			certvalidity = "유효기간 전임";
		}
		catch(CertificateExpiredException e2) {
			certvalidity = "유효기간 만료";
		}	
		
		// 시리얼넘버
		certserial = cert.getSerialNumber().toString();
		// 사용자DN
		certdn = cert.getSubjectDN().toString();
		//발급자DN
		certissuerdn = cert.getIssuerDN().toString();
		// 서명알고리즘
		certsignalg = cert.getSignatureAlgorithm().toString();	
		// CRL DP
		crldp = cert.getCrlDp();
		// CPSUri
		cpsuri = cert.getCpsUri().toString();
		// Policy OID 
		certoid = cert.getOids().toString();	
		// AIA
		certaia = cert.getAia().toString();
		// SubjectAltName
		certalt = cert.getSubjectAltName().toString();
			
		// 키용도
		boolean[] ku = cert.getKeyUsage();
		

%>

<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">==   인증서 정보    ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">

<tr>
	<td>버전 : <%=  certver %></td>
</tr>

<tr>
	<td>유효기간시작일 : <%=  certexpstart %></td>
</tr>

<tr>
	<td>유효기간종료일 : <%=  certexpend %></td>
</tr>

<tr>
	<td>유효성 여부 : <%= certvalidity %>
	</td>
</tr>
<tr>
	<td>시리얼넘버 : <%=  certserial %></td>
</tr>

<tr>
	<td>사용자DN : <%=  certdn %></td>
</tr>

<tr>
	<td>발급자 : <%=  certissuerdn %></td>
</tr>

<tr>
	<td>서명알고리즘 : <%=  certsignalg %></td>
</tr>

<tr>
	<td>키용도 : 		<br>
	    digitalSignature :<%= ku[0] %> <br>
		nonRepudation :<%= ku[1] %> <br>
		keyEncipherment :<%= ku[2] %> <br>
		dataEncipherment :<%= ku[3] %> <br>
		keyAgreement :<%= ku[4] %> <br>
		keyCertSign :<%= ku[5] %> <br>
		cRLSign :<%= ku[6] %> <br>
		encipherOnly :<%= ku[7] %> <br>
		decipherOnly :<%= ku[8] %> <br></td>
</tr>
<tr>
	<td>CRL DP : <%=  crldp %></td>
</tr>
<tr>
	<td>CPSUri : <%=  cpsuri %></td>
</tr>
<tr>
	<td>Policy OID : <%=  certoid %></td>
</tr>
<tr>
	<td>AIA : <%=  certaia %></td>
</tr>
<tr>
	<td>SubjectAltName : <%=  certalt %></td>
</tr>
<tr>
	<td>인증서 전체 정보  : <textarea name="plainText" rows="10" cols="90" ><%= cert %></textarea></td>
</tr>

</table>
<%
} catch(Exception e) {
	e.printStackTrace();
	out.println("에러 발생11:" + e.getMessage() + "<br>");
}
%>
  </body>
  </html>
  
