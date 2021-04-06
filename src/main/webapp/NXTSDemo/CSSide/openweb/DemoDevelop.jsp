<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tradesign.crypto.provider.JeTS" %>
<%@ page import="tradesign.pki.util.JetsUtil" %>
<%@ page import="tradesign.pki.pkix.EnvelopedData" %>
<%@ page import="tradesign.pki.pkix.RecipientInfo" %>
<%@ page import="tradesign.pki.pkix.X509Certificate" %> 
<%@ page import="tradesign.pki.util.JetsUtil" %>
<%@ page import="tradesign.test.*" %>
<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*" %>

<html>
<head>
<link rel="stylesheet" href="../../tradesign2.css" type="text/css">
</head>
<body>
<div class="main">

<% 
    try{
		JeTS.installProvider("./tradesign3280.properties");
        
        // 원문 데이타   
        String plaintext = new String(request.getParameter("plainText").getBytes("ISO-8859-1") , "utf-8");
        
        // envelop 데이타  
        String envdata = new String(request.getParameter("envdata").getBytes("ISO-8859-1"));        
        
        String Strorg_msg = "";
    
	
		byte[] cert = JeTS.getServerkmCert(0);
		
		X509Certificate c = new X509Certificate(cert);
		System.out.println(c.getSubjectDNStr());
		
		String certPwd = JeTS.getServerKmKeyPassword(0);
		byte[] certPriv = JeTS.getServerkmPriKey(0);


        String b64message = request.getParameter("envdata");
        byte[] message = JetsUtil.base64ToBytes(b64message);
        /*
        FileOutputStream fos = new FileOutputStream("c:/env_data.ber");
        fos.write(message); fos.close();
        */
        
        EnvelopedData ed = new EnvelopedData(message);
    
        //전자봉투 데이타 해독
        ed.setupCipher(cert, certPriv, certPwd);
    
        // 원문추출
        byte[] content = ed.getContent();
        
        Strorg_msg = new String(content);


     
     
%>

<form name="myform">
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== envelop 데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="envdata" rows="6" cols="90" ><%= envdata %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" onClick="JavaScript:signdatachk()" Value="서버 Develop 하기" style="width:150">
    </td>
  </tr>
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 서버 Develop 후 나온 원문데이타 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="devText" rows="6" cols="90" ><%= Strorg_msg %></textarea>
    </td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" Value="화면 지우기" onClick="location.href='./DemoEnvelop.jsp'">
    </td>
  </tr>
  
</table>
<table border="0" width="670" cellpadding="3" cellspacing="0" >
  <tr>
    <td align="left">
<%
        RecipientInfo[] r = ed.getRecipients();
        
        if (r != null)
        {
            for (int i = 0 ; i < r.length; i++)
            {
                ArrayList ar = r[i].getIssuerAndSerial();
                if (ar != null)
                {   
                    out.println("  수신자 " + (i+1) + r[i].getIssuerAndSerialNumber());
                }
            }
        }   
%>
    </td>
</tr>
</table>

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
</div>
  </body>
  </html>
  
  
