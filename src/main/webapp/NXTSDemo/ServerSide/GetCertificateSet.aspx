<%@ Page language="c#" Codebehind="GetCertificateSet.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.GetCertificateSet" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 
<html>
<head>
<title>Lomboz JSP</title>
<link rel="stylesheet" href="../tradesign2.css" type="text/css">
<SCRIPT language=javascript src="../TSToolkitConfig.js"></script>
<SCRIPT language=javascript>
<!--

function GetCertificateSet(form)
{
	var nRet;
	var certdn, storage;
	
	// 모든 Condition 설정.
	nRet = TSToolkit.SetConfig("test", CA_LDAP_INFO, CTL_INFO, POLICIES, 
							INC_CERT_SIGN, INC_SIGN_TIME_SIGN, INC_CRL_SIGN, INC_CONTENT_SIGN,
							USING_CRL_CHECK, USING_ARL_CHECK);
	if (nRet > 0)
	{
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		return false;
	}
	
	nRet = TSToolkit.SetEncryptionAlgoAndMode(SYMMETRIC_ID_SEED, SYMMETRIC_MODE_CBC); 
	if (nRet > 0)
	{
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		return false;
	}

	nRet = TSToolkit.SelectCertificate(STORAGE_TYPE, 0, "");
	if (nRet > 0)
	{
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		return false;
	}
	
	nRet = TSToolkit.GetCertificate(CERT_TYPE_SIGN, DATA_TYPE_PEM);
	if (nRet > 0)
	{
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		return false;
	}
	form.signCert.value = TSToolkit.OutData;

	nRet = TSToolkit.GetPrivateKey(CERT_TYPE_SIGN, DATA_TYPE_PEM, "");
	if (nRet > 0)
	{
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		return false;
	}
	form.signPri.value =  TSToolkit.OutData;

	nRet = TSToolkit.GetCertificate(CERT_TYPE_KM, DATA_TYPE_PEM);
	if (nRet > 0)
	{
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		return false;
	}
	form.kmCert.value =  TSToolkit.OutData;

	nRet = TSToolkit.GetPrivateKey(CERT_TYPE_KM, DATA_TYPE_PEM, "");
	if (nRet > 0)
	{
		alert(nRet + " : " + TSToolkit.GetErrorMessage());
		return false;
	}
	form.kmPri.value =  TSToolkit.OutData;

	alert("Success!!");
}
-->
</script>
</head>
<body bgcolor="#FFFFFF">
<P>
<script language="javascript" src="../TSToolkitObject.js"></script>	
</P>
<form name="myForm"  runat="server">
<br>
<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">서명용 인증서 : <input type="text" name="signCert" size="80">
    </td>
  </tr>
  <tr>
    <td align="left">서명용 개인키 : <input type="text" name="signPri" size="80">
    </td>
  </tr>
  <tr>
    <td align="left">암호용 인증서 : <input type="text" name="kmCert" size="80">
    </td>
  </tr>
  <tr>
    <td align="left">암호용 개인키 : <input type="text" name="kmPri" size="80">
    </td>
  </tr>
  <tr><td><input type="button" name="test3" value="인증서 꺼내기" onclick="javascript:GetCertificateSet(myForm);"></td></tr>
  <tr><td align="right"><input type="reset" name="reset" value="화면 지우기"></td></tr>
</table>
</form>
</body>

</html>
