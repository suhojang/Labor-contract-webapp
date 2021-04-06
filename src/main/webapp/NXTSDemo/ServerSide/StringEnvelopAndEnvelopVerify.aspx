<%@ Page language="c#" Codebehind="StringEnvelopAndEnvelopVerify.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.StringEnvelopAndEnvelopVerify" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE></TITLE>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link rel="stylesheet" href="../tradesign2.css" type="text/css">
		<SCRIPT language="javascript">
	
			function signfilechk()
			{
				if( document.getElementById("plainText").value == "" ){
					alert("Envelop 할 데이타를 입력해 주세요!");
					return false;
				}
				
				return true;
			}
			
			function Verifychk()
			{
				if( document.getElementById("plainText").value == "" || document.getElementById("Envelopdata").value == ""){
					alert("Envelop 할 데이타를 입력후 Develop 해 주세요");
					return false;
				}
				
				return true;
			}
			
		</SCRIPT>		
	</HEAD>
	<BODY>
		<P>
			<script language="javascript" src="../TSToolkitObject.js"></script>
		</P>
		<form name="myform" runat="server" ID="Form1">
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== Envelop 될 원문 데이타를 입력하세요 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="plainText" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Envelopbtn" runat="server" Width="150" Text="Envelop 하기"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== EnvelopedData ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="Envelopdata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Developbtn" runat="server" Width="150" Text="Develop 하기"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== Develop 후 나온 원문데이타 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="Developdata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="right">
						<asp:button id="Resetbtn" runat="server" Width="150" Text="화면 지우기"></asp:button>
					</td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>
