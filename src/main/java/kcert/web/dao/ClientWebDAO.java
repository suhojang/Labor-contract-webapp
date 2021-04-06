package kcert.web.dao;

import java.util.List;
import java.util.Map;

import kcert.framework.service.MobileDaoSupport;
import kcert.web.vo.ClientVO;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("ClientWebDAO")
@Transactional
public class ClientWebDAO extends MobileDaoSupport {
	
	/**<PRE>
	 *  채번
	 *  sequence채번
	 * @param map
	 * @return
	 * @throws Exception
	 * </PRE>
	 */
	public synchronized long NEXT_VAL(Map<String,String> param) {
		selectByPk("nextval", param,true);
		return Long.parseLong(String.valueOf(param.get("SQ")));
	}
	/**
	 * 사용자 로그인 처리
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	public ClientVO SEL_CLA_LOGIN(ClientVO clientVO) throws Exception {
		return (ClientVO)getSqlMapClientTemplate().queryForObject("SEL_CLA_LOGIN", clientVO);
	}

	public int INS_CLA_INFO(ClientVO clientVO) throws Exception {
		return update("INS_CLA_INFO", clientVO);
	}
	public String SEL_CLA_CHECK(String ID) throws Exception {
		return (String) getSqlMapClientTemplate().queryForObject("SEL_CLA_CHECK",ID);
	}
	public int INS_EDC_DATA(Map<String, String> param) throws Exception {
		return update("INS_EDC_DATA", param);
	}
	public int INS_EDC_SIGNDATA(Map<String, String> param) throws Exception {
		return update("INS_EDC_SIGNDATA", param);
	}
	public String SEL_EDC_XMLINF(String NO) throws Exception {
		return (String) getSqlMapClientTemplate().queryForObject("SEL_EDC_XMLINF",NO);
	}
	@SuppressWarnings("unchecked")
	public Map<String, String> SEL_EDC_DATA(Map<String, String> param) throws Exception {
		return (Map<String,String>) selectByPk("SEL_EDC_DATA", param,true);
	}
	public int CLA_EDC_CRTSIGN(Map<String, String> param) throws Exception {
		return update("CLA_EDC_CRTSIGN", param);
	}
	public int CLA_EDC_UPTSTS(Map<String, String> param) throws Exception {
		return update("CLA_EDC_UPTSTS", param);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> SEL_EDC_CRTDATA01(Map<String, String> param) throws Exception {
		return list("SEL_EDC_CRTDATA01", param);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> SEL_EDC_CRTDATA02(Map<String, String> param) throws Exception {
		return list("SEL_EDC_CRTDATA02", param);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> SEL_EDC_CRTDATA03(Map<String, String> param) throws Exception {
		return list("SEL_EDC_CRTDATA03", param);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> SEL_EDC_CRTDATA04(Map<String, String> param) throws Exception {
		return list("SEL_EDC_CRTDATA04", param);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> SEL_EDC_CRTDATA05(Map<String, String> param) throws Exception {
		return list("SEL_EDC_CRTDATA05", param);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> SEL_EDC_CRTDATA06(Map<String, String> param) throws Exception {
		return list("SEL_EDC_CRTDATA06", param);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> SEL_EDC_CRTDATA07(Map<String, String> param) throws Exception {
		return list("SEL_EDC_CRTDATA07", param);
	}
	@SuppressWarnings("unchecked")
	public Map<String, String> CLA_EDC_UPT(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("CLA_EDC_UPT", param,true);
	}
	public void UPT_EDC_DATA(Map<String, String> param) throws Exception {
		update("UPT_EDC_DATA", param);
	}
	public void UPT_EDC_SIGNDATA(Map<String, String> param) throws Exception {
		update("UPT_EDC_SIGNDATA", param);
	}
	public void UPT_EDC_CRTSIGN(Map<String, String> param) throws Exception {
		update("UPT_EDC_CRTSIGN", param);
	}
	public void CLA_EDC_CNTOLDEL(Map<String, String> param) throws Exception {
		delete("CLA_EDC_CNTOLDEL", param);
	}
	public void CLA_EDC_CRTINFDEL(Map<String, String> param) throws Exception {
		delete("CLA_EDC_CRTINFDEL", param);
	}
	public void CLA_EDC_SGNINFLDEL(Map<String, String> param) throws Exception {
		delete("CLA_EDC_SGNINFLDEL", param);
	}
	public void CLA_EDC_TSAINFLDEL(Map<String, String> param) throws Exception {
		delete("CLA_EDC_TSAINFLDEL", param);
	}
	@SuppressWarnings("unchecked")
	public Map<String, String> CLA_CNT_SEL(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("CLA_CNT_SEL", param,true);
	}
	public void UPT_CLA_DATA(Map<String, String> param) throws Exception {
		update("UPT_CLA_DATA", param);
	}
	public void INS_CNT_TSA(Map<String, String> param) throws Exception {
		update("INS_CNT_TSA", param);
	}
	public void CLA_EDC_UPTADDR(Map<String, String> param) {
		update("CLA_EDC_UPTADDR", param);
	}
}
