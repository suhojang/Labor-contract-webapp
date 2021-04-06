<%@ Page language="c#" Codebehind="CheckVID.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.CheckVID" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE></TITLE>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link rel="stylesheet" href="../tradesign2.css" type="text/css">
		<SCRIPT language="javascript">
	
			function signfilechk()
			{	
				if( document.getElementById("ssn").value == "" ){
					alert("사업자(주민등록)번호를 입력하세요!");
					document.getElementById("ssn").focus();
					return false;
				}
				
				return true;
			}
			
		</SCRIPT>	
		
	</HEAD>
	<BODY>
		<P>
			<script language="javascript" src="../TSToolkitObject.js"></script>
			<form name="myform" method="post" enctype="multipart/form-data" runat="server">
				<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97a9bb" bgcolor="#a7b9cc">
					<tr>
						<td align="center"><font color="#ffffff">== 신원확인할 인증서와 신원확인 정보를 입력하세요 ==</font></td>
					</tr>
				</table>
				<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">

					<tr>
						<td align="center">
							<b>확인할 서버 인증서의 사업자(주민등록)번호 :
								<asp:textbox id="ssn" runat="server" Width="150px" MaxLength="30" BorderStyle="Solid"></asp:textbox>'-' 
								없이 입력하세요.</b>
						</td>
					</tr>
					<tr>
						<td align="left">
							<asp:button id="Checkbtn" runat="server" Width="150" Text="인증서 신원확인"></asp:button>
						</td>
					</tr>
					<tr>
						<td align="left">
							<asp:Label id="checkMsg" runat="server" />
						</td>
					</tr>
					<tr>
						<td align="right">
							<INPUT TYPE="reset" name="Clear" Value="화면 지우기" style="WIDTH:150px">
						</td>
					</tr>
				</table>
			</form>
		</P>
	</BODY>
</HTML>
