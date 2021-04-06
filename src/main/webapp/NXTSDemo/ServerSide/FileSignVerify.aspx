<%@ Page language="c#" Codebehind="FileSignVerify.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.FileSignVerify" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE></TITLE>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link rel="stylesheet" href="../tradesign2.css" type="text/css">
		<SCRIPT language="javascript">
	
			function signfilechk()
			{
				if( document.getElementById("signfile").value == "" ){
					alert("������ ���� ������ ������ �ּ���!");
					return false;
				}
				
				return true;
			}
			
			function Verifychk()
			{
				if( document.getElementById("plaindata").value == "" || document.getElementById("signdata").value == ""){
					alert("������ ���� ����Ÿ�� �Է��� ���� �Ͻ��� ������ �ּ���");
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
					<td align="center"><font color="#ffffff">== ������ ������ �����ϼ��� ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<input type="file" id="signfile" name="signfile" size="45" runat="server">
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Signbtn" runat="server" Width="150" Text="Sign File"></asp:button>
					</td>
				</tr>
				
				<tr>
					<td align="left">
						<asp:Label id="signmsg" runat="server"></asp:Label>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== ���� ���� ���� ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="plaindata" runat="server" Width="580px" Rows="6" BorderStyle="Solid" TextMode="MultiLine" readonly></asp:textbox>
					</td>
				</tr>
			</table>
            <table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== ���� �� ���� ���� ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="signdata" runat="server" Width="580px" Rows="6" BorderStyle="Solid" TextMode="MultiLine" readonly></asp:textbox>
					</td>
					
				</tr>
				
			</table>	
			<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				
				<tr>
					<td align="left">
						<asp:button id="Verifybtn" runat="server" Width="150" Text="Verify File"></asp:button>
					</td>
				</tr>
			</table>						
			
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== ���� ���� ������ ���� ���� ����Ÿ ���� ==</font></td>
				</tr>
			</table>
						<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="verifydata" runat="server" Width="580px" Rows="6" BorderStyle="Solid" TextMode="MultiLine" readonly></asp:textbox>
					</td>
					
				</tr>
				<tr>
					<td align="right">
						<asp:button id="Resetbtn" runat="server" Width="150" Text="ȭ�� �����"></asp:button>
					</td>
				</tr>
				
			</table>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" >
				<tr>
					<td align="center"><b>������ ����</b></td>
				</tr>
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
