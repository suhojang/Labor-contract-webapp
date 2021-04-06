<%@ Page language="c#" Codebehind="FileEncryptAndDecrypt.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.FileEncryptAndDecrypt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE></TITLE>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link rel="stylesheet" href="../tradesign2.css" type="text/css">
			<SCRIPT language="javascript">
	
			function plainTextchk()
			{
				if( document.getElementById("encfile").value == "" ){
					alert("Encrypt �� ������ �Է��� �ּ���!");
					return false;
				}
				
				return true;
			}
			
			function Verifychk()
			{
				if( document.getElementById("plaindata").value == "" || document.getElementById("enddata").value == ""){
					alert("Encrypt �� ������ �Է��� Encrypt �Ͻ��� �������ּ���!");
					return false;
				}
				
				return true;
			}
			
			function Test(){
				alert(document.getElementById("plainText").value);
				if(confirm("������ ��ǰ������ �����Ͻðڽ��ϱ�?"))
					return true;
				else
			return false;
			}
			</SCRIPT>
	</HEAD>
	<BODY>
		<form name="myform" method="post" enctype="multipart/form-data" runat="server">
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== Encrypt�� ������ �����θ� �Է��ϼ��� ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<input type="file" id="encfile" name="encfile" size="45" runat="server">
					</td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:button id="encbtn" runat="server" Width="150" Text="Encrypt File"></asp:button>
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:Label id="encmsg" runat="server"></asp:Label>
					</td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== ��ĪŰ ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="keyPwd" runat="server" Width="300px" MaxLength="30" BorderStyle="Solid"></asp:textbox>
					</td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== ���� ���� ���� ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="plaindata" runat="server" Width="580px" Rows="6" BorderStyle="Solid" TextMode="MultiLine"
							readonly></asp:textbox>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== Encrypt �� ���� ���� ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="encdata" runat="server" Width="580px" Rows="6" BorderStyle="Solid" TextMode="MultiLine"
							readonly></asp:textbox>
					</td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== Encrypt �� ������ ������� ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:button id="decbtn" runat="server" Width="150" Text="Decrypt File"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== Decrypt�� ���� ���� ����Ÿ ���� ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="decdata" runat="server" Width="580px" Rows="6" BorderStyle="Solid" TextMode="MultiLine"
							readonly></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="right">
						<asp:button id="Resetbtn" runat="server" Width="150" Text="ȭ�� �����"></asp:button>
					</td>
				</tr>
			</table>
		</form>
	</BODY>
</HTML>
