Attribute VB_Name = "TSToolkitConfig"

'** 환경 설정시 주의사항 ***************************************************************        '
'
' . 인증기관 LDAP 정보 모음 은 LDAP 에서 인증서를 가져올 때 반드시 사용된다.
'
'**************************************************************************************'
Option Explicit
' ** 기본정보 설정			************************************************************' 

'  == 인증기관 관련 정보 모음		================================= 
'Dim CA_LDAP_INFO
Global Const CA_LDAP_INFO As String = "KISA:dirsys.rootca.or.kr:389|KICA:ldap.signgate.com:389|SignKorea:dir.signkorea.com:389|Yessign:ds.yessign.or.kr:389|CrossCert:dir.crosscert.com:389|TradeSign:ldap.tradesign.net:389|NCASign:ds.nca.or.kr:389|"
'  ============================================================== 

'  == 인증서 정책  관련 		===================================== ' 
'Dim FIRST_COMP_CERT_POLICIES, FIRST_INDI_CERT_POLICIES, ALL_CERT_POLICIES
'  -- 법인 상호연동용 OID 모음
Global Const FIRST_COMP_CERT_POLICIES As String = "1 2 410 200012 1 1 3:전자거래법인서명용|1 2 410 200004 5 1 1 7:전자거래법인서명용|1 2 410 200005 1 1 5:전자거래법인서명용|1 2 410 200004 5 2 1 1:전자거래법인서명용|1 2 410 200004 5 4 1 2:전자거래법인서명용|1 2 410 200004 5 3 1 1:전자거래기관서명용|1 2 410 200004 5 3 1 2:전자거래법인서명용|"
'  -- 개인 상호연동용 OID 모음
Global Const FIRST_INDI_CERT_POLICIES As String = "1 2 410 200012 1 1 1:전자거래개인서명용|1 2 410 200004 5 1 1 5:전자거래개인서명용|1 2 410 200005 1 1 1:전자거래개인서명용|1 2 410 200004 5 2 1 2:전자거래개인서명용|1 2 410 200004 5 4 1 1:전자거래개인서명용|1 2 410 200004 5 3 1 9:전자거래개인서명용|"
'  -- 모든 인증서 허용
Global Const ALL_CERT_POLICIES As String = ""	
'  ============================================================== ' 

'  == 인증서 저장매체 관련 	===================================== ' 
'Dim HARD_DISK, REMOVABLE_DISK, IC_CARD, PKCS11, MOBILE_PHONE
Global Const HARD_DISK 			As Integer = 0	
Global Const REMOVABLE_DISK 	As Integer = 1	
Global Const IC_CARD 			As Integer = 2
Global Const PKCS11	 			As Integer = 3
Global Const MOBILE_PHONE		As Integer = 4
'  ============================================================== ' 

'  == 인증서 Type 관련 		===================================== ' 
'Dim CERT_TYPE_SIGN, CERT_TYPE_KM
'Dim DATA_TYPE_PEM, DATA_TYPE_BASE64
Global Const CERT_TYPE_SIGN 	As Integer = 1	
Global Const CERT_TYPE_KM 		As Integer = 2	
Global Const DATA_TYPE_PEM		As Integer = 0
Global Const DATA_TYPE_BASE64 	As Integer = 1
Global Const DATA_TYPE_FILE 	As Integer = 1
'  ============================================================== ' 

'  == HASH 알고리즘		========================================= ' 
'Dim HASH_ID_MD5, HASH_ID_RIPEMD160, HASH_ID_SHA1, HASH_ID_HAS160
'Dim HASH_ID_SHA256, HASH_ID_SHA384, HASH_ID_SHA512
Global Const HASH_ID_MD5		As Integer = 1
Global Const HASH_ID_RIPEMD160 	As Integer = 2
Global Const HASH_ID_SHA1		As Integer = 3		'  기본적으로 사용함.
Global Const HASH_ID_HAS160		As Integer = 4
Global Const HASH_ID_SHA256		As Integer = 5
Global Const HASH_ID_SHA384		As Integer = 6
Global Const HASH_ID_SHA512		As Integer = 7
'  ============================================================== ' 

'  == 대칭키 알고리즘 & 모드	===================================== ' 
'Dim SYMMETRIC_ID_DES, SYMMETRIC_ID_3DES, SYMMETRIC_ID_SEED
'Dim SYMMETRIC_MODE_EBC, SYMMETRIC_MODE_CBC, SYMMETRIC_MODE_CFB, SYMMETRIC_MODE_OFB
Global Const SYMMETRIC_ID_DES		As Integer = 1
Global Const SYMMETRIC_ID_3DES		As Integer = 2		'  기본적으로 사용함.
Global Const SYMMETRIC_ID_SEED		As Integer = 3
Global Const SYMMETRIC_MODE_EBC		As Integer = 1		
Global Const SYMMETRIC_MODE_CBC		As Integer = 2		'  기본적으로 사용함.
Global Const SYMMETRIC_MODE_CFB		As Integer = 3		
Global Const SYMMETRIC_MODE_OFB		As Integer = 4
'  ============================================================== ' 

'  == 인증서 정보 관련 설정값		================================= ' 
'Dim CERT_ATTR_VERSION, CERT_ATTR_SERIAL_NUBMER, CERT_ATTR_SIGNATURE_ALGO_ID, CERT_ATTR_ISSUER_DN
'Dim CERT_ATTR_SUBJECT_DN, CERT_ATTR_SUBJECT_PUBLICKEY_ALGO_ID, CERT_ATTR_VALID_FROM, CERT_ATTR_VALID_TO
'Dim CERT_ATTR_PUBLIC_KEY, CERT_ATTR_SIGNATURE, CERT_ATTR_KEY_USAGE, CERT_ATTR_AUTORITY_KEY_ID, CERT_ATTR_SUBJECT_KEY_ID
'Dim CERT_ATTR_EXT_KEY_USAGE, CERT_ATTR_SUBJECT_ALT_NAME, CERT_ATTR_BASIC_CONSTRAINT, CERT_ATTR_POLICY
'Dim CERT_ATTR_CRLDP, CERT_ATTR_AIA, CERT_ATTR_VALID, CERT_ATTR_SAN_REALNAME

Global Const CERT_ATTR_VERSION						As Integer = 1
Global Const CERT_ATTR_SERIAL_NUBMER 				As Integer = 2
Global Const CERT_ATTR_SIGNATURE_ALGO_ID 			As Integer = 3
Global Const CERT_ATTR_ISSUER_DN 					As Integer = 4
Global Const CERT_ATTR_SUBJECT_DN 					As Integer = 5
Global Const CERT_ATTR_SUBJECT_PUBLICKEY_ALGO_ID 	As Integer = 6
Global Const CERT_ATTR_VALID_FROM 					As Integer = 7
Global Const CERT_ATTR_VALID_TO 					As Integer = 8
Global Const CERT_ATTR_PUBLIC_KEY 					As Integer = 9
Global Const CERT_ATTR_SIGNATURE 					As Integer = 10
Global Const CERT_ATTR_KEY_USAGE 					As Integer = 11
Global Const CERT_ATTR_AUTORITY_KEY_ID 				As Integer = 12
Global Const CERT_ATTR_SUBJECT_KEY_ID 				As Integer = 13
Global Const CERT_ATTR_EXT_KEY_USAGE 				As Integer = 14
Global Const CERT_ATTR_SUBJECT_ALT_NAME 			As Integer = 15
Global Const CERT_ATTR_BASIC_CONSTRAINT 			As Integer = 16
Global Const CERT_ATTR_POLICY 						As Integer = 17
Global Const CERT_ATTR_CRLDP 						As Integer = 18
Global Const CERT_ATTR_AIA 							As Integer = 19
Global Const CERT_ATTR_VALID 						As Integer = 20
Global Const CERT_ATTR_SAN_REALNAME					As Integer = 21
'  ============================================================== ' 

'  == 인증서 Type 관련 		===================================== ' 
Global Const DATA_TYPE_CACERT 		As Integer = 1	
Global Const DATA_TYPE_SIGN_CERT 	As Integer = 2	
Global Const DATA_TYPE_KM_CERT		As Integer = 3
Global Const DATA_TYPE_CRL	 		As Integer = 4
Global Const DATA_TYPE_ARL	 		As Integer = 5
'  ============================================================== ' 
' == 입출력 데이터 Type 관련 		==============================//
' Dim INOUT_DATA_TYPE_STRING, INOUT_DATA_TYPE_BASE64, INOUT_DATA_TYPE_FILE
Global Const INOUT_DATA_TYPE_STRING		= 101
Global Const INOUT_DATA_TYPE_BASE64 	= 102	
Global Const INOUT_DATA_TYPE_FILE		= 103
' ============================================================== //

' **************************************************************************************' 
  
' ** 환경 설정				************************************************************' 

'  인증서 선택시 기본 매체.
Global Const STORAGE_TYPE = HARD_DISK

'  보고자하는 인증서 정책 모음. 
Global Const POLICIES = ALL_CERT_POLICIES

'  서명시 필요한 Config 조절.
'	서명 생성시 인증서 포함 여부, 0 : 서명자 인증서만 포함.(기본), 1 : 서명자 & CA 인증서 포함.
Global Const INC_CERT_SIGN 			= 0
'  서명 생성시 CRL 인증서 포함 여부, 0 : 미포함 (기본), 1 : 포함, 
Global Const INC_CRL_SIGN			= 0
'  서명 생성시 서명시간 포함 여부, 0 : 미포함, 1 : 포함(기본)
Global Const INC_SIGN_TIME_SIGN		= 1
'  서명 생성시 원본데이타 포함 여부 , 0 : 미포함, 1 : 포함(기본)
Global Const INC_CONTENT_SIGN 		= 1

'  인증서 검증에 필요한 Config 조절
'  사용자 인증서 검증 조건, 0 : CRL 체크 안함. 1 : 현재시간기준으로 유효한 CRL 사용(기본), 2 : 현재 시간기준으로 유효한 CRL 못 구할 시 이전 CRL 사용.
Global Const USING_CRL_CHECK		= 1
'  CA 인증서 검증 조건, 0 : ARL 체크 안함. 1 : 현재시간기준으로 유효한 ARL 사용(기본), 2 : 현재 시간기준으로 유효한 CRL 못 구할 시 이전 ARL 사용.
Global Const USING_ARL_CHECK		= 0

Global Const CTL_INFO As String = ""
										
'  Envelop 시 사용되는 상대방 인증서
'Global Const svrSignCert = ""
'Global Const svrKMCert 	=""

' **************************************************************************************' 
