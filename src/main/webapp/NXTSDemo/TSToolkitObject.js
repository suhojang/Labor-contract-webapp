var KTNET_PKI_AX_CAB_VERSION = "2,0,7,0";						// 툴킷 버전 : 버전 업그레이드 변경되는 부분 
var KTNET_PKI_AX_CAB_FILEPATH = "./download/"; 					// 사이트별로 CAB 파일이 배포되는 위치 
var KTNET_PKI_AX_CAB_SHA1 = "TSToolkit_2,0,7,0.cab";			// XP 사용자를 위한 SHA1 코드사인된 CAB 파일명
var KTNET_PKI_AX_CAB_SHA2 = "TSToolkit_2,0,7,0_sha2.cab";		// XP 이외 사용자를 위한 SHA256 코드사인된 CAB 파일명

var KTNET_PKI_AX_CODEBASE = KTNET_PKI_AX_CAB_FILEPATH;
if (KTNET_IsOverXP() == true) {
	KTNET_PKI_AX_CODEBASE += KTNET_PKI_AX_CAB_SHA2;
	
}
else {
	KTNET_PKI_AX_CODEBASE += KTNET_PKI_AX_CAB_SHA1;
}
//alert("IsOverXP=" + KTNET_IsOverXP() + "\r\ncodebase=" + KTNET_PKI_AX_CODEBASE);

function KTNET_IsOverXP()
{
	if (navigator.userAgent.indexOf('Windows NT 5.') != -1)
		return false;
	else 
		return true;
}

document.write ("<OBJECT id=\"TSToolkit\"");
document.write ("classid=\"CLSID:55D9860A-AB9C-44A1-BB74-75AF7F805333\"");
document.write ("codebase=\"" + KTNET_PKI_AX_CODEBASE + "#version="+ KTNET_PKI_AX_CAB_VERSION +"\"");
document.write ("style=\"LEFT: 0px; TOP: 0px\" width=\"0\" height=\"0\" VIEWASTEXT>");
document.write ("</OBJECT>");
