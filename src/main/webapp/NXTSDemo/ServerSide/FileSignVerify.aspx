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
					alert("서명할 원문 파일을 선택해 주세요!");
					return false;
				}
				
				return true;
			}
			
			function Verifychk()
			{
				if( document.getElementById("plaindata").value == "" || document.getElementById("signdata").value == ""){
					alert("서명할 원문 데이타를 입력후 서명 하신후 검증해 주세요");
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
					<td align="center"><font color="#ffffff">== 서명할 파일을 선택하세요 ==</font></td>
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
					<td align="center"><font color="#ffffff">== 원본 파일 내용 ==</font></td>
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
					<td align="center"><font color="#ffffff">== 서명 한 파일 내용 ==</font></td>
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
					<td align="center"><font color="#ffffff">== 파일 서명 검증후 나온 원문 데이타 파일 ==</font></td>
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
						<asp:button id="Resetbtn" runat="server" Width="150" Text="화면 지우기"></asp:button>
					</td>
				</tr>
				
			</table>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" >
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
