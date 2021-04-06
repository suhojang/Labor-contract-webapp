<%
' ** 환경 설정시 주의사항 ***************************************************************	' 
'  																						
'  . 인증기관 LDAP 정보 모음 은 LDAP 에서 인증서를 가져올 때 반드시 사용된다.											
'  																						
' **************************************************************************************' 

' ** 기본정보 설정			************************************************************' 

'  == 인증기관 관련 정보 모음		================================= 
Dim CA_LDAP_INFO
CA_LDAP_INFO = "KISA:dirsys.rootca.or.kr:389|KICA:ldap.signgate.com:389|SignKorea:dir.signkorea.com:389|Yessign:ds.yessign.or.kr:389|CrossCert:dir.crosscert.com:389|TradeSign:ldap.tradesign.net:389|NCASign:ds.nca.or.kr:389|"
'  ============================================================== 

'  == 인증서 정책  관련 		===================================== ' 
Dim FIRST_COMP_CERT_POLICIES, FIRST_INDI_CERT_POLICIES, ALL_CERT_POLICIES
'  -- 법인 상호연동용 OID 모음
FIRST_COMP_CERT_POLICIES = "1 2 410 200012 1 1 3:전자거래법인서명용|1 2 410 200004 5 1 1 7:전자거래법인서명용|1 2 410 200005 1 1 5:전자거래법인서명용|1 2 410 200004 5 2 1 1:전자거래법인서명용|1 2 410 200004 5 4 1 2:전자거래법인서명용|1 2 410 200004 5 3 1 1:전자거래기관서명용|1 2 410 200004 5 3 1 2:전자거래법인서명용|"
'  -- 개인 상호연동용 OID 모음
FIRST_INDI_CERT_POLICIES = "1 2 410 200012 1 1 1:전자거래개인서명용|1 2 410 200004 5 1 1 5:전자거래개인서명용|1 2 410 200005 1 1 1:전자거래개인서명용|1 2 410 200004 5 2 1 2:전자거래개인서명용|1 2 410 200004 5 4 1 1:전자거래개인서명용|1 2 410 200004 5 3 1 9:전자거래개인서명용|"
'  -- 모든 인증서 허용
ALL_CERT_POLICIES = ""	
'  ============================================================== ' 

'  == 인증서 저장매체 관련 	===================================== ' 
Dim HARD_DISK, REMOVABLE_DISK, IC_CARD, PKCS11, MOBILE_PHONE
HARD_DISK 		= 0	
REMOVABLE_DISK 	= 1	
IC_CARD 		= 2
PKCS11	 		= 3
MOBILE_PHONE	= 4
'  ============================================================== ' 

'  == 인증서 Type 관련 		===================================== ' 
Dim CERT_TYPE_SIGN, CERT_TYPE_KM
Dim DATA_TYPE_PEM, DATA_TYPE_BASE64, DATA_TYPE_FILE
CERT_TYPE_SIGN 		= 1	
CERT_TYPE_KM 		= 2	
DATA_TYPE_PEM		= 0
DATA_TYPE_BASE64 	= 1
DATA_TYPE_FILE		= 1
'  ============================================================== ' 

'  == HASH 알고리즘		========================================= ' 
Dim HASH_ID_MD5, HASH_ID_RIPEMD160, HASH_ID_SHA1, HASH_ID_HAS160
Dim HASH_ID_SHA256, HASH_ID_SHA384, HASH_ID_SHA512
HASH_ID_MD5			= 1
HASH_ID_RIPEMD160 	= 2
HASH_ID_SHA1		= 3		'  기본적으로 사용함.
HASH_ID_HAS160		= 4
HASH_ID_SHA256		= 5
HASH_ID_SHA384		= 6
HASH_ID_SHA512		= 7
'  ============================================================== ' 

'  == 대칭키 알고리즘 & 모드	===================================== ' 
Dim SYMMETRIC_ID_DES, SYMMETRIC_ID_3DES, SYMMETRIC_ID_SEED
Dim SYMMETRIC_MODE_EBC, SYMMETRIC_MODE_CBC, SYMMETRIC_MODE_CFB, SYMMETRIC_MODE_OFB
SYMMETRIC_ID_DES	= 1
SYMMETRIC_ID_3DES	= 2		'  기본적으로 사용함.
SYMMETRIC_ID_SEED	= 3
SYMMETRIC_MODE_EBC	= 1		
SYMMETRIC_MODE_CBC	= 2		'  기본적으로 사용함.
SYMMETRIC_MODE_CFB	= 3		
SYMMETRIC_MODE_OFB	= 4
'  ============================================================== ' 

'  == 인증서 정보 관련 설정값		================================= ' 
Dim CERT_ATTR_VERSION, CERT_ATTR_SERIAL_NUBMER, CERT_ATTR_SIGNATURE_ALGO_ID, CERT_ATTR_ISSUER_DN
Dim CERT_ATTR_SUBJECT_DN, CERT_ATTR_SUBJECT_PUBLICKEY_ALGO_ID, CERT_ATTR_VALID_FROM, CERT_ATTR_VALID_TO
Dim CERT_ATTR_PUBLIC_KEY, CERT_ATTR_SIGNATURE, CERT_ATTR_KEY_USAGE, CERT_ATTR_AUTORITY_KEY_ID, CERT_ATTR_SUBJECT_KEY_ID
Dim CERT_ATTR_EXT_KEY_USAGE, CERT_ATTR_SUBJECT_ALT_NAME, CERT_ATTR_BASIC_CONSTRAINT, CERT_ATTR_POLICY
Dim CERT_ATTR_CRLDP, CERT_ATTR_AIA, CERT_ATTR_VALID, CERT_ATTR_SAN_REALNAME

CERT_ATTR_VERSION						= 1
CERT_ATTR_SERIAL_NUBMER 				= 2
CERT_ATTR_SIGNATURE_ALGO_ID 			= 3
CERT_ATTR_ISSUER_DN 					= 4
CERT_ATTR_SUBJECT_DN 					= 5
CERT_ATTR_SUBJECT_PUBLICKEY_ALGO_ID 	= 6
CERT_ATTR_VALID_FROM 					= 7
CERT_ATTR_VALID_TO 						= 8
CERT_ATTR_PUBLIC_KEY 					= 9
CERT_ATTR_SIGNATURE 					= 10
CERT_ATTR_KEY_USAGE 					= 11
CERT_ATTR_AUTORITY_KEY_ID 				= 12
CERT_ATTR_SUBJECT_KEY_ID 				= 13
CERT_ATTR_EXT_KEY_USAGE 				= 14
CERT_ATTR_SUBJECT_ALT_NAME 				= 15
CERT_ATTR_BASIC_CONSTRAINT 				= 16
CERT_ATTR_POLICY 						= 17
CERT_ATTR_CRLDP 						= 18
CERT_ATTR_AIA 							= 19
CERT_ATTR_VALID 						= 20
CERT_ATTR_SAN_REALNAME					= 21
'  ============================================================== ' 

'  == 인증서 Type 관련 		===================================== ' 
Dim DATA_TYPE_CACERT, DATA_TYPE_SIGN_CERT, DATA_TYPE_KM_CERT, DATA_TYPE_CRL, DATA_TYPE_ARL
DATA_TYPE_CACERT 		= 1	
DATA_TYPE_SIGN_CERT 	= 2	
DATA_TYPE_KM_CERT		= 3
DATA_TYPE_CRL	 		= 4
DATA_TYPE_ARL	 		= 5
'  ============================================================== ' 
 
' == 입출력 데이터 Type 관련 		==============================//
Dim INOUT_DATA_TYPE_STRING, INOUT_DATA_TYPE_BASE64, INOUT_DATA_TYPE_FILE
INOUT_DATA_TYPE_STRING		= 101
INOUT_DATA_TYPE_BASE64 		= 102	
INOUT_DATA_TYPE_FILE		= 103
' ============================================================== //

' **************************************************************************************' 
  
' ** 환경 설정				************************************************************' 
'  인증서 선택시 기본 매체.
Dim STORAGE_TYPE, POLICIES
Dim INC_CERT_SIGN, INC_CRL_SIGN, INC_SIGN_TIME_SIGN, INC_CONTENT_SIGN
Dim USING_CRL_CHECK, USING_ARL_CHECK, CTL_INFO
'Dim svrKMCert, svrSignCert
  
'  인증서 선택시 기본 매체.
STORAGE_TYPE = HARD_DISK

'  보고자하는 인증서 정책 모음. 
POLICIES = ALL_CERT_POLICIES

'  서명시 필요한 Config 조절.
'  서명 생성시 인증서 포함 여부, 0 : 서명자 인증서만 포함.(기본), 1 : 서명자 & CA 인증서 포함.
INC_CERT_SIGN 			= 0
'  서명 생성시 CRL 인증서 포함 여부, 0 : 미포함 (기본), 1 : 포함, 
INC_CRL_SIGN			= 0
'  서명 생성시 서명시간 포함 여부, 0 : 미포함, 1 : 포함(기본)
INC_SIGN_TIME_SIGN		= 1
'  서명 생성시 원본데이타 포함 여부 , 0 : 미포함, 1 : 포함(기본)
INC_CONTENT_SIGN 		= 1

'  인증서 검증에 필요한 Config 조절
'  사용자 인증서 검증 조건, 0 : CRL 체크 안함. 1 : 현재시간기준으로 유효한 CRL 사용(기본), 2 : 현재 시간기준으로 유효한 CRL 못 구할 시 이전 CRL 사용.
USING_CRL_CHECK		= 1
'  CA 인증서 검증 조건, 0 : ARL 체크 안함. 1 : 현재시간기준으로 유효한 ARL 사용(기본), 2 : 현재 시간기준으로 유효한 CRL 못 구할 시 이전 ARL 사용.
USING_ARL_CHECK		= 0

CTL_INFO = ""
										
'  Envelop 시 사용되는 상대방 인증서
'svrSignCert = ""
'svrKMCert 	= ""

DIM TSTOOLKIT_APP_ID
'TSTOOLKIT_APP_ID = "axqtui_vs60.TSToolkit.2"
TSTOOLKIT_APP_ID = "TSToolkitSV.TSToolkitSV.1"
'TSTOOLKIT_APP_ID = "TSToolkit.TSToolkit.1"

' **************************************************************************************' 
%>