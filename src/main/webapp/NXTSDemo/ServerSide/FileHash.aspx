<%@ Page language="c#" Codebehind="FileHash.aspx.cs" AutoEventWireup="false" Inherits="NetToolkitDemo.ServerSide.FileHash" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 

<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<TITLE></TITLE>
<link rel="stylesheet" href="../tradesign2.css" type="text/css">
<SCRIPT language="javascript">
	
	function signfilechk()
	{
		if( document.getElementById("hashfile").value == "" ){
			alert("HASH 할 파일을 입력하세요!");
			return false;
		}
				
		return true;
	}
			
</SCRIPT>	
</HEAD>
<BODY>

<form name="myform" runat="server">
<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== HASH 할 파일의 절대경로를 입력하세요 ==</font></td></tr>
</table>
<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
	<td align="left">
	    <input type="file" id="hashfile" name="hashfile" size="45"  runat="server" >
	</td>
  </tr>
  <tr>
	<td align="left">
      <asp:button id="hashbtn" runat="server" Width="150" Text="Hash File"></asp:button>
	</td>
  </tr>
  <tr>
	<td align="left">
   	  <asp:Label id="hashmsg" runat="server"></asp:Label>
	</td>
  </tr> 
</table>
<table border="2" width="600" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFF">== HASH된 파일 데이타 ==</font></td></tr>
</table>
<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <asp:textbox id="hashdata" runat="server" Width="580px" BorderStyle="Solid" Rows="6" TextMode="MultiLine"></asp:textbox>
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
