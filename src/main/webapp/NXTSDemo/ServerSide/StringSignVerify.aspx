<%@ Page language="c#" Codebehind="StringSignVerify.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.StringSignVerify" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE></TITLE>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<LINK rel="stylesheet" href="../tradesign2.css" type="text/css">
			<SCRIPT language="javascript">
	
			function plainTextchk()
			{
				if( document.getElementById("plainText").value == "" ){
					alert("������ ���� ����Ÿ�� �Է��� �ּ���!");
					return false;
				}
				
				return true;
			}
			
			function Verifychk()
			{
				if( document.getElementById("plainText").value == "" || document.getElementById("signdata").value == ""){
					alert("������ ���� ����Ÿ�� �Է��� ���� �Ͻ��� ������ �ּ���");
					return false;
				}
				
				return true;
			}
			
			</SCRIPT>
	</HEAD>
	<BODY>
		<form name="myform" method="post" runat="server" ID="Form1">
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
				  <td align="center">
		
				 <asp:DropDownList ID=ListBox1 Runat=server AutoPostBack="True">
					<asp:ListItem Value="1">���� ����</asp:ListItem>
					<asp:ListItem Value="2">CRL�� ���� ������ ���� ����</asp:ListItem>
        		  </asp:DropDownList>

				  </td>
				</tr>
			</table>		
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== ����� ���� ����Ÿ�� �Է��ϼ��� ==</font></td>
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
						<asp:button id="Signbtn" runat="server" Width="150" Text="�����ϱ�"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== ����� ����Ÿ ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="signdata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Verifybtn" runat="server" Width="150" Text="�����ϱ�"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== ���� ���� �� ���� ���� ����Ÿ ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="Verifydata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="right">
						<asp:button id="Resetbtn" runat="server" Width="150" Text="ȭ�� �����"></asp:button>
					</td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="3" cellspacing="0">
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
