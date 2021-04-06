<%
' ** ȯ�� ������ ���ǻ��� ***************************************************************	' 
'  																						
'  . ������� LDAP ���� ���� �� LDAP ���� �������� ������ �� �ݵ�� ���ȴ�.											
'  																						
' **************************************************************************************' 

' ** �⺻���� ����			************************************************************' 

'  == ������� ���� ���� ����		================================= 
Dim CA_LDAP_INFO
CA_LDAP_INFO = "KISA:dirsys.rootca.or.kr:389|KICA:ldap.signgate.com:389|SignKorea:dir.signkorea.com:389|Yessign:ds.yessign.or.kr:389|CrossCert:dir.crosscert.com:389|TradeSign:ldap.tradesign.net:389|NCASign:ds.nca.or.kr:389|"
'  ============================================================== 

'  == ������ ��å  ���� 		===================================== ' 
Dim FIRST_COMP_CERT_POLICIES, FIRST_INDI_CERT_POLICIES, ALL_CERT_POLICIES
'  -- ���� ��ȣ������ OID ����
FIRST_COMP_CERT_POLICIES = "1 2 410 200012 1 1 3:���ڰŷ����μ����|1 2 410 200004 5 1 1 7:���ڰŷ����μ����|1 2 410 200005 1 1 5:���ڰŷ����μ����|1 2 410 200004 5 2 1 1:���ڰŷ����μ����|1 2 410 200004 5 4 1 2:���ڰŷ����μ����|1 2 410 200004 5 3 1 1:���ڰŷ���������|1 2 410 200004 5 3 1 2:���ڰŷ����μ����|"
'  -- ���� ��ȣ������ OID ����
FIRST_INDI_CERT_POLICIES = "1 2 410 200012 1 1 1:���ڰŷ����μ����|1 2 410 200004 5 1 1 5:���ڰŷ����μ����|1 2 410 200005 1 1 1:���ڰŷ����μ����|1 2 410 200004 5 2 1 2:���ڰŷ����μ����|1 2 410 200004 5 4 1 1:���ڰŷ����μ����|1 2 410 200004 5 3 1 9:���ڰŷ����μ����|"
'  -- ��� ������ ���
ALL_CERT_POLICIES = ""	
'  ============================================================== ' 

'  == ������ �����ü ���� 	===================================== ' 
Dim HARD_DISK, REMOVABLE_DISK, IC_CARD, PKCS11, MOBILE_PHONE
HARD_DISK 		= 0	
REMOVABLE_DISK 	= 1	
IC_CARD 		= 2
PKCS11	 		= 3
MOBILE_PHONE	= 4
'  ============================================================== ' 

'  == ������ Type ���� 		===================================== ' 
Dim CERT_TYPE_SIGN, CERT_TYPE_KM
Dim DATA_TYPE_PEM, DATA_TYPE_BASE64, DATA_TYPE_FILE
CERT_TYPE_SIGN 		= 1	
CERT_TYPE_KM 		= 2	
DATA_TYPE_PEM		= 0
DATA_TYPE_BASE64 	= 1
DATA_TYPE_FILE		= 1
'  ============================================================== ' 

'  == HASH �˰���		========================================= ' 
Dim HASH_ID_MD5, HASH_ID_RIPEMD160, HASH_ID_SHA1, HASH_ID_HAS160
Dim HASH_ID_SHA256, HASH_ID_SHA384, HASH_ID_SHA512
HASH_ID_MD5			= 1
HASH_ID_RIPEMD160 	= 2
HASH_ID_SHA1		= 3		'  �⺻������ �����.
HASH_ID_HAS160		= 4
HASH_ID_SHA256		= 5
HASH_ID_SHA384		= 6
HASH_ID_SHA512		= 7
'  ============================================================== ' 

'  == ��ĪŰ �˰��� & ���	===================================== ' 
Dim SYMMETRIC_ID_DES, SYMMETRIC_ID_3DES, SYMMETRIC_ID_SEED
Dim SYMMETRIC_MODE_EBC, SYMMETRIC_MODE_CBC, SYMMETRIC_MODE_CFB, SYMMETRIC_MODE_OFB
SYMMETRIC_ID_DES	= 1
SYMMETRIC_ID_3DES	= 2		'  �⺻������ �����.
SYMMETRIC_ID_SEED	= 3
SYMMETRIC_MODE_EBC	= 1		
SYMMETRIC_MODE_CBC	= 2		'  �⺻������ �����.
SYMMETRIC_MODE_CFB	= 3		
SYMMETRIC_MODE_OFB	= 4
'  ============================================================== ' 

'  == ������ ���� ���� ������		================================= ' 
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

'  == ������ Type ���� 		===================================== ' 
Dim DATA_TYPE_CACERT, DATA_TYPE_SIGN_CERT, DATA_TYPE_KM_CERT, DATA_TYPE_CRL, DATA_TYPE_ARL
DATA_TYPE_CACERT 		= 1	
DATA_TYPE_SIGN_CERT 	= 2	
DATA_TYPE_KM_CERT		= 3
DATA_TYPE_CRL	 		= 4
DATA_TYPE_ARL	 		= 5
'  ============================================================== ' 
 
' == ����� ������ Type ���� 		==============================//
Dim INOUT_DATA_TYPE_STRING, INOUT_DATA_TYPE_BASE64, INOUT_DATA_TYPE_FILE
INOUT_DATA_TYPE_STRING		= 101
INOUT_DATA_TYPE_BASE64 		= 102	
INOUT_DATA_TYPE_FILE		= 103
' ============================================================== //

' **************************************************************************************' 
  
' ** ȯ�� ����				************************************************************' 
'  ������ ���ý� �⺻ ��ü.
Dim STORAGE_TYPE, POLICIES
Dim INC_CERT_SIGN, INC_CRL_SIGN, INC_SIGN_TIME_SIGN, INC_CONTENT_SIGN
Dim USING_CRL_CHECK, USING_ARL_CHECK, CTL_INFO
'Dim svrKMCert, svrSignCert
  
'  ������ ���ý� �⺻ ��ü.
STORAGE_TYPE = HARD_DISK

'  �������ϴ� ������ ��å ����. 
POLICIES = ALL_CERT_POLICIES

'  ����� �ʿ��� Config ����.
'  ���� ������ ������ ���� ����, 0 : ������ �������� ����.(�⺻), 1 : ������ & CA ������ ����.
INC_CERT_SIGN 			= 0
'  ���� ������ CRL ������ ���� ����, 0 : ������ (�⺻), 1 : ����, 
INC_CRL_SIGN			= 0
'  ���� ������ ����ð� ���� ����, 0 : ������, 1 : ����(�⺻)
INC_SIGN_TIME_SIGN		= 1
'  ���� ������ ��������Ÿ ���� ���� , 0 : ������, 1 : ����(�⺻)
INC_CONTENT_SIGN 		= 1

'  ������ ������ �ʿ��� Config ����
'  ����� ������ ���� ����, 0 : CRL üũ ����. 1 : ����ð��������� ��ȿ�� CRL ���(�⺻), 2 : ���� �ð��������� ��ȿ�� CRL �� ���� �� ���� CRL ���.
USING_CRL_CHECK		= 1
'  CA ������ ���� ����, 0 : ARL üũ ����. 1 : ����ð��������� ��ȿ�� ARL ���(�⺻), 2 : ���� �ð��������� ��ȿ�� CRL �� ���� �� ���� ARL ���.
USING_ARL_CHECK		= 0

CTL_INFO = ""
										
'  Envelop �� ���Ǵ� ���� ������
'svrSignCert = ""
'svrKMCert 	= ""

DIM TSTOOLKIT_APP_ID
'TSTOOLKIT_APP_ID = "axqtui_vs60.TSToolkit.2"
TSTOOLKIT_APP_ID = "TSToolkitSV.TSToolkitSV.1"
'TSTOOLKIT_APP_ID = "TSToolkit.TSToolkit.1"

' **************************************************************************************' 
%>