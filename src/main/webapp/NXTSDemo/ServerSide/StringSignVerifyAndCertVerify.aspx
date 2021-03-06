<%@ Page language="c#" Codebehind="StringSignVerifyAndCertVerify.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.StringSignVerifyAndCertVerify" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<HTML>
	<HEAD>
		<TITLE></TITLE>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link rel="stylesheet" href="../tradesign2.css" type="text/css">
	</HEAD>
	<BODY>

		<form name="myform" method="post" runat="server" ID="Form1">
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== 서명될 원문 데이타를 입력하세요 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="plainText" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
						<asp:RequiredFieldValidator id="Requiredfieldvalidator1" runat="server" ErrorMessage="* 서명될 원문 데이타를 입력해 주세요" ControlToValidate="plainText" Display="None"></asp:RequiredFieldValidator>
						
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Signbtn" runat="server" Width="150" Text="서명하기"></asp:button><asp:ValidationSummary runat="server" id="Validationsummary1" DisplayMode="List"></asp:ValidationSummary>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== 서명된 데이타 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="signdata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Verifybtn" runat="server" Width="150" Text="검증하기"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== 서명 검증 후 나온 원문 데이타 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="Verifydata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="right">
						<INPUT TYPE="reset" name="Clear" Value="화면 지우기" style="WIDTH:150px">
					</td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>