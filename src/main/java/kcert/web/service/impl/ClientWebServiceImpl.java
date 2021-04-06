package kcert.web.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kcert.web.dao.ClientWebDAO;
import kcert.web.service.ClientWebService;
import kcert.web.vo.ClientVO;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

@Service("ClientWebService")
@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
public class ClientWebServiceImpl extends AbstractServiceImpl implements ClientWebService{

	
	/** ClientWebDAO */
    @Resource(name="ClientWebDAO")
	private ClientWebDAO clientWebDAO; //데이터베이스 접근 클래스

    /**<PRE>
	 *  채번
	 * @param map
	 * @return
	 * @throws Exception
	 * </PRE>
	 */
	@Override
	public synchronized long NEXT_VAL (Map<String,String> param) throws Exception{
		return clientWebDAO.NEXT_VAL(param);
	}
    
    /**
     * 로그인 처리
     */
    @Override
    public ClientVO SEL_CLA_LOGIN(ClientVO clientVO) throws Exception {
    	return clientWebDAO.SEL_CLA_LOGIN(clientVO);
    }

    /**
     * 회원가입 처리
     */
	@Override
	public int INS_CLA_INFO(ClientVO clientVO) throws Exception {
		return clientWebDAO.INS_CLA_INFO(clientVO);
	}

	@Override
	public String SEL_CLA_CHECK(String ID) throws Exception {
		return clientWebDAO.SEL_CLA_CHECK(ID);
	}

	@Override
	public int INS_EDC_DATA(Map<String, String> param) throws Exception {
		return clientWebDAO.INS_EDC_DATA(param);
	}

	@Override
	public int INS_EDC_SIGNDATA(Map<String, String> param) throws Exception {
		return clientWebDAO.INS_EDC_SIGNDATA(param);
	}

	@Override
	public String SEL_EDC_XMLINF(String NO) throws Exception {
		return clientWebDAO.SEL_EDC_XMLINF(NO);
	}

	@Override
	public Map<String, String> SEL_EDC_DATA(Map<String, String> param) throws Exception {
		return clientWebDAO.SEL_EDC_DATA(param);
	}

	@Override
	public int CLA_EDC_CRTSIGN(Map<String, String> param) throws Exception {
		return clientWebDAO.CLA_EDC_CRTSIGN(param);
	}

	@Override
	public int CLA_EDC_UPTSTS(Map<String, String> param) throws Exception {
		return clientWebDAO.CLA_EDC_UPTSTS(param);
	}

	@Override
	public Map<String, String> CLA_EDC_UPT(Map<String, String> param) throws Exception {
		return clientWebDAO.CLA_EDC_UPT(param);
	}

	@Override
	public void UPT_EDC_DATA(Map<String, String> param) throws Exception {
		clientWebDAO.UPT_EDC_DATA(param);
	}

	@Override
	public void UPT_EDC_SIGNDATA(Map<String, String> param) throws Exception {
		clientWebDAO.UPT_EDC_SIGNDATA(param);
	}

	@Override
	public void UPT_EDC_CRTSIGN(Map<String, String> param) throws Exception {
		clientWebDAO.UPT_EDC_CRTSIGN(param);
	}

	@Override
	public void CLA_EDC_DEL(Map<String, String> param) throws Exception {
		clientWebDAO.CLA_EDC_CNTOLDEL(param);
		clientWebDAO.CLA_EDC_CRTINFDEL(param);
		clientWebDAO.CLA_EDC_SGNINFLDEL(param);
		clientWebDAO.CLA_EDC_TSAINFLDEL(param);
	}

	@Override
	public Map<String, String> CLA_CNT_SEL(Map<String, String> param) throws Exception {
		return clientWebDAO.CLA_CNT_SEL(param);
	}

	@Override
	public void UPT_CLA_DATA(Map<String, String> param) throws Exception {
		clientWebDAO.UPT_CLA_DATA(param);
	}

	@Override
	public void INS_CNT_TSA(Map<String, String> param) throws Exception {
		clientWebDAO.INS_CNT_TSA(param);
	}

	@Override
	public void CLA_EDC_UPTADDR(Map<String, String> param) throws Exception {
		clientWebDAO.CLA_EDC_UPTADDR(param);
	}

	@Override
	public List<Map<String, Object>> SEL_EDC_CRTDATA01(Map<String, String> param) throws Exception {
		return clientWebDAO.SEL_EDC_CRTDATA01(param);
	}

	@Override
	public List<Map<String, Object>> SEL_EDC_CRTDATA02(Map<String, String> param) throws Exception {
		return clientWebDAO.SEL_EDC_CRTDATA02(param);
	}

	@Override
	public List<Map<String, Object>> SEL_EDC_CRTDATA03(Map<String, String> param) throws Exception {
		return clientWebDAO.SEL_EDC_CRTDATA03(param);
	}

	@Override
	public List<Map<String, Object>> SEL_EDC_CRTDATA04(Map<String, String> param) throws Exception {
		return clientWebDAO.SEL_EDC_CRTDATA04(param);
	}

	@Override
	public List<Map<String, Object>> SEL_EDC_CRTDATA05(Map<String, String> param) throws Exception {
		return clientWebDAO.SEL_EDC_CRTDATA05(param);
	}

	@Override
	public List<Map<String, Object>> SEL_EDC_CRTDATA06(Map<String, String> param) throws Exception {
		return clientWebDAO.SEL_EDC_CRTDATA06(param);
	}

	@Override
	public List<Map<String, Object>> SEL_EDC_CRTDATA07(Map<String, String> param) throws Exception {
		return clientWebDAO.SEL_EDC_CRTDATA07(param);
	}
}
