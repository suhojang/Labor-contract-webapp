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
					alert("�����(�ֹε��)��ȣ�� �Է��ϼ���!");
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
						<td align="center"><font color="#ffffff">== �ſ�Ȯ���� �������� �ſ�Ȯ�� ������ �Է��ϼ��� ==</font></td>
					</tr>
				</table>
				<table border="2" width="600" cellpadding="5" cellspacing="0" bordercolor="#e0e0e0" bgcolor="#f0f0f0">

					<tr>
						<td align="center">
							<b>Ȯ���� ���� �������� �����(�ֹε��)��ȣ :
								<asp:textbox id="ssn" runat="server" Width="150px" MaxLength="30" BorderStyle="Solid"></asp:textbox>'-' 
								���� �Է��ϼ���.</b>
						</td>
					</tr>
					<tr>
						<td align="left">
							<asp:button id="Checkbtn" runat="server" Width="150" Text="������ �ſ�Ȯ��"></asp:button>
						</td>
					</tr>
					<tr>
						<td align="left">
							<asp:Label id="checkMsg" runat="server" />
						</td>
					</tr>
					<tr>
						<td align="right">
							<INPUT TYPE="reset" name="Clear" Value="ȭ�� �����" style="WIDTH:150px">
						</td>
					</tr>
				</table>
			</form>
		</P>
	</BODY>
</HTML>
