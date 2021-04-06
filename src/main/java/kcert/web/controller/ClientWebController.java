package kcert.web.controller;

import java.io.File;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kcert.framework.controller.Controllable;
import kcert.framework.service.FileDownService;
import kcert.framework.util.CryptProperties;
import kcert.framework.util.IoUtil;
import kcert.framework.util.MakePDFUtil;
import kcert.framework.util.MakeUtil;
import kcert.framework.util.SMTPUtil;
import kcert.framework.util.SupportUtil;
import kcert.framework.util.TSAReqUtil;
import kcert.web.service.ClientWebService;
import kcert.web.vo.ClientVO;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import tradesign.pki.oss.pkix.AlgorithmIdentifier;
import tradesign.pki.oss.tsp.TSPTSTInfo;
import tradesign.pki.util.JetsUtil;

import com.kcert.util.StringUtil;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @author 장수호
 * @since 2016.11.07
 * @version 1.0
 * @see 
 * <pre>
 *    
 *   수정일      	수정자                 수정내용
 *  -------    --------     ---------------------------
 * 
 * </pre>
 */
@Controller
public class ClientWebController extends Controllable {
	private transient Logger logger = Logger.getLogger(this.getClass());
	
	/** AdminService */
    @Resource(name = "ClientWebService")
    private ClientWebService clientWebService;
    
    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;
    
    @Autowired
    protected FileDownService fileDownService;

    
    @RequestMapping("/test.do")
	public String test(HttpServletRequest request, ModelMap model) throws Exception{
		
		return "/test";
	}
    
	/**
	 * 메인 페이지 이동
	 * @param request
	 * @param mainVO
	 * @param ntcVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/CLA_LGN_MAIN.do")
	public String main(HttpServletRequest request, ModelMap model) throws Exception{
		String menuCode	= request.getParameter("menuCode");
		model.addAttribute("menuCode", menuCode!=null && !"".equals(menuCode)?menuCode:MENU_CODE_9999);
		
		return "/CLA_LGN_MAIN";
	}
	
    /**
	 * 사용자 회원가입
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/LGN/CLA_LGN_SIGNUP.do")
	public String signup(HttpServletRequest request, HttpServletResponse response,Model model) throws Exception {
		return "/LGN/CLA_LGN_SIGNUP";
	}
	
	/**
	 * 사용자 회원가입
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/LGN/INS_CLA_INFO.do")
	public String signup_reg(@ModelAttribute("clientVO") ClientVO clientVO, HttpServletRequest request, HttpServletResponse response,Model model) throws Exception {
		Map<String,String> param	= new HashMap<String,String>();
		try{
			param.put("CD"		, "CLINF_NO");
			param.put("SQ"		, "0");
			
			/**채번**/
			clientVO.setNO(String.valueOf(clientWebService.NEXT_VAL(param)));
			/**데이터 암호화**/
			clientVO.setPWD(CryptProperties.encoded(clientVO.getPWD()));//비밀번호
			clientVO.setNM(CryptProperties.encoded(clientVO.getNM()));	//대표자명
			clientVO.setHP(CryptProperties.encoded(clientVO.getHP()));	//담당자 핸드폰번호
			clientVO.setEML(CryptProperties.encoded(clientVO.getEML()));//담당자 이메일주소
			
			clientWebService.INS_CLA_INFO(clientVO);
			
		}catch(Exception e){
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return "redirect:/LGN/CLA_LGN_LOGIN.do";
	}
	
	/**
	 * 아이디 중복체크
	 * @param request
	 * @param mainVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/LGN/CLA_LGN_IDCHK.do")
	public ModelAndView SEL_SIGNUP_CHECK(HttpServletRequest request, ModelMap model) throws Exception{
		String CHECKED = clientWebService.SEL_CLA_CHECK(request.getParameter("ID"));;
		
		ModelAndView mv	= new ModelAndView();
		mv.addObject("CHECKED", CHECKED);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 사용자 로그인
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/LGN/CLA_LGN_LOGIN.do")
	public String login(HttpServletRequest request, HttpServletResponse response,Model model) throws Exception {
		return "/LGN/CLA_LGN_LOGIN";
	}
	
	/**
	 * 사용자 로그인 처리
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/LGN/CLA_LGN_CHECK.do")
	public String loginCheck(@ModelAttribute("clientVO") ClientVO clientVO, HttpServletRequest request, Model model) throws Exception {
		String returnStr	= "";
		try{
			clientVO.setPWD(CryptProperties.encoded(clientVO.getPWD()));
			clientVO = clientWebService.SEL_CLA_LOGIN(clientVO);
			
			if (clientVO!=null && clientVO.getID()!=null && !"".equals(clientVO.getID())) {
				clientVO.setNM(CryptProperties.decoded(clientVO.getNM()));
				clientVO.setHP(CryptProperties.decoded(clientVO.getHP()));
				clientVO.setEML(CryptProperties.decoded(clientVO.getEML()));
				
				request.getSession().setAttribute("clientVO", clientVO);
				returnStr	= "redirect:/CLA_LGN_MAIN.do?menuCode="+MENU_CODE_0000;
			} else {
				model.addAttribute("message","아이디 또는 비밀번호를 확인하세요.");
				model.addAttribute("menuCode", null);
				returnStr	= "/LGN/CLA_LGN_LOGIN";
	        }
		}catch(Exception e){
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return returnStr;
	}
	
	/**
	 * 사용자 로그아웃 처리
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/LGN/CLA_LGN_LGNOUT.do")
	public String logout(HttpServletRequest request, Model model) throws Exception {
		request.getSession().removeAttribute("clientVO");
		
		return "redirect:/CLA_LGN_MAIN.do";
	}
	
	/**
	 * 근로계약 작성 페이지 이동
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EDC/CLA_EDC_REG.do")
	public String CLA_EDC_REG(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("menuCode", MENU_CODE_0001);
    	return "/EDC/CLA_EDC_REG";
	}
	
	/**
	 * 근로계약서 데이터 등록
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EDC/CLA_EDC_REGDATA.do")
	public ModelAndView CLA_EDC_REGDATA(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		Properties prop	= getProperties();
		ClientVO clientVO	= (ClientVO) request.getSession().getAttribute("clientVO");
		try{
			Map<String,String> map	= new HashMap<String,String>();
			map.put("CD"		, "CNTOL_NO");
			map.put("SQ"		, "0");
			
			String SEQ		= "bw"+new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"-"+SupportUtil.getZeroBaseString(String.valueOf(clientWebService.NEXT_VAL(map)),7);
			
			String OPYN	= "N";
			if(!"".equals(StringUtil.replaceNull(request.getParameter("OPAMT1"))) || !"".equals(StringUtil.replaceNull(request.getParameter("OPAMT2")))
					|| !"".equals(StringUtil.replaceNull(request.getParameter("OPAMT3"))) || !"".equals(StringUtil.replaceNull(request.getParameter("OPAMT4")))
					){
				OPYN	= "Y";
			}
			
			Map<String,String> param	= new HashMap<String,String>();
			param.put("SEQ",	SEQ);
			param.put("NO", 	clientVO.getNO());
			param.put("WKNM", 	request.getParameter("WKNM"));
			param.put("HP", 	CryptProperties.encoded(request.getParameter("HP")));
			param.put("EML", 	CryptProperties.encoded(request.getParameter("EML")));
			param.put("COLSD", 	request.getParameter("COLSD").replaceAll("-", ""));
			param.put("COLED", 	request.getParameter("COLED").replaceAll("-", ""));
			param.put("POS", 	request.getParameter("POS"));
			param.put("COB", 	request.getParameter("COB"));
			param.put("LABST", 	request.getParameter("LABST"));
			param.put("LABET", 	request.getParameter("LABET"));
			param.put("RSTST", 	request.getParameter("RSTST"));
			param.put("RSTET", 	request.getParameter("RSTET"));
			param.put("WKD", 	request.getParameter("WKD"));
			param.put("HLD", 	request.getParameter("HLD"));
			param.put("MPAY", 	request.getParameter("MPAY"));
			param.put("BNSYN", 	!"".equals(StringUtil.replaceNull(request.getParameter("BNSAMT")))?"Y":"N");
			param.put("BNSAMT", StringUtil.replaceNull(request.getParameter("BNSAMT")));
			param.put("OPYN", 	OPYN);
			param.put("OPAMT1", StringUtil.replaceNull(request.getParameter("OPAMT1")));
			param.put("OPAMT2", StringUtil.replaceNull(request.getParameter("OPAMT2")));
			param.put("OPAMT3", StringUtil.replaceNull(request.getParameter("OPAMT3")));
			param.put("OPAMT4", StringUtil.replaceNull(request.getParameter("OPAMT4")));
			param.put("DPSDAT", request.getParameter("DPSDAT"));
			param.put("MTHD", 	request.getParameter("MTHD"));
			param.put("CNTDAT", request.getParameter("CNTDAT").replaceAll("-", ""));
			//근로계약정보 저장
			clientWebService.INS_EDC_DATA(param);
			
			//수기서명 이미지 저장
			IoUtil.signImgWrite(request.getParameter("SIGN_DATA"), prop.getProperty("SIGN.SRC")+SEQ+"_sign.png");
			
			map	= new HashMap<String,String>();
			map.put("CD", 	"SGNINF_NO");
			map.put("SQ", 	"0");
			
			param	= new HashMap<String,String>();
			param.put("SGNO",	String.valueOf(clientWebService.NEXT_VAL(map)));
			param.put("CNNO",	SEQ);
			param.put("USRKN","2");
			param.put("PTH",	prop.getProperty("SIGN.SRC")+SEQ+"_sign.png");
			//수기서명정보 저장
			clientWebService.INS_EDC_SIGNDATA(param);
			
			//문서좌표정보 불러오기
			String xml	= clientWebService.SEL_EDC_XMLINF("1");
			
			param	= new HashMap<String,String>();
			param.put("CNNO",	SEQ);
			
			Map<String,String> info	=  clientWebService.SEL_EDC_DATA(param);
			info.put("WKHP", 	CryptProperties.decoded(String.valueOf(info.get("WKHP"))));
			info.put("BSCEO", 	CryptProperties.decoded(String.valueOf(info.get("BSCEO"))));
			info.put("MPAY", 	String.valueOf(info.get("MPAY")));
			info.put("BNSAMT", 	String.valueOf(info.get("BNSAMT")));
			info.put("OPAMT1", 	String.valueOf(info.get("OPAMT1")));
			info.put("OPAMT2", 	String.valueOf(info.get("OPAMT2")));
			info.put("OPAMT3", 	String.valueOf(info.get("OPAMT3")));
			info.put("OPAMT4", 	String.valueOf(info.get("OPAMT4")));
			
			String originalPDF		= prop.getProperty("ORIGINALPDF.SRC");
			String completePDF		= prop.getProperty("PDF.SRC")+SEQ+".pdf";
			
			MakePDFUtil billMaker	= new MakePDFUtil(originalPDF,completePDF);
			billMaker.makeBillPDF(info, xml, "2");
			
			mv.addObject("CNNO", 	SEQ);
			mv.addObject("HASH", 	IoUtil.makeHashSHA256(completePDF, HASH_ALGORITHM));
			mv.addObject("SGNPTH", 	prop.getProperty("CERTPDF.SRC")+SEQ+"_certSign.txt");
			mv.addObject("RESULT",	"Y");
			mv.addObject("MSG", 	"전자근로계약 등록 완료");
		}catch(Exception e){
			mv.addObject("RESULT", 	"N");
			mv.addObject("MSG", 	"전자근로계약 등록 실패 : " + e.getLocalizedMessage());
			e.printStackTrace();
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	/**
	 * 근로계약서 문서 서명
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EDC/CLA_EDC_CRTSIGN.do")
	public ModelAndView CLA_EDC_CRTSIGN(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		try{
			Map<String,String> map	= new HashMap<String,String>();
			map.put("CD"		, "CRTINF_NO");
			map.put("SQ"		, "0");
			
			String CRNO		= String.valueOf(clientWebService.NEXT_VAL(map));
			
			Map<String,String> param	= new HashMap<String,String>();
			param.put("CRNO", 	CRNO);
			param.put("CNNO", 	request.getParameter("CNNO"));
			param.put("USRKN", 	request.getParameter("USRKN"));
			param.put("PTH", 	request.getParameter("PTH"));
			
			//서명데이터 생성
			IoUtil.fileWrite(param.get("PTH"), request.getParameter("SIGNDATA").getBytes());
			//전자서명정보 저장
			clientWebService.CLA_EDC_CRTSIGN(param);
			if ("2".equals(request.getParameter("USRKN"))) {
				//근로계약정보 상태 변경(전자서명완료)
				param.put("STS", 	"02");
				clientWebService.CLA_EDC_UPTSTS(param);
			}

			mv.addObject("CNNO", request.getParameter("CNNO"));
			mv.addObject("RESULT", "Y");
			mv.addObject("MSG", "전자근로계약 서명 완료");
		}catch(Exception e){
			mv.addObject("RESULT", "N");
			mv.addObject("MSG", "전자근로계약 서명 실패 : " + e.getMessage());
			e.printStackTrace();
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 전자근로계약서 작성문서 조회 페이지 이동
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/EDC/CLA_EDC_SEL01.do")
	public String CLA_EDC_SEL01(HttpServletRequest request, ModelMap model) throws Exception{
		Properties prop		= getProperties();
		ClientVO clientVO	= (ClientVO) request.getSession().getAttribute("clientVO");
		int pageNo	= request.getParameter("pageNo")==null?1:Integer.parseInt(request.getParameter("pageNo"));
		//PaginationInfo에 필수 정보를 넣어 준다.
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(pageNo); 		//현재 페이지 번호
		paginationInfo.setRecordCountPerPage(10); 	//한 페이지에 게시되는 게시물 건수
		paginationInfo.setPageSize(10); 			//페이징 리스트의 사이즈
		
		if(clientVO!=null){
			try{
				Map<String,String> param		= new HashMap<String,String>();
				param.put("CLNO", clientVO.getNO());
				
				List<Map<String,Object>> list	= clientWebService.SEL_EDC_CRTDATA01(param);
				List<Map<String,Object>> tmplst	= new ArrayList<Map<String,Object>>();
		    	for (int i = 0; i < list.size(); i++) {
		    		Map<String,Object> map = (Map<String,Object>)list.get(i);
		    		String colsd		= String.valueOf(map.get("colsd"));
		    		String coled		= String.valueOf(map.get("coled"));
		    		String path			= prop.getProperty("PDF.SRC")+String.valueOf(map.get("cnno"))+".pdf";
		    		
		    		map.put("clhp", 	CryptProperties.decoded(String.valueOf(map.get("clhp"))));
		    		map.put("cleml", 	CryptProperties.decoded(String.valueOf(map.get("cleml"))));
		    		map.put("mpay", 	MakeUtil.getCommaNumber(String.valueOf(map.get("mpay"))));
		    		map.put("colsd", 	colsd.substring(0,4)+"-"+colsd.substring(4,6)+"-"+colsd.substring(6));
		    		map.put("coled", 	coled.substring(0,4)+"-"+coled.substring(4,6)+"-"+coled.substring(6));
		    		//파일 해쉬값 추출
		    		map.put("hash", 	new File(path).exists()?IoUtil.makeHashSHA256(path, HASH_ALGORITHM):"");
		    		
					tmplst.add(map);
				}
		    	
		    	paginationInfo.setTotalRecordCount(list.size());
		    	
		    	model.addAttribute("result", tmplst);
				model.addAttribute("totCnt", list.size());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("menuCode", MENU_CODE_0002);
		return "/EDC/CLA_EDC_SEL01";
	}
	
	@RequestMapping("/EDC/CLA_EDC_SEL02.do")
	public String CLA_EDC_SEL02(HttpServletRequest request, ModelMap model) throws Exception {
		Properties prop		= getProperties();
		ClientVO clientVO	= (ClientVO) request.getSession().getAttribute("clientVO");
		int pageNo	= request.getParameter("pageNo")==null?1:Integer.parseInt(request.getParameter("pageNo"));
		//PaginationInfo에 필수 정보를 넣어 준다.
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(pageNo); 		//현재 페이지 번호
		paginationInfo.setRecordCountPerPage(10); 	//한 페이지에 게시되는 게시물 건수
		paginationInfo.setPageSize(10); 			//페이징 리스트의 사이즈
		
		if(clientVO!=null){
			try{
				Map<String,String> param		= new HashMap<String,String>();
				param.put("CLNO", clientVO.getNO());
				
				List<Map<String,Object>> list	= clientWebService.SEL_EDC_CRTDATA02(param);
				List<Map<String,Object>> tmplst	= new ArrayList<Map<String,Object>>();
		    	for (int i = 0; i < list.size(); i++) {
		    		Map<String,Object> map = (Map<String,Object>)list.get(i);
		    		String colsd		= String.valueOf(map.get("colsd"));
		    		String coled		= String.valueOf(map.get("coled"));
		    		String path			= prop.getProperty("PDF.SRC")+String.valueOf(map.get("cnno"))+".pdf";
		    		
		    		map.put("clhp", 	CryptProperties.decoded(String.valueOf(map.get("clhp"))));
		    		map.put("cleml", 	CryptProperties.decoded(String.valueOf(map.get("cleml"))));
		    		map.put("mpay", 	MakeUtil.getCommaNumber(String.valueOf(map.get("mpay"))));
		    		map.put("colsd", 	colsd.substring(0,4)+"-"+colsd.substring(4,6)+"-"+colsd.substring(6));
		    		map.put("coled", 	coled.substring(0,4)+"-"+coled.substring(4,6)+"-"+coled.substring(6));
		    		//파일 해쉬값 추출
		    		map.put("hash", 	new File(path).exists()?IoUtil.makeHashSHA256(path, HASH_ALGORITHM):"");
		    		
					tmplst.add(map);
				}
		    	
		    	paginationInfo.setTotalRecordCount(list.size());
		    	
		    	model.addAttribute("result", tmplst);
				model.addAttribute("totCnt", list.size());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("menuCode", MENU_CODE_0002);
		return "/EDC/CLA_EDC_SEL02";
	}
	
	@RequestMapping("/EDC/CLA_EDC_SEL03.do")
	public String CLA_EDC_SEL03(HttpServletRequest request, ModelMap model) throws Exception {
		Properties prop		= getProperties();
		ClientVO clientVO	= (ClientVO) request.getSession().getAttribute("clientVO");

		int pageNo	= request.getParameter("pageNo")==null?1:Integer.parseInt(request.getParameter("pageNo"));
		//PaginationInfo에 필수 정보를 넣어 준다.
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(pageNo); 		//현재 페이지 번호
		paginationInfo.setRecordCountPerPage(10); 	//한 페이지에 게시되는 게시물 건수
		paginationInfo.setPageSize(10); 			//페이징 리스트의 사이즈
		
		if(clientVO!=null){
			try{
				
				Map<String,String> param		= new HashMap<String,String>();
				param.put("CLNO", clientVO.getNO());
				
				List<Map<String,Object>> list	= clientWebService.SEL_EDC_CRTDATA03(param);
				List<Map<String,Object>> tmplst	= new ArrayList<Map<String,Object>>();
				for (int i = 0; i < list.size(); i++) {
					Map<String,Object> map = (Map<String,Object>)list.get(i);
					String colsd		= String.valueOf(map.get("colsd"));
					String coled		= String.valueOf(map.get("coled"));
					String path			= prop.getProperty("PDF.SRC")+String.valueOf(map.get("cnno"))+".pdf";
					
					map.put("clhp", 	CryptProperties.decoded(String.valueOf(map.get("clhp"))));
					map.put("cleml", 	CryptProperties.decoded(String.valueOf(map.get("cleml"))));
					map.put("mpay", 	MakeUtil.getCommaNumber(String.valueOf(map.get("mpay"))));
					map.put("colsd", 	colsd.substring(0,4)+"-"+colsd.substring(4,6)+"-"+colsd.substring(6));
					map.put("coled", 	coled.substring(0,4)+"-"+coled.substring(4,6)+"-"+coled.substring(6));
					//파일 해쉬값 추출
					map.put("hash", 	new File(path).exists()?IoUtil.makeHashSHA256(path, HASH_ALGORITHM):"");
					
					tmplst.add(map);
				}
				
				paginationInfo.setTotalRecordCount(list.size());
				
				model.addAttribute("result", tmplst);
				model.addAttribute("totCnt", list.size());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("menuCode", MENU_CODE_0002);
		return "/EDC/CLA_EDC_SEL03";
	}
	
	@RequestMapping("/EDC/CLA_EDC_SEL04.do")
	public String CLA_EDC_SEL04(HttpServletRequest request, ModelMap model) throws Exception{
		Properties prop		= getProperties();
		ClientVO clientVO	= (ClientVO) request.getSession().getAttribute("clientVO");
		int pageNo	= request.getParameter("pageNo")==null?1:Integer.parseInt(request.getParameter("pageNo"));
		//PaginationInfo에 필수 정보를 넣어 준다.
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(pageNo); 		//현재 페이지 번호
		paginationInfo.setRecordCountPerPage(10); 	//한 페이지에 게시되는 게시물 건수
		paginationInfo.setPageSize(10); 			//페이징 리스트의 사이즈
		
		if(clientVO!=null){
			try{
				Map<String,String> param		= new HashMap<String,String>();
				param.put("CLNO", clientVO.getNO());
				
				List<Map<String,Object>> list	= clientWebService.SEL_EDC_CRTDATA04(param);
				List<Map<String,Object>> tmplst	= new ArrayList<Map<String,Object>>();
				for (int i = 0; i < list.size(); i++) {
					Map<String,Object> map = (Map<String,Object>)list.get(i);
					String colsd		= String.valueOf(map.get("colsd"));
					String coled		= String.valueOf(map.get("coled"));
					String path			= prop.getProperty("PDF.SRC")+String.valueOf(map.get("cnno"))+".pdf";
					
					map.put("clhp", 	CryptProperties.decoded(String.valueOf(map.get("clhp"))));
					map.put("cleml", 	CryptProperties.decoded(String.valueOf(map.get("cleml"))));
					map.put("mpay", 	MakeUtil.getCommaNumber(String.valueOf(map.get("mpay"))));
					map.put("colsd", 	colsd.substring(0,4)+"-"+colsd.substring(4,6)+"-"+colsd.substring(6));
					map.put("coled", 	coled.substring(0,4)+"-"+coled.substring(4,6)+"-"+coled.substring(6));
					//파일 해쉬값 추출
					map.put("hash", 	new File(path).exists()?IoUtil.makeHashSHA256(path, HASH_ALGORITHM):"");
					
					tmplst.add(map);
				}
				
				paginationInfo.setTotalRecordCount(list.size());
				
				model.addAttribute("result", tmplst);
				model.addAttribute("totCnt", list.size());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("menuCode", MENU_CODE_0002);
		return "/EDC/CLA_EDC_SEL04";
	}
	
	@RequestMapping("/EDC/CLA_EDC_SEL05.do")
	public String CLA_EDC_SEL05(HttpServletRequest request, ModelMap model) throws Exception{
		Properties prop		= getProperties();
		ClientVO clientVO	= (ClientVO) request.getSession().getAttribute("clientVO");
		int pageNo	= request.getParameter("pageNo")==null?1:Integer.parseInt(request.getParameter("pageNo"));
		//PaginationInfo에 필수 정보를 넣어 준다.
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(pageNo); 		//현재 페이지 번호
		paginationInfo.setRecordCountPerPage(10); 	//한 페이지에 게시되는 게시물 건수
		paginationInfo.setPageSize(10); 			//페이징 리스트의 사이즈
		
		if(clientVO!=null){
			try{
				Map<String,String> param		= new HashMap<String,String>();
				param.put("CLNO", clientVO.getNO());
				
				List<Map<String,Object>> list	= clientWebService.SEL_EDC_CRTDATA05(param);
				List<Map<String,Object>> tmplst	= new ArrayList<Map<String,Object>>();
				for (int i = 0; i < list.size(); i++) {
					Map<String,Object> map = (Map<String,Object>)list.get(i);
					String colsd		= String.valueOf(map.get("colsd"));
					String coled		= String.valueOf(map.get("coled"));
					String path			= prop.getProperty("PDF.SRC")+String.valueOf(map.get("cnno"))+".pdf";
					
					map.put("clhp", 	CryptProperties.decoded(String.valueOf(map.get("clhp"))));
					map.put("cleml", 	CryptProperties.decoded(String.valueOf(map.get("cleml"))));
					map.put("mpay", 	MakeUtil.getCommaNumber(String.valueOf(map.get("mpay"))));
					map.put("colsd", 	colsd.substring(0,4)+"-"+colsd.substring(4,6)+"-"+colsd.substring(6));
					map.put("coled", 	coled.substring(0,4)+"-"+coled.substring(4,6)+"-"+coled.substring(6));
					//파일 해쉬값 추출
					map.put("hash", 	new File(path).exists()?IoUtil.makeHashSHA256(path, HASH_ALGORITHM):"");
					
					tmplst.add(map);
				}
				
				paginationInfo.setTotalRecordCount(list.size());
				
				model.addAttribute("result", tmplst);
				model.addAttribute("totCnt", list.size());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("menuCode", MENU_CODE_0002);
		return "/EDC/CLA_EDC_SEL05";
	}
	
	@RequestMapping("/EDC/CLA_EDC_SEL06.do")
	public String CLA_EDC_SEL06(HttpServletRequest request, ModelMap model) throws Exception{
		Properties prop		= getProperties();
		ClientVO clientVO	= (ClientVO) request.getSession().getAttribute("clientVO");
		int pageNo	= request.getParameter("pageNo")==null?1:Integer.parseInt(request.getParameter("pageNo"));
		//PaginationInfo에 필수 정보를 넣어 준다.
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(pageNo); 		//현재 페이지 번호
		paginationInfo.setRecordCountPerPage(10); 	//한 페이지에 게시되는 게시물 건수
		paginationInfo.setPageSize(10); 			//페이징 리스트의 사이즈
		
		if(clientVO!=null){
			try{
				Map<String,String> param		= new HashMap<String,String>();
				param.put("CLNO", clientVO.getNO());
				
				List<Map<String,Object>> list	= clientWebService.SEL_EDC_CRTDATA06(param);
				List<Map<String,Object>> tmplst	= new ArrayList<Map<String,Object>>();
				for (int i = 0; i < list.size(); i++) {
					Map<String,Object> map = (Map<String,Object>)list.get(i);
					String colsd		= String.valueOf(map.get("colsd"));
					String coled		= String.valueOf(map.get("coled"));
					String path			= prop.getProperty("PDF.SRC")+String.valueOf(map.get("cnno"))+".pdf";
					
					map.put("clhp", 	CryptProperties.decoded(String.valueOf(map.get("clhp"))));
					map.put("cleml", 	CryptProperties.decoded(String.valueOf(map.get("cleml"))));
					map.put("mpay", 	MakeUtil.getCommaNumber(String.valueOf(map.get("mpay"))));
					map.put("colsd", 	colsd.substring(0,4)+"-"+colsd.substring(4,6)+"-"+colsd.substring(6));
					map.put("coled", 	coled.substring(0,4)+"-"+coled.substring(4,6)+"-"+coled.substring(6));
					//파일 해쉬값 추출
					map.put("hash", 	new File(path).exists()?IoUtil.makeHashSHA256(path, HASH_ALGORITHM):"");
					
					tmplst.add(map);
				}
				
				paginationInfo.setTotalRecordCount(list.size());
				
				model.addAttribute("result", tmplst);
				model.addAttribute("totCnt", list.size());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("menuCode", MENU_CODE_0004);
		return "/EDC/CLA_EDC_SEL06";
	}
	
	@RequestMapping("/EDC/CLA_EDC_SEL07.do")
	public String CLA_EDC_SEL07(HttpServletRequest request, ModelMap model) throws Exception{
		Properties prop		= getProperties();
		ClientVO clientVO	= (ClientVO) request.getSession().getAttribute("clientVO");
		int pageNo	= request.getParameter("pageNo")==null?1:Integer.parseInt(request.getParameter("pageNo"));
		//PaginationInfo에 필수 정보를 넣어 준다.
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(pageNo); 		//현재 페이지 번호
		paginationInfo.setRecordCountPerPage(10); 	//한 페이지에 게시되는 게시물 건수
		paginationInfo.setPageSize(10); 			//페이징 리스트의 사이즈
		
		if(clientVO!=null){
			try{
				Map<String,String> param		= new HashMap<String,String>();
				param.put("CLNO", clientVO.getNO());
				
				List<Map<String,Object>> list	= clientWebService.SEL_EDC_CRTDATA07(param);
				List<Map<String,Object>> tmplst	= new ArrayList<Map<String,Object>>();
				for (int i = 0; i < list.size(); i++) {
					Map<String,Object> map = (Map<String,Object>)list.get(i);
					String colsd		= String.valueOf(map.get("colsd"));
					String coled		= String.valueOf(map.get("coled"));
					String path			= prop.getProperty("PDF.SRC")+String.valueOf(map.get("cnno"))+".pdf";
					
					map.put("clhp", 	CryptProperties.decoded(String.valueOf(map.get("clhp"))));
					map.put("cleml", 	CryptProperties.decoded(String.valueOf(map.get("cleml"))));
					map.put("mpay", 	MakeUtil.getCommaNumber(String.valueOf(map.get("mpay"))));
					map.put("colsd", 	colsd.substring(0,4)+"-"+colsd.substring(4,6)+"-"+colsd.substring(6));
					map.put("coled", 	coled.substring(0,4)+"-"+coled.substring(4,6)+"-"+coled.substring(6));
					//파일 해쉬값 추출
					map.put("hash", 	new File(path).exists()?IoUtil.makeHashSHA256(path, HASH_ALGORITHM):"");
					
					tmplst.add(map);
				}
				
				paginationInfo.setTotalRecordCount(list.size());
				
				model.addAttribute("result", tmplst);
				model.addAttribute("totCnt", list.size());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("menuCode", MENU_CODE_0004);
		return "/EDC/CLA_EDC_SEL07";
	}
	
	@RequestMapping(value="/EDC/CLA_SND_MAIL.do")
	public ModelAndView CLA_SND_MAIL(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		Map<String,Object> map	= new HashMap<String,Object>();
		
		String cnno	= request.getParameter("CNNO");
		String to	= request.getParameter("EMAIL");
		String from	= "";
		String title	= "고용업체 ["+request.getParameter("BSNM")+"]에서 보낸 전자근로계약서 입니다.";
		String loc	= request.getParameter("LOC");
		
		try{
			//메일전송
			map	= SMTPUtil.sendmail(to, from, title, "http://"+loc+"/CLA/CLA_CNT_SEL.do?cnno="+cnno);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{
				Map<String,String> param	= new HashMap<String,String>();
				param.put("CNNO", 	cnno);
				param.put("STS", 	"03");
				clientWebService.CLA_EDC_UPTSTS(param);
			}catch(Exception e){
				e.printStackTrace();
			}
			
			mv.addObject("success", String.valueOf(map.get("success")));
			mv.addObject("MSG", 	String.valueOf(map.get("MSG")));
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	/**
	 * 전자근로계약서 수정 페이지 이동
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/EDC/CLA_EDC_UPT.do")
	public String CLA_EDC_UPT(HttpServletRequest request, ModelMap model) throws Exception{
		Map<String,String> param		= new HashMap<String,String>();
		param.put("CNNO", request.getParameter("cnno"));
		
		try{
			Map<String,String> map	= clientWebService.CLA_EDC_UPT(param);
			
			String COLSD	= String.valueOf(map.get("COLSD"));
			String COLED	= String.valueOf(map.get("COLED"));
			String CNTDAT	= String.valueOf(map.get("CNTDAT"));
			
			map.put("CLHP", 	CryptProperties.decoded(String.valueOf(map.get("CLHP"))));
			map.put("CLEML", 	CryptProperties.decoded(String.valueOf(map.get("CLEML"))));
			map.put("MPAY", 	MakeUtil.getCommaNumber(String.valueOf(map.get("MPAY"))));
			map.put("BNSAMT", 	MakeUtil.getCommaNumber(String.valueOf(map.get("BNSAMT"))));
			map.put("OPAMT1", 	MakeUtil.getCommaNumber(String.valueOf(map.get("OPAMT1"))));
			map.put("OPAMT2", 	MakeUtil.getCommaNumber(String.valueOf(map.get("OPAMT2"))));
			map.put("OPAMT3", 	MakeUtil.getCommaNumber(String.valueOf(map.get("OPAMT3"))));
			map.put("OPAMT4", 	MakeUtil.getCommaNumber(String.valueOf(map.get("OPAMT4"))));
			map.put("COLSD", 	COLSD.substring(0,4)+"-"+COLSD.substring(4,6)+"-"+COLSD.substring(6));
			map.put("COLED", 	COLED.substring(0,4)+"-"+COLED.substring(4,6)+"-"+COLED.substring(6));
			map.put("CNTDAT", 	CNTDAT.substring(0,4)+"-"+CNTDAT.substring(4,6)+"-"+CNTDAT.substring(6));
	    	
	    	model.addAttribute("result", map);
		}catch(Exception e){
			e.printStackTrace();
		}
		model.addAttribute("menuCode", MENU_CODE_0003);
		
		return "/EDC/CLA_EDC_UPT";
	}
	
	/**
	 * 근로계약서 데이터 수정
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EDC/CLA_EDC_UPTDATA.do")
	public ModelAndView CLA_EDC_UPTDATA(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		Properties prop	= getProperties();
		ClientVO clientVO	= (ClientVO) request.getSession().getAttribute("clientVO");
		try{
			String SEQ		= request.getParameter("CNNO");
			
			String OPYN	= "N";
			if(!"".equals(StringUtil.replaceNull(request.getParameter("OPAMT1"))) || !"".equals(StringUtil.replaceNull(request.getParameter("OPAMT2")))
					|| !"".equals(StringUtil.replaceNull(request.getParameter("OPAMT3"))) || !"".equals(StringUtil.replaceNull(request.getParameter("OPAMT4")))
					){
				OPYN	= "Y";
			}
			
			Map<String,String> param	= new HashMap<String,String>();
			param.put("SEQ",	SEQ);
			param.put("NO", 	clientVO.getNO());
			param.put("WKNM", 	request.getParameter("WKNM"));
			param.put("HP", 	CryptProperties.encoded(request.getParameter("HP")));
			param.put("EML", 	CryptProperties.encoded(request.getParameter("EML")));
			param.put("COLSD", 	request.getParameter("COLSD").replaceAll("-", ""));
			param.put("COLED", 	request.getParameter("COLED").replaceAll("-", ""));
			param.put("POS", 	request.getParameter("POS"));
			param.put("COB", 	request.getParameter("COB"));
			param.put("LABST", 	request.getParameter("LABST"));
			param.put("LABET", 	request.getParameter("LABET"));
			param.put("RSTST", 	request.getParameter("RSTST"));
			param.put("RSTET", 	request.getParameter("RSTET"));
			param.put("WKD", 	request.getParameter("WKD"));
			param.put("HLD", 	request.getParameter("HLD"));
			param.put("MPAY", 	request.getParameter("MPAY"));
			param.put("BNSYN", 	!"".equals(StringUtil.replaceNull(request.getParameter("BNSAMT")))?"Y":"N");
			param.put("BNSAMT", StringUtil.replaceNull(request.getParameter("BNSAMT")));
			param.put("OPYN", 	OPYN);
			param.put("OPAMT1", StringUtil.replaceNull(request.getParameter("OPAMT1")));
			param.put("OPAMT2", StringUtil.replaceNull(request.getParameter("OPAMT2")));
			param.put("OPAMT3", StringUtil.replaceNull(request.getParameter("OPAMT3")));
			param.put("OPAMT4", StringUtil.replaceNull(request.getParameter("OPAMT4")));
			param.put("DPSDAT", request.getParameter("DPSDAT"));
			param.put("MTHD", 	request.getParameter("MTHD"));
			param.put("CNTDAT", request.getParameter("CNTDAT").replaceAll("-", ""));
			//근로계약정보 저장
			clientWebService.UPT_EDC_DATA(param);
			
			//수기서명 이미지 저장
			IoUtil.signImgWrite(request.getParameter("SIGN_DATA"), prop.getProperty("SIGN.SRC")+SEQ+"_sign.png");
			
			String SGNO		= request.getParameter("SGNO");
			
			param	= new HashMap<String,String>();
			param.put("SGNO",	SGNO);
			param.put("CNNO",	SEQ);
			param.put("USRKN","2");
			param.put("PTH",	prop.getProperty("SIGN.SRC")+SEQ+"_sign.png");
			//수기서명정보 저장
			clientWebService.UPT_EDC_SIGNDATA(param);
			
			//문서좌표정보 불러오기
			String xml	= clientWebService.SEL_EDC_XMLINF("1");
			
			param	= new HashMap<String,String>();
			param.put("CNNO",	SEQ);
			
			Map<String,String> info	=  clientWebService.SEL_EDC_DATA(param);
			info.put("WKHP", 	CryptProperties.decoded(String.valueOf(info.get("WKHP"))));
			info.put("BSCEO", 	CryptProperties.decoded(String.valueOf(info.get("BSCEO"))));
			info.put("MPAY", 	String.valueOf(info.get("MPAY")));
			info.put("BNSAMT", 	String.valueOf(info.get("BNSAMT")));
			info.put("OPAMT1", 	String.valueOf(info.get("OPAMT1")));
			info.put("OPAMT2", 	String.valueOf(info.get("OPAMT2")));
			info.put("OPAMT3", 	String.valueOf(info.get("OPAMT3")));
			info.put("OPAMT4", 	String.valueOf(info.get("OPAMT4")));
			
			String originalPDF		= prop.getProperty("ORIGINALPDF.SRC");
			String completePDF		= prop.getProperty("PDF.SRC")+SEQ+".pdf";
			MakePDFUtil billMaker	= new MakePDFUtil(originalPDF,completePDF);
			billMaker.makeBillPDF(info, xml, "2");
			

			mv.addObject("CNNO", 	SEQ);
			mv.addObject("CRNO",	request.getParameter("CRNO"));
			mv.addObject("HASH", 	IoUtil.makeHashSHA256(completePDF, HASH_ALGORITHM));
			mv.addObject("SGNPTH", 	prop.getProperty("CERTPDF.SRC")+SEQ+"_certSign.txt");
			mv.addObject("RESULT",	"Y");
			mv.addObject("MSG", 	"전자근로계약 수정 완료");
		}catch(Exception e){
			mv.addObject("RESULT", 	"N");
			mv.addObject("MSG", 	"전자근로계약 수정 실패 : " + e.getLocalizedMessage());
			e.printStackTrace();
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 근로계약서 문서 서명 변경
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EDC/CLA_EDC_UPTCRTSIGN.do")
	public ModelAndView CLA_EDC_UPTCRTSIGN(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		try{
			String SEQ		= request.getParameter("CRNO");

			Map<String,String> param	= new HashMap<String,String>();
			param.put("CRNO", 	SEQ);
			param.put("CNNO", 	request.getParameter("CNNO"));
			param.put("USRKN", 	request.getParameter("USRKN"));
			param.put("PTH", 	request.getParameter("PTH"));
			//서명데이터 생성
			IoUtil.fileWrite(param.get("PTH"), request.getParameter("SIGNDATA").getBytes());
			//전자서명정보 저장
			clientWebService.UPT_EDC_CRTSIGN(param);
			//근로계약정보 상태 변경(전자서명완료)
			param.put("STS", 	"02");
			clientWebService.CLA_EDC_UPTSTS(param);

			mv.addObject("RESULT", "Y");
			mv.addObject("MSG", "전자근로계약 서명 완료");
		}catch(Exception e){
			mv.addObject("RESULT", "N");
			mv.addObject("MSG", "전자근로계약 서명 실패 : " + e.getMessage());
			e.printStackTrace();
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 근로계약서 문서 서명 변경
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EDC/CLA_EDC_DEL.do")
	public ModelAndView CLA_EDC_DEL(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		Properties prop	= getProperties();
		String CNNO		= request.getParameter("CNNO");
		try{
			Map<String,String> param	= new HashMap<String,String>();
			param.put("CNNO", 	CNNO);
			
			clientWebService.CLA_EDC_DEL(param);
			
			String pdfSrc		= prop.getProperty("PDF.SRC")+CNNO+".pdf"; 
			String signSrc		= prop.getProperty("SIGN.SRC")+CNNO+"_sign.png"; 
			String certPDFSrc	= prop.getProperty("CERTPDF.SRC")+CNNO+"_complete.sign"; 
			IoUtil.delete(pdfSrc);
			IoUtil.delete(signSrc);
			IoUtil.delete(certPDFSrc);
			
			mv.addObject("RESULT", "Y");
			mv.addObject("MSG", "전자근로계약 삭제 완료");
		}catch(Exception e){
			mv.addObject("RESULT", "N");
			mv.addObject("MSG", "전자근로계약 삭제 실패 : " + e.getMessage());
			e.printStackTrace();
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 전자근로계약서 근로자 페이지 이동
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/CLA/CLA_CNT_SEL.do")
	public String CLA_CNT_SEL(HttpServletRequest request, ModelMap model) throws Exception{
		Map<String,String> param		= new HashMap<String,String>();
		param.put("CNNO", request.getParameter("cnno"));
		
		try{
			Map<String,String> map	= clientWebService.CLA_CNT_SEL(param);
			
			String COLSD	= String.valueOf(map.get("COLSD"));
			String COLED	= String.valueOf(map.get("COLED"));
			String CNTDAT	= String.valueOf(map.get("CNTDAT"));
			
			map.put("CLHP", 	CryptProperties.decoded(String.valueOf(map.get("CLHP"))));
			map.put("CLEML", 	CryptProperties.decoded(String.valueOf(map.get("CLEML"))));
			map.put("CLEML2", 	CryptProperties.decoded(String.valueOf(map.get("CLEML2"))));
			map.put("MPAY", 	MakeUtil.getCommaNumber(String.valueOf(map.get("MPAY"))));
			map.put("BNSAMT", 	MakeUtil.getCommaNumber(String.valueOf(map.get("BNSAMT"))));
			map.put("OPAMT1", 	MakeUtil.getCommaNumber(String.valueOf(map.get("OPAMT1"))));
			map.put("OPAMT2", 	MakeUtil.getCommaNumber(String.valueOf(map.get("OPAMT2"))));
			map.put("OPAMT3", 	MakeUtil.getCommaNumber(String.valueOf(map.get("OPAMT3"))));
			map.put("OPAMT4", 	MakeUtil.getCommaNumber(String.valueOf(map.get("OPAMT4"))));
			map.put("COLSD", 	COLSD.substring(0,4)+"-"+COLSD.substring(4,6)+"-"+COLSD.substring(6));
			map.put("COLED", 	COLED.substring(0,4)+"-"+COLED.substring(4,6)+"-"+COLED.substring(6));
			map.put("CNTDAT", 	CNTDAT.substring(0,4)+"-"+CNTDAT.substring(4,6)+"-"+CNTDAT.substring(6));
	    	
	    	model.addAttribute("result", map);
	    	
	    	//문서전송상태 일 경우 열람상태로 변경
	    	if("03".equals(map.get("STS"))){
	    		param.put("STS", 	"04");
	    		clientWebService.CLA_EDC_UPTSTS(param);
	    	}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return "/CLA/CLA_CNT_SEL";
	}
	
	/**
	 * 근로계약서 반려하기
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/CLA/CLA_CNT_FAIL.do")
	public ModelAndView CLA_CNT_FAIL(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		try{
			Map<String,String> param	= new HashMap<String,String>();
			param.put("CNNO",	request.getParameter("CNNO"));
			param.put("STS", 	"05");	//반려
			param.put("RCNTNT", request.getParameter("RCNTNT"));
			
			clientWebService.UPT_CLA_DATA(param);
			
			mv.addObject("RESULT", "Y");
			mv.addObject("MSG", "반려 되었습니다.");
		}catch(Exception e){
			mv.addObject("RESULT", "N");
			mv.addObject("MSG", e.getMessage());
			e.printStackTrace();
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 근로계약서 계약 완료 하기
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/CLA/CLA_CNT_UPTDATA.do")
	public ModelAndView CLA_CNT_UPTDATA(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		Properties prop	= getProperties();
		Map<String,String> param	= new HashMap<String,String>();
		try{
			String CNNO	= request.getParameter("CNNO");
			
			param	= new HashMap<String,String>();
			param.put("CD"		, "SGNINF_NO");
			param.put("SQ"		, "0");
			param.put("SGNO",	String.valueOf(clientWebService.NEXT_VAL(param)));
			param.put("CNNO",	CNNO);
			param.put("USRKN",	"1");
			param.put("PTH",	prop.getProperty("SIGN.SRC")+CNNO+"_psign.png");
			//수기서명정보 저장
			clientWebService.INS_EDC_SIGNDATA(param);
			//수기서명 이미지 저장
			IoUtil.signImgWrite(request.getParameter("SIGN_DATA"), prop.getProperty("PSIGN.SRC")+CNNO+"_psign.png");
			
			//문서좌표정보 불러오기
			String xml	= clientWebService.SEL_EDC_XMLINF("1");
			
			param	= new HashMap<String,String>();
			param.put("CNNO",	CNNO);
			param.put("WKADDR", request.getParameter("WKADDR"));
			clientWebService.CLA_EDC_UPTADDR(param);	//근로자주소변경
			
			Map<String,String> info	=  clientWebService.SEL_EDC_DATA(param);
			info.put("WKHP", 	CryptProperties.decoded(String.valueOf(info.get("WKHP"))));
			info.put("BSCEO", 	CryptProperties.decoded(String.valueOf(info.get("BSCEO"))));
			info.put("MPAY", 	String.valueOf(info.get("MPAY")));
			info.put("BNSAMT", 	String.valueOf(info.get("BNSAMT")));
			info.put("OPAMT1", 	String.valueOf(info.get("OPAMT1")));
			info.put("OPAMT2", 	String.valueOf(info.get("OPAMT2")));
			info.put("OPAMT3", 	String.valueOf(info.get("OPAMT3")));
			info.put("OPAMT4", 	String.valueOf(info.get("OPAMT4")));
			
			String originalPDF		= prop.getProperty("PDF.SRC")+CNNO+".pdf";
			String completePDF		= prop.getProperty("COMPLETE.PDF.SRC")+CNNO+".pdf";
			MakePDFUtil billMaker	= new MakePDFUtil(originalPDF,completePDF);
			billMaker.makeBillPDF(info, xml, "1");
			
			param.put("CNNO", 	CNNO);
			param.put("STS", 	"99");
			clientWebService.CLA_EDC_UPTSTS(param);
			
			param	= new HashMap<String,String>();
			param.put("CD"		, "CRTINF_NO");
			param.put("SQ"		, "0");
			
			mv.addObject("CNNO", 	CNNO);
			mv.addObject("CRNO",	String.valueOf(clientWebService.NEXT_VAL(param)));
			mv.addObject("HASH", 	IoUtil.makeHashSHA256(completePDF, HASH_ALGORITHM));
			mv.addObject("SGNPTH", 	prop.getProperty("CERTPDF.SRC")+CNNO+"_certPsign.txt");
			mv.addObject("RESULT","Y");
			mv.addObject("MSG","전자근로계약이 완료 되었습니다.");
		}catch(Exception e){
			mv.addObject("RESULT","N");
			mv.addObject("MSG",e.getMessage());
			e.printStackTrace();
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	/**
	 * 근로계약서 TSA
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/CLA/CLA_CNT_TSA.do")
	public ModelAndView CLA_CNT_TSA(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		Properties prop	= getProperties();
		Map<String,String> param	= new HashMap<String,String>();
		String CNNO		= request.getParameter("CNNO");
		try{
			String originalFile	= prop.getProperty("COMPLETE.PDF.SRC")+CNNO+".pdf";
			String propPath		= prop.getProperty("TSA.PROP");
			String tsaFile		= prop.getProperty("TSA.TKFILE")+"tsa_token_received_"+CNNO+".ber";
			
			TSAReqUtil tsaReqUtil	= new TSAReqUtil(originalFile, propPath, tsaFile);
			TSPTSTInfo tstInfo		= tsaReqUtil.sendRequest(AlgorithmIdentifier.id_sha256, prop.getProperty("TSA.SERVER"), prop.getProperty("TSA.ID"), prop.getProperty("TSA.PWD"));
			
			String DN 		= tstInfo.getTsa().getDirectoryName().getName();	
			String ISUTM 	= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(tstInfo.getGenTime());	
			String ALGM 	= AlgorithmIdentifier.getAlgorithmName(tstInfo.getHashAlgorithm());
			String HSHVL 	= JetsUtil.toBase64String(MessageDigest.getInstance(ALGM, "JeTS").digest(tsaReqUtil.getInputData()));	
			
			param.put("CD"		, "TSAINF_NO");
			param.put("SQ"		, "0");
			
			param.put("TSNO",	String.valueOf(clientWebService.NEXT_VAL(param)));
			param.put("CNNO",	CNNO);
			param.put("RLT",	"Y");
			param.put("DN",		DN);
			param.put("ISUTM",	ISUTM);
			param.put("ALGM",	ALGM);
			param.put("HSHVL",	HSHVL);
			
			//TSA정보 저장
			clientWebService.INS_CNT_TSA(param);
			
			String to	= request.getParameter("EMAIL");
			String to2	= request.getParameter("EMAIL2");
			String from	= "";
			String title	= "고용업체 ["+request.getParameter("BSNM")+"]와 체결 된 전자근로계약서 입니다.";
			String content	= "고용업체 ["+request.getParameter("BSNM")+"]와 체결 된 전자근로계약서 파일 입니다.";
			
			//메일전송
			SMTPUtil.sendmail(to, from, title, content, SMTPUtil.SMTP_TAR_HTML, originalFile);
			SMTPUtil.sendmail(to2, from, title, content, SMTPUtil.SMTP_TAR_HTML, originalFile);
			
			mv.addObject("RESULT","Y");
			mv.addObject("MSG","전자근로계약이 완료 되었습니다.");
		}catch(Exception e){
			mv.addObject("RESULT","N");
			mv.addObject("MSG",e.getMessage());
			e.printStackTrace();
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 파일 HASH 추출
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EDC/CLA_EDC_HASH.do")
	public ModelAndView CLA_EDC_HASH(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		ModelAndView mv	= new ModelAndView();
		Properties prop	= getProperties();
		String CNNO		= request.getParameter("cnno");
		try{
			//fileDownService.fileDown(prop.getProperty("PDF.SRC")+CNNO+".pdf", CNNO+".pdf", request, response);
			//클라이언트 다운로드 작업 실행
			String clientDownPath	= "C:"+File.separator+"kcplaa"+File.separator+CNNO+".pdf";
			mv.addObject("PTH", 	clientDownPath);
			mv.addObject("SGNPTH", 	prop.getProperty("PDF.SRC")+CNNO+"_complete.sign");
			mv.addObject("RESULT","Y");
			mv.addObject("MSG","파일다운이 완료되었습니다.");
		}catch(Exception e){
			mv.addObject("RESULT","N");
			mv.addObject("MSG",e.getMessage());
			e.printStackTrace();
		}
		mv.setViewName("jsonView");
		
		return mv;
	}
}

