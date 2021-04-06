package kcert.web.service;

import java.util.List;
import java.util.Map;

import kcert.web.vo.ClientVO;

public interface ClientWebService {
	
	/**<PRE>
	 *  채번
	 * @param param
	 * @return
	 * @throws Exception
	 * </PRE>
	 */
	public long NEXT_VAL (Map<String,String> param) throws Exception;
	
	/**
	 * 로그인 처리
	 * @param clientVO
	 * @return
	 * @throws Exception
	 */
	public ClientVO SEL_CLA_LOGIN(ClientVO clientVO) throws Exception;
	
	/**
	 * 회원가입 처리
	 * @param clientVO
	 * @return
	 * @throws Exception
	 */
	public int INS_CLA_INFO(ClientVO clientVO) throws Exception;

	public String SEL_CLA_CHECK(String ID) throws Exception;

	public int INS_EDC_DATA(Map<String, String> param) throws Exception;

	public int INS_EDC_SIGNDATA(Map<String, String> param) throws Exception;

	public String SEL_EDC_XMLINF(String NO) throws Exception;

	public Map<String, String> SEL_EDC_DATA(Map<String, String> param) throws Exception;

	public int CLA_EDC_CRTSIGN(Map<String, String> param) throws Exception;

	public int CLA_EDC_UPTSTS(Map<String, String> param) throws Exception;

	public List<Map<String, Object>> SEL_EDC_CRTDATA01(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> SEL_EDC_CRTDATA02(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> SEL_EDC_CRTDATA03(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> SEL_EDC_CRTDATA04(Map<String, String> param) throws Exception;

	public List<Map<String, Object>> SEL_EDC_CRTDATA05(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> SEL_EDC_CRTDATA06(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> SEL_EDC_CRTDATA07(Map<String, String> param) throws Exception;

	public Map<String, String> CLA_EDC_UPT(Map<String, String> param) throws Exception;

	public void UPT_EDC_DATA(Map<String, String> param) throws Exception;

	public void UPT_EDC_SIGNDATA(Map<String, String> param) throws Exception;

	public void UPT_EDC_CRTSIGN(Map<String, String> param) throws Exception;

	public void CLA_EDC_DEL(Map<String, String> param) throws Exception;
	
	public Map<String, String> CLA_CNT_SEL(Map<String, String> param) throws Exception;

	public void UPT_CLA_DATA(Map<String, String> param) throws Exception;

	public void INS_CNT_TSA(Map<String, String> param) throws Exception;

	public void CLA_EDC_UPTADDR(Map<String, String> param) throws Exception;
}
