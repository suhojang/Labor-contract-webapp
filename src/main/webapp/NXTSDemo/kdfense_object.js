
var var_kLicense;
var kdfv_domain = window.location.hostname;
var_winVer32 = false;

//DEMO 200712
var_kLicense = "64a8a53c60c0bec49f3ab6486e0b4c9998db98ef6043ff8a6af65cecf7e55c3631";

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// rock 070608 Vista x64에서 ie 버전 구분하기 

var request_os = navigator.userAgent;


if (window.ActiveXObject)
{
	if( request_os.indexOf("NT 6.") != -1 && request_os.indexOf("x64") != -1 )
	{
		//	alert("IE 64비트");
		document.write('<object id=kdefense classid="CLSID:A4508A45-F1C4-40f3-99B4-0CA08AC77E3B"');
		document.write('	codebase="http://kings.nefficient.co.kr/kings/kdfx/kdfx308/x64/kdfense8.cab#Version=8,3,0,8"');
		document.write('	height=0 width=0 align=left size=0>');
		document.write('	<PARAM name="nOption" value=6>');
		
		document.write('	<PARAM name="nModuleVersion" value=27080801>');
		document.write('	<PARAM name="szModulePath" value="http://kings.nefficient.co.kr/kings/kdfinj5x/27080801/x64/kdfinj.dll">');
		document.write('	<PARAM name="szModuleHash" value="1EDC91B001AD9A5B58F4D8C2BC92C03B">');

		document.write('	<PARAM name="nExModuleVersion" value=07061301>');
		document.write('	<PARAM name="szExModulePath" value="http://kings.nefficient.co.kr/kings/kdfmod3x/07061301/x64/kdfmod.dll">');
		document.write('	<PARAM name="szExModuleHash" value="AD484B2CBD9F5F04E09C1AD27142D3B6">');
		
		document.write('	<PARAM name="szGKey" value="58c705643199c2ff067850db4181dff9f0d63edeecde16ab33ac57c24703d22ff0">');
		document.write('	<PARAM name="kLicense" value=', var_kLicense, '>');
		document.write('</object>');
	}
	else
	{	// 32비트
		document.write('<object id=kdefense classid="CLSID:A4508A45-F1C4-40f3-99B4-0CA08AC77E3B"');
		document.write('	codebase="http://kings.nefficient.co.kr/kings/kdfx/kdfx308/kdfense8.cab#Version=8,3,0,8"');
		document.write('	height=0 width=0 align=left size=0>');
		document.write('	<PARAM name="nOption" value=6>');
		
		document.write('	<PARAM name="nModuleVersion" value=27080801>');
		document.write('	<PARAM name="szModulePath" value="http://kings.nefficient.co.kr/kings/kdfinj5x/27080801/kdfinj.dll">');
		document.write('	<PARAM name="szModuleHash" value="6FA4FBCC4E929111643320B1B88AD1F1">');

		document.write('	<PARAM name="nExModuleVersion" value=07061301>');
		document.write('	<PARAM name="szExModulePath" value="http://kings.nefficient.co.kr/kings/kdfmod3x/07061301/kdfmod.dll">');
		document.write('	<PARAM name="szExModuleHash" value="12DAA8D891DABCCFBE151B1745D77D38">');
		
		document.write('	<PARAM name="szGKey" value="58c705643199c2ff067850db4181dff9f0d63edeecde16ab33ac57c24703d22ff0">');
		document.write('	<PARAM name="kLicense" value=', var_kLicense, '>');
		document.write('</object>');
	}
}
