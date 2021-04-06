<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tradesign.crypto.provider.JeTS" %>
<%@ page import="tradesign.crypto.cert.*" %>
<%@ page import="tradesign.pki.pkix.*" %> 
<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*" %>

<%@ page import="com.jspsmart.upload.*" %>

<html>


<link rel="stylesheet" href="../tradesign2.css" type="text/css">


<body>

<%
    
	SmartUpload upload = new SmartUpload();
	upload.initialize(pageContext);
	upload.upload();
		
	com.jspsmart.upload.File file_der = upload.getFiles().getFile(0);
	
	byte[] der = new byte[file_der.getSize()];
	
	for(int i=0; i<file_der.getSize();i++){
		der[i] = file_der.getBinaryData(i);
	}
	  		
	try{
	JeTS.installProvider("./tradesign3280.properties");
	tradesign.pki.pkix.X509Certificate cert = new tradesign.pki.pkix.X509Certificate (der);
	String ssnumber = new String(request.getParameter("ssn").getBytes("ISO-8859-1"));
	boolean ret = cert.VerifyIDN(ssnumber, login1.getRandom());

%>

 <table width=600 cellspacing="2" cellpadding="2"  border="0" class="forumline">
 
 <tr>
 <td bgcolor=#336699 align=center colspan=2>
  <font color=white>신원확인 식별 예제</font>
</td></tr>
	<%
if (ret)
	out.print("신원확인 성공");
else
	out.print("신원확인 실패");
}
catch(CertificateNotYetValidException e1) {
	out.println("유효기간 전임");
}
catch(CertificateExpiredException e2) {
	out.println("유효기간 만료");
}
%></td></tr>

  </body>
  </html>
  
