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
					alert("서명할 원문 데이타를 입력해 주세요!");
					return false;
				}
				
				return true;
			}
			
			function Verifychk()
			{
				if( document.getElementById("plainText").value == "" || document.getElementById("signdata").value == ""){
					alert("서명할 원문 데이타를 입력후 서명 하신후 검증해 주세요");
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
					<asp:ListItem Value="1">서명만 검증</asp:ListItem>
					<asp:ListItem Value="2">CRL을 통한 인증서 검증 포함</asp:ListItem>
        		  </asp:DropDownList>

				  </td>
				</tr>
			</table>		
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== 서명될 원문 데이타를 입력하세요 ==</font></td>
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
						<asp:button id="Signbtn" runat="server" Width="150" Text="서명하기"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== 서명된 데이타 ==</font></td>
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
						<asp:button id="Verifybtn" runat="server" Width="150" Text="검증하기"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== 서명 검증 후 나온 원문 데이타 ==</font></td>
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
						<asp:button id="Resetbtn" runat="server" Width="150" Text="화면 지우기"></asp:button>
					</td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="3" cellspacing="0">
				<tr>
					<td align="center"><b>인증서 정보</b></td>
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
