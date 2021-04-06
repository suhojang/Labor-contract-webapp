package kcert.framework.util;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URISyntaxException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.params.CoreConnectionPNames;

import tradesign.crypto.provider.JeTS;
import tradesign.pki.asn1.ASN1Exception;
import tradesign.pki.asn1.exception.ASN1ChoiceException;
import tradesign.pki.oss.pkix.AlgorithmIdentifier;
import tradesign.pki.oss.tsp.TSPTSTInfo;
import tradesign.pki.oss.tsp.TSPTimeStampResp;
import tradesign.pki.oss.tsp.TSPTimeStampToken;
import tradesign.pki.oss.tsp.exception.TSPTimeStampTokenVerifyException;
import tradesign.pki.pkcs.PKCSException;
import tradesign.pki.util.JetsUtil;

import com.ktnet.asn1comp.pkixcmp.PKIStatus;
import com.ktnet.tsp.client.http.TSPHttpClient;
import com.oss.asn1.DecodeFailedException;
import com.oss.asn1.DecodeNotSupportedException;
import com.oss.asn1.EncodeFailedException;
import com.oss.asn1.EncodeNotSupportedException;

/**
 * 
 * TSA 클라이언트 
 *
 */
public class TSAReqUtil {
	private byte[] input;
	private String tokenFile;
	
	public TSAReqUtil(){
	}
	
	/**
	 * 
	 * @param tsaFile	: 원본파일 Byte값
	 * @param propPath	: tradesign3280.properties의 경로
	 * @param tokenFile	: tsa_token_received.ber의 경로
	 */
	public TSAReqUtil(String tsaFile, String propPath, String tokenFile){
		try{
			this.input		= readBytesFromFile(tsaFile);
			this.tokenFile	= tokenFile;
			//초기화
			JeTS.installProvider(propPath);
			IoUtil.makFolder(tokenFile);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * input 데이터 반환
	 * @return
	 */
	public byte[] getInputData(){
		return input;
	}
	
	/**
	 * 파일을 byte배열로 반환
	 * @param filePath
	 * @return
	 */
	private byte[] readBytesFromFile(String filePath){
		FileInputStream fis	= null;
		byte[] bytesArray	= null;
		try{
			File file	= new File(filePath);
			bytesArray	= new byte[(int)file.length()];
			
			fis	= new FileInputStream(file);
			fis.read(bytesArray);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			try{if(fis!=null){fis.close();}}catch(Exception e){e.printStackTrace();}
		}
		return bytesArray;
	}
	

	/**
	 * TSA서버로 파일 전송
	 * @param hashAid	: 암호화 방식
	 * @param tsaServer	: TSA서버 정보
	 * @param id		: TSA서버 아이디
	 * @param pwd		: TSA서버 비밀번호
	 */
	public TSPTSTInfo sendRequest(AlgorithmIdentifier hashAid, String tsaServer, String id, String pwd) throws TSPTimeStampTokenVerifyException, EncodeFailedException, IOException, EncodeNotSupportedException, DecodeFailedException, DecodeNotSupportedException, PKCSException, NoSuchAlgorithmException, NoSuchProviderException, ASN1ChoiceException, ASN1Exception, URISyntaxException, KeyManagementException, UnrecoverableKeyException, KeyStoreException, CertificateException {
		TSPHttpClient client = new TSPHttpClient(tsaServer);
		HttpClient apacheClient = client.getHttpClient();
		apacheClient.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT, new Integer(5000));
		apacheClient.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT, new Integer(5000));

		client.setUser(id, pwd);
		
		ByteArrayInputStream bis = new ByteArrayInputStream(input);
		client.setTSPTimeStampRequest(hashAid, bis);

		HttpResponse httpResponse = client.execute();

		int status = httpResponse.getStatusLine().getStatusCode();
		if(status != HttpStatus.SC_OK) 
			throw new IllegalStateException("HTTP STATUS NOT OK : " + status);
		
		TSPTimeStampResp tspResonse= new TSPTimeStampResp(client.getResponseContent());
		if (tspResonse.getStatus() != PKIStatus.accepted.intValue()) 
			throw new IllegalStateException("TimeStampResp Status Not Accepted! \nStatusInfo :" + tspResonse.getStatusInfo().toString());
		
		TSPTimeStampToken token = null;
		try{
			token = tspResonse.getTimeStampToken();
		}catch(Exception e){
			throw new RuntimeException("토큰 검증 실패 : " + e.toString());
		}
		
		byte[] encoded = token.encode();
		String base64Encoded = tradesign.pki.util.JetsUtil.toBase64String(encoded);
		token.encodeFile(tokenFile);
		
		return parsingToken(base64Encoded);
	}

	/**
	 * TSA 토큰 반환
	 * @param base64Encoded 
	 * @return
	 */
	private TSPTSTInfo parsingToken(String base64Encoded) throws DecodeFailedException, EncodeFailedException, DecodeNotSupportedException, IOException, PKCSException, EncodeNotSupportedException, ASN1ChoiceException, ASN1Exception, NoSuchAlgorithmException, NoSuchProviderException {
		return new TSPTimeStampToken(JetsUtil.base64ToBytes(base64Encoded)).getTSTInfo(); 
	}
	
	/**
	 * 원본 해쉬값 추출
	 * @param path
	 * @param algorithm
	 * @return
	 * @throws Exception
	 */
	public String getHashData(String path, String algorithm) throws Exception {
		return JetsUtil.toBase64String(MessageDigest.getInstance(algorithm, "JeTS").digest(readBytesFromFile(path)));	
	}
	
	public static void main(String[] args) throws Exception {
	}
}
