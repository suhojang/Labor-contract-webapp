<%@ Page language="c#" Codebehind="StringEncryptAndDecrypt.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.StringEncryptAndDecrypt" %>
<HTML>
	<HEAD>
		<TITLE></TITLE>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link rel="stylesheet" href="../tradesign2.css" type="text/css">
		<SCRIPT language="javascript">
	
			function signfilechk()
			{
				if( document.getElementById("plainText").value == "" ){
					alert("Encrypt 할 데이타를 입력하세요!");
					return false;
				}
				
				return true;
			}
			
			function Verifychk()
			{
				if( document.getElementById("plainText").value == "" || document.getElementById("encdata").value == ""){
					alert("Encrypt 할 데이타를 입력후 Envelop 하신후 Decrypt 해 주세요");
					return false;
				}
				
				return true;
			}
			
		</SCRIPT>	
	</HEAD>
	<BODY>
		<P>
		</P>
		<form name="myform" runat="server">
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== 대칭키 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="keyPwd" runat="server" Width="300px" MaxLength="30" BorderStyle="Solid"  ></asp:textbox> 
					</td>
				</tr>
			</table>
			<br>
			<asp:Label id="lblMsg" runat="server" />
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== Encrypt 될 원문 데이타를 입력하세요 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="plainText" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Encryptbtn" runat="server" Width="150" Text="Encrypt 하기"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== EncryptedData ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="encdata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Decryptbtn" runat="server" Width="150" Text="Decrypt 하기"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== Decrypt 후 나온 원문데이타 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="decdata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
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
