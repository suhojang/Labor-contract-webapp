<%@ Page language="c#" Codebehind="StringBase64.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.StringBase64" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE></TITLE>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link rel="stylesheet" href="../tradesign2.css" type="text/css">
		
		<SCRIPT language="javascript">
	
			function signfilechk()
			{
				if( document.getElementById("data").value == "" ){
					alert("Base64 Encoding 할 데이타를 입력하세요!");
					return false;
				}
				
				return true;
			}
			
			function Verifychk()
			{
				if( document.getElementById("data").value == "" || document.getElementById("Base64encdata").value == ""){
					alert("Base64 Encoding 할 데이타를 입력후 Encoding 하신후 Decoding 해 주세요");
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
		<form name="myform" runat="server">
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== Base64 Encoding 할 데이타를 입력하세요 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="data" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Base64encbtn" runat="server" Width="150" Text="Base64 Encoding"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== Base64 Encoding 된 데이타 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="Base64encdata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
					</td>
				</tr>
				<tr>
					<td align="left">
						<asp:button id="Base64decbtn" runat="server" Width="150" Text="Base64 Decoding"></asp:button>
					</td>
				</tr>
			</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#fffff">== Base64 Decoding 된 데이타 ==</font></td>
				</tr>
			</table>
			<table border="2" width="600" cellpadding="5" cellspacing="0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="Base64decdata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
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
