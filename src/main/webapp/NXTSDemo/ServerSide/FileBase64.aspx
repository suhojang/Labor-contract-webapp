<%@ Page language="c#" Codebehind="FileBase64.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.FileBase64" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<TITLE></TITLE>
<link rel="stylesheet" href="../tradesign2.css" type="text/css">
		<SCRIPT language="javascript">
	
			function signfilechk()
			{
				if( document.getElementById("base64file").value == "" ){
					alert("Base64 인코딩 할 파일을 선택하세요!");
					return false;
				}
				
				return true;
			}
			
			function Verifychk()
			{
				if( document.getElementById("plaindata").value == "" || document.getElementById("b64data").value == ""){
					alert("Base64 인코딩 할 파일을 선택후 인코딩 하신후 디코딩 해 주세요");
					return false;
				}
				
				return true;
			}
			
		</SCRIPT>	
</HEAD>
<BODY>
<form name="myform" method="post" enctype="multipart/form-data" runat="server" ID="Form1">
<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== Base64 인코딩 할 파일을 선택하세요 ==</font></td></tr>
</table>
<table border="2" width="600" cellpadding="5" cellspacing="0"  bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <input type="file" id="base64file" name="envfile" size="45"  runat="server" >
    </td>
  </tr>
  <tr>
    <td align="left">
    <asp:button id="base64btn" runat="server" Width="80px" style="width:150"  Text="Base64 Encode File"></asp:button>
    </td>
  </tr>
  <tr>
    <td align="left">
    <asp:Label id="base64msg" runat="server"></asp:Label>
    </td>
  </tr>  
</table>
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
<br>
 <table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
	<tr>
		<td align="center"><font color="#ffffff">== Base64 인코딩 한 파일 내용 ==</font></td>
	</tr>
</table>
<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
	<tr>
		<td align="left">
			<asp:textbox id="b64data" runat="server" Width="580px" Rows="6" BorderStyle="Solid" TextMode="MultiLine" readonly></asp:textbox>
		</td>
				
	</tr>
			
</table>			
<br>
<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <asp:button id="base64decbtn" runat="server" Width="80px" style="width:150"  Text="Base64 Decode File"></asp:button>
    </td>
  </tr>  
</table>
			<br>
			<table border="2" width="600" cellpadding="3" cellspacing="0" bgcolor="#a7b9cc">
				<tr>
					<td align="center"><font color="#ffffff">== Base64 디코딩후 나온 원문 데이타 파일 ==</font></td>
				</tr>
			</table>
						<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">
				<tr>
					<td align="left">
						<asp:textbox id="base64decdata" runat="server" Width="580px" Rows="6" BorderStyle="Solid" TextMode="MultiLine" readonly></asp:textbox>
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
