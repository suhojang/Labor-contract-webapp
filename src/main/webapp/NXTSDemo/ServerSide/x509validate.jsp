<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="tradesign.crypto.provider.*"%>
<%@ page import="tradesign.pki.pkix.X509Certificate"%>
<%@ page import="tradesign.pki.pkix.X509CRL"%>
<%@ page import="tradesign.pki.pkix.OCSP"%>
<%@ page import="tradesign.crypto.cert.*" %>
<%@ page import="tradesign.crypto.cert.validator.*" %>
<%@ page import="java.security.cert.CertPathValidator" %>
<%@ page import="java.security.cert.PKIXCertPathValidatorResult" %>

<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*"%>

<html>
<link rel="stylesheet" href="../tradesign2.css" type="text/css">
<meta http-equiv="content-type" content="text/html; charset=utf-8"> 
<body>

<%

	String ret = "검증성공";
	String dn = null;
	Date revD = null;
	String revReason = null;
	boolean r = false;
	int ocspret = 0;

	try{
		JeTS.installProvider("./tradesign3280.properties");

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

		//JeTS.getServerkmPriKey();
		
		//사용자 인증서
		X509Certificate cert = new X509Certificate(der);
		
		// 인증서 dn 구하기
		String DnStr = cert.getSubjectDNStr();

		PKIXCertPath cp = new PKIXCertPath(cert, "PkiPath");
		ExtendedPKIXParameters cpp = new ExtendedPKIXParameters(JeTS.getTAnchorSet());
		CertPathValidator cpvi = CertPathValidator.getInstance("PKIX","JeTS");
		PKIXCertPathValidatorResult cpvr = (PKIXCertPathValidatorResult) cpvi.validate(cp, cpp);
		
		
		// 검증 결과 VerifyStr 에 할당
		String VerifyStr = cpvr.toString();
		
		// OCSP 검증 테스트
		//OCSP ocsp = new OCSP(der);
					
		//System.out.println(" OCSP 연결정보:" + ocsp.getOCSPURL());

		//ocsp.requestOCSP(false);
				
		//ocspret  = ocsp.getCertStatus();
		
		// 폐지 사유 체크
		String Expstr = "";
		if (r)
			Expstr = (revReason == null) ? revReason : "없음";
		
		
		// OCSP 폐지여부 체크
		String ocspchk = "", ocspexp ="", ocspexpres = "";
		
		/* 
		  OCSP 체크 관련 주석 처리..
		
		//OCSP 폐지일
		ocspexp = ocsp.getRevokedDate();
		
		//OCSP 폐지사유
		ocspexpres = ocsp.getRevokedReason();
		
		if (ocspret == OCSP.STATUS_GOOD) ocspchk = "good";
		else if (ocspret == OCSP.STATUS_REVOKED){
			ocspchk = "revoked";
			ocspexp = ocsp.getRevokedDate();
			ocspexpres = ocsp.getRevokedReason();
		}
		else if (ocspret == OCSP.STATUS_UNKNOWN) ocspchk = "UNKNOWN";
		*/
			
%>


<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">==   인증서 검증 결과    ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="plainText" rows="18" cols="90" ><%=  VerifyStr %></textarea>
    </td>
</tr>
<tr>
	<td>DN : <%=  DnStr %></td>
</tr>

<tr>
	<td>OCSP 폐지여부 : <%=  ocspchk %></td>
</tr>
<%
    if (ocspret == OCSP.STATUS_REVOKED){
%>
	<td>OCSP 폐지일 : <%=  ocspexp %> OCSP 폐지사유 : <%= ocspexpres %></td>     
<%    }    %>
</table>

<%

}//end of try
catch(Exception e){
    e.printStackTrace();
	ret = "<text>검증실패:<br>" + e.getMessage() + "</text>";
	out.print(ret);
}
%>

