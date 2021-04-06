package kcert.framework.util;

import java.net.ConnectException;
import java.net.UnknownHostException;
import java.security.cert.CertPathValidator;
import java.security.cert.CertPathValidatorException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateExpiredException;
import java.security.cert.PKIXCertPathValidatorResult;
import java.security.cert.X509Certificate;

import javax.naming.NamingException;

import tradesign.crypto.cert.CertificateRevokedException;
import tradesign.crypto.cert.validator.ExtendedPKIXParameters;
import tradesign.crypto.cert.validator.PKIXCertPath;
import tradesign.crypto.provider.JeTS;

public class CertPathValidate {

	/**
	 * 인증서 경로 검증 예제
	 * 
	 * @param args
	 * @throws CertificateException
	 */
	public static void validate(X509Certificate cert){
		try {
			JeTS.installProvider("./data/config/tradesign3280.properties");
			
			PKIXCertPath cp = new PKIXCertPath(cert, "PkiPath"); 
	
			ExtendedPKIXParameters cpp = new ExtendedPKIXParameters(JeTS.getTAnchorSet());
			cpp.setRevocationEnabled(true); //CRL 검증 여부 설정. true : CRL 검증
			cpp.setExpiredEnabled(false); // 인증서 만료 검증 여부 설정
			
			CertPathValidator cpvi = CertPathValidator.getInstance("PKIX","JeTS");
			PKIXCertPathValidatorResult cpvr = (PKIXCertPathValidatorResult) cpvi.validate(cp, cpp);
	
			System.out.println("검증완료:" + cpvr.toString());
		} catch(CertPathValidatorException e) {
			Throwable cause = e.getCause();
			//인증서 폐기 혹은 효력정지
			if (cause instanceof CertificateRevokedException){
				System.err.println(((CertificateRevokedException)cause).getRevokedReasonString());
				System.err.println(((CertificateRevokedException)cause).getRevokedDate());
			} 
			//유효기간 만료
			else if (cause instanceof CertificateExpiredException){
				System.err.println(e);
			}
			
			else if (cause instanceof UnknownHostException || cause instanceof ConnectException){
				System.err.println("인증서 폐지목록 검증을 하는 도중 네트워크에 장애가 발생 하였습니다. 네트워크 상태를 확인하신 후 다시 시도해보시기 바랍니다.\n" + cause);
			}
			else if (cause instanceof NamingException){
				System.err.println("인증서 폐지목록 검증을 하는 도중 네트워크에 장애가 발생 하였습니다. 네트워크 상태를 확인하신 후 다시 시도해보시기 바랍니다.\n" + cause);
			}
/*			else if (cause instanceof CRLException){
				Throwable crlExceptionCause = cause.getCause();
				if(crlExceptionCause instanceof com.unboundid.ldap.sdk.LDAPException)
					System.err.println("인증서 검증을 하는 도중 네트쿼으 장애가 일어났습니다. 네트워크 상태를 확인하신 후 다시 시도해보시기 바랍니다.\n" + crlExceptionCause);
				else
					System.err.println(e);
			}*/
			else
				System.err.println(e);
		} catch(Exception e) {
			System.out.println("검증실패:" + e.getMessage());
		}
	}
}
