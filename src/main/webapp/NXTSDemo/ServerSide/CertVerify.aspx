<%@ Page language="c#" Codebehind="CertVerify.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.CertVerify" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE></TITLE>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link rel="stylesheet" href="../tradesign2.css" type="text/css">
		<SCRIPT language="javascript">
	
			function signfilechk()
			{
				if( document.getElementById("veryfifile").value == "" ){
					alert("신원확인할 인증서를 입력하세요!");
					return false;
				}
				
				return true;
			}
			
		</SCRIPT>	
	</HEAD>
	<BODY>
		
		<form name="myform" method="post" enctype="multipart/form-data" runat="server" ID="Form1">
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== 인증서 검증 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
				<td align="left">
					<input type="file" id="veryfifile" name="envfile" size="45"  runat="server" >
				</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="verifybtn" runat="server" Width="150" Text="인증서 검증"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" >
				<tr>
					<td align="left"><asp:Label id="SubjectDN" runat="server" /></td>
				</tr>
				<tr>
					<td align="left"><asp:Label id="SerialNumber" runat="server" /></td>
				</tr>
				<tr>
					<td align="left"><asp:Label id="CertPolicy" runat="server" /></td>
				</tr>
				<tr>
					<td align="left"><asp:Label id="IssuerDN" runat="server" /></td>
				</tr>
				<tr>
					<td align="left"><asp:Label id="ValidityBefore" runat="server" /></td>
				</tr>
				<tr>
					<td align="left"><asp:Label id="ValidityAfter" runat="server" /></td>
				</tr>
			</table>			
		</form>
	</BODY>
</HTML>
