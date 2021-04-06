var ubikeyVersion="1,2,3,6";
var MacUBIKeyVer="1.0.0.1";
var LinuxUBIKeyVer="";

//윈도우만 지원	
if(	navigator.platform == "Win32")
{
	// IE일때 Object 생성
	if(navigator.userAgent.indexOf("MSIE") != -1)				// Explorer
	{	
//		alert("hello Win IE");
		document.writeln("<object classid='CLSID:C1143E84-B2B1-473B-9F20-E62DD754FCAF'");
		//document.writeln("codebase='http://"+window.location.host+"/infovine/VineTransfer.cab#version="+ubikeyVersion+"' width='0' height='0' id='VineTransfer'>");
		document.writeln("codebase='#version="+ubikeyVersion+"' width='0' height='0' id='VineTransfer'>");
		document.writeln("<param name='HideCA' value=''>");
		document.writeln("<param name='HideClass' value=''>");
		document.writeln("</object>");
	}
	else
	{
		if(installCheck())
		{
		//	document.writeln("<embed name='VineTransfer' type='application/npvinetransfer-plugin' hidden=true>");
			document.writeln("<object id='VineTransfer' type='application/npvinetransfer-plugin' width = 0 height=0></object>");
		}
	}
}
else if(navigator.platform.indexOf("Mac") != -1)
{
		if(installCheck())
		{
			// mac plugin name change
			document.writeln("<object id='VineTransfer' type='application/x-npvinetransfer-plugin' width = 0 height=0></object>");
		}
}
else if(navigator.platform.indexOf("Linux") != -1)
{
	// linux plugin name change
		if(installCheck())
		{
			document.writeln("<object id='VineTransfer' type='application/x-vinetransfer' width = 0 height=0></object>");
		}
}
/*	
function exit(x)
{
	alert("exit");
	 x.close();
}
*/
	
/* 여기에서 ';'표 되어 있는것은 기본적으로 막혀있다.
';'표 외에 숨기고자 하는 인증서는 2가지 방법으로 숨길수 있다.
	
첫 째, 발급자
	코스콤과 금융결제원의 인승서를 안보이게 하고자 할 때(구분자를 ','로 두어서 중복으로 숨길수 있다.)
	document.writeln("<param name='HideCA' value='SIGNKOREA,YESSIGN'>");
		
둘 째, 용도
	금결원의 신용카드 인증서를 안보이고자 할 때(구분자를 ','로 두어서 중복으로 숨길수 있다.)
	document.writeln("<param name='HideClass' value='1.2.410.200005.1.1.6.2'>");
	
;한국정보인증				SIGNGATE
1.2.410.200004.5.2.1.2		1등급(개인)
1.2.410.200004.5.2.1.1		1등급(법인)
;1.2.410.200004.5.2.1.4		1등급(서버)
1.2.410.200004.5.2.1.7.1	은행/신용카드/보험
1.2.410.200004.5.2.1.7.2	증권(개인)
1.2.410.200004.5.2.1.7.3	신용카드(개인)
;1.2.410.200004.5.2.1.3		임시
1.2.410.200004.5.2.1.5		A(법인/단체/개인사업자)
1.2.410.200004.5.2.1.6		B(법인/단체/개인사업자/개인)

;코스콤(증권전산)			SIGNKOREA
1.2.410.200004.5.1.1.5		범용(개인업무)	
;1.2.410.200004.5.1.1.6		범용(개인서버)
1.2.410.200004.5.1.1.7		범용(법인업무)
;1.2.410.200004.5.1.1.8		범용(법인서버)
1.2.410.200004.5.1.1.1		개인업무
;1.2.410.200004.5.1.1.2		개인서버
1.2.410.200004.5.1.1.3		법인업무
;1.2.410.200004.5.1.1.4		법인서버
1.2.410.200004.5.1.1.9		개인업무
1.2.410.200004.5.1.1.9.2	개인업무
;1.2.410.200004.5.1.1.10	개인서버
1.2.410.200004.5.1.1.11		개인업무
1.2.410.200004.5.1.1.12		법인업무

;금융결제원					YESSIGN
1.2.410.200005.1.1.1		범용(개인)
1.2.410.200005.1.1.5		범용(기업/법인/단체)
1.2.410.200005.1.1.4		은행/신용카드/보험(개인)
1.2.410.200005.1.1.2		기업(법인/단체)
1.2.410.200005.1.1.6.2		신용카드(개인)
1.2.410.200005.1.1.6.1		기업뱅킹(기업/법인/단체)
1.2.410.200005.1.1.6.3		조달청원클릭(기업/법인/단체)
;1.2.410.200005.1.1.6.X		기타(별도지정)
;1.2.410.200005.1.1.3		서버사업자(서버사업자)

;한국전산원					NCASIGN
1.2.410.200004.5.3.1.1		범용(기관)
1.2.410.200004.5.3.1.2		범용(법인)
;1.2.410.200004.5.3.1.3		범용(서버)
1.2.410.200004.5.3.1.9		범용(개인)
1.2.410.200004.5.3.1.4		개인
1.2.410.200004.5.3.1.5		기관
1.2.410.200004.5.3.1.6		법인
;1.2.410.200004.5.3.1.7		서버

;한국전자인증				CROSSCERT
1.2.410.200004.5.4.1.1		범용(개인)
1.2.410.200004.5.4.1.2		범용(법인/단체)
;1.2.410.200004.5.4.1.3		범용(서버)
1.2.410.200004.5.4.1.101	은행(개인)
1.2.410.200004.5.4.1.102	증권(개인)
1.2.410.200004.5.4.1.103	신용카드(개인)
1.2.410.200004.5.4.1.104	전자민원(개인)
1.2.410.200004.5.4.1.4		개인
1.2.410.200004.5.4.1.5		법인(법인/단체)

;한국무역정보통신			TRADESIGN
1.2.410.200012.1.1.1		범용(개인)
1.2.410.200012.1.1.3		범용(법인/단체)
;1.2.410.200012.1.1.5		범용(서버)
1.2.410.200012.1.1.101		은행(개인)
1.2.410.200012.1.1.103		증권(개인)
1.2.410.200012.1.1.105		신용카드(개인)
1.2.410.200012.1.1.7		전자무역(개인)
1.2.410.200012.1.1.9		전자무역(법인)
;1.2.410.200012.1.1.11		전자무역(서버)
1.2.410.200012.1.1.13		개인
1.2.410.200012.1.1.15		법인
;1.2.410.200012.1.1.17		서버

*/
/*
function getDomaint() {
    var dns, arrDns, str; 
    dns = document.location.href; //<-- 현재 URL 얻어온다
    arrDns = dns.split("//"); //<-- // 구분자로 짤라와서
    str = arrDns[0]+"//"+arrDns[1].substring(0,arrDns[1].indexOf("/")); //<-- 뒤에부터 다음 / 까지 가져온다 
    return str;
}
*/
// 서비스 이용 채널
var bankUrl = "SUHYUP|"+ window.location.host +"/infovine/virtkey.html|1|html|515|283|01|";
// 보안업체 코드 및 키보드보안 코드
var coUrl	= "INFOVINE|NULL";
/*
var isVKPad = true;

if(isVKPad)
{
	if(navigator.userAgent.indexOf ("MSIE") != -1)
		bankUrl += "http://test.ubikey.co.kr/infovine/multios/virtkey.html|1|html|400|300|MSIE";
	else
		bankUrl += "http://test.ubikey.co.kr/infovine/multios/virtkey.html|1|html|400|300|CHROME";

}
*/
//alert(bankUrl);


function goTrans2phone()
{
						
	if(!OS_Cehck()) 
	{
		alert("지원되지 않는 OS 입니다.");	
		return;
	}
				
	if( installCheck() )
	{
		//휴대폰 인증서 저장하기 버튼클릭시
		document.VineTransfer.Tranx2Phone(bankUrl,coUrl);
	} 
	else
	{
		// 사용자 인증에서 '아니오' 버튼을 눌렀을 경우 띄울 페이지 URL
		//	if(navigator.userAgent.indexOf ("MSIE") != -1)				// Explorer
		open_window(450,400,"DownloadPage",getDomaint()+ "/infovine/download.html?reload=ok");
		//	else
		//		location.href = "./UBIKey.exe";

		return;
	}
}
	
function goTrans2pc()
{
	return;
	
	if( installCheck() )
	{
		//휴대폰 인증서 저장하기 버튼클릭시
			try
			{
				document.VineTransfer.Tranx2PC(bankUrl,coUrl);
			}
			catch( e )
			{
//				alert(document.VineTransfer);
			}
		
	}
	else
	{
		// 사용자 인증에서 '아니오' 버튼을 눌렀을 경우 띄울 페이지 URL
		//alert("goTrans2pc false");
//		if(navigator.userAgent.indexOf ("MSIE") != -1)				// Explorer
			//open_window(450,400,"DownloadPage","./download.html?reload=ok");
//		else
//			location.href = "./UBIKey.exe";


		return;
	}
}

function installCheck()
{
	
		//ActiveX ID	
	var VineTransferProgID = "VINETRANSFER.VineTransferCtrl.1"
	
	
	//윈도우만 지원	
	if(	navigator.platform == "Win32")
	{
	
		if (navigator.userAgent.indexOf ("MSIE") != -1)				// Explorer
		{
				try
				{
					
					var xObj = new ActiveXObject(VineTransferProgID);
				
					if(xObj) 
					{						
 						var xVersion = document.VineTransfer.getubikeyver(2);
					
						return checkVersion(true, xVersion, ubikeyVersion);
					}											
					else
					{
						return false;						
					}
					
				}
				catch(ex)
				{			
					return false;
				}
		}
		else
		{
				var vineTransferPlugin = navigator.mimeTypes["application/npvinetransfer-plugin"];
					

				if(vineTransferPlugin)
				{
					return checkVersion(false, vineTransferPlugin.enabledPlugin.description, ubikeyVersion);
				}
				else
				{
					return false;
				}
										
		}
		
	}
	else if(navigator.platform.indexOf("Mac") != -1)
		{
//			alert("hello Mac1");
			// mac plugin name change
				var vineTransferPlugin = navigator.mimeTypes["application/x-npvinetransfer-plugin"];							
				if(vineTransferPlugin)
				{
					return checkVersion(false,vineTransferPlugin.enabledPlugin.description,MacUBIKeyVer);
				}
				else
					return false;
		}
			else if(navigator.platform.indexOf("Linux") != -1)
		{
			// linux plugin name change
//			alert("hello linux1");
				var vineTransferPlugin = navigator.mimeTypes["application/x-vinetransfer"];							
				if(vineTransferPlugin)
				{
					return checkVersion(false, vineTransferPlugin.enabledPlugin.description,LinuxUBIKeyVer);
				}
				else
				return false;
		}
}


function checkVersion(aIsActiveX, aDesc, aVersion)
{
	try 
	{
		
		if(	navigator.platform == "Win32")
		{			
				//NPRuntime Mymetype 1,1,0,7 업그레이드 특정 조건
				if(aDesc == "npVineTransfer")
				{			
					return false;
				}				
		}
		
		 //ActiveX 일때
		if(aIsActiveX)
		{			
			if( aDesc >= aVersion ) 
			{
				return true;  
			}
	    else 
			{ 
			
 			  return false; 
			}
		}
		else
		{

			var index = aDesc.indexOf('v.', 0);
	    if (index < 0) 
				return true;
    
	    var versionString = aDesc.substring(index +2, aDesc.length);
	    
		  if( versionString >= aVersion ) 
			{
				return true;  
			}
	    else 
			{ 
 			  return false; 
			}
		}
		
	} 
	catch(E) 
	{
			
		return false;   
	}
}

function issue2Mobile()
{
	if( installCheck() )
	{
		if( confirm("휴대폰에도 추가 저장하시겠습니까?") )
		{
			try
			{
				document.VineTransfer.Tranx2Phone(bankUrl,coUrl);
			}
			catch( e )
			{
				alert("휴대폰으로 인증서 저장에 실패하였습니다.!");
			}
		}
		else
		{
			alert("추가 저장 안함");
		}
	}
	else
	{
		alert("UBIKey 설치 되어 있지 않으므로 휴대폰으로 저장 불가!!");
	}
}
	
		
	
//셋팅된 크기및 URL로 창을 띄우는 함수
function open_window(width,height,title, URL)
{	
	var posx = (screen.width-width)/2-1;
	var posy = (screen.height-height)/2-1;            
	var str = "'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,";
	str = str+"top="+ posy +",left="+ posx +",";
	str = str+"width="+ width +",";
	str = str+"height="+ height +"'";
			
	var win = window.open(URL, title, str);	
	
	if (win && !win.closed) win.focus();
}

function OS_Cehck()
{
	
	if(navigator.platform == "Win32")
	{
		return true;
	}
	else
	{
		return false;
	}
	
}