package kcert.bill;

import java.util.HashMap;
import java.util.Map;

import org.dom4j.Element;

import com.kcert.util.StringUtil;

import kcert.bill.maker.BillMaker;
import kcert.bill.rec.BillRec;
import kcert.framework.util.JXParser;
import kcert.framework.util.SupportUtil;

//표준근로계약서
public class A01 extends BillMaker {
	private final int xWidth	= 6;
	private Map<String,String> location;
	
	public A01(BillRec rec, String locationXML, String type)  throws Exception{
		super(rec,locationXML,1,type);
	}
	
	public void page_1(String locationXML, String type) throws Exception {
		location		= getLocMap(new JXParser(locationXML), 1);
		//근로자
		if("1".equals(type)){
			addText(StringUtil.replaceNull(rec.wkaddr), getLocInt("wkaddr"+X), getLocInt("wkaddr"+Y));	//근로자주소
	        addText(SupportUtil.convertHP(rec.wkhp), getLocInt("wkhp"+X), getLocInt("wkhp"+Y));			//근로자연락처
	        addText(rec.wknm, getLocInt("wknm2"+X), getLocInt("wknm2"+Y));			//근로자명
	        addPsign(prop.getProperty("PSIGN.SRC")+rec.cnno+"_psign.png",getLocInt("sign2"+X), getLocInt("sign2"+Y), 100, 50);			//근로자sign
		}
		//고용주
		else{
			//사업체명 8글자 이상일 시 왼쪽좌표로 이동
			addText(rec.bsnm, rec.bsnm.length() > 8 ? getLocInt("bsnm1"+X)-((rec.bsnm.length()-8)*xWidth) : getLocInt("bsnm1"+X), getLocInt("bsnm1"+Y));	//사업체명
	        addText(rec.wknm, getLocInt("wknm1"+X), getLocInt("wknm1"+Y));			//근로자명
	        addText(rec.colsd.substring(0,4), getLocInt("colsd1"+X), getLocInt("colsd1"+Y));		//근로계약시작일(년)
	        addText(rec.colsd.substring(4,6), getLocInt("colsd2"+X), getLocInt("colsd2"+Y));		//근로계약시작일(월)
	        addText(rec.colsd.substring(6), getLocInt("colsd3"+X), getLocInt("colsd3"+Y));		//근로계약시작일(일)
	        addText(rec.coled.substring(0,4), getLocInt("coled1"+X), getLocInt("coled1"+Y));		//근로계약종료일(년)
	        addText(rec.coled.substring(4,6), getLocInt("coled2"+X), getLocInt("coled2"+Y));		//근로계약종료일(월)
	        addText(rec.coled.substring(6), getLocInt("coled3"+X), getLocInt("coled3"+Y));		//근로계약종료일(일)
	        addText(rec.pos, getLocInt("pos"+X), getLocInt("pos"+Y));				//근무장소
	        addText(rec.cob, getLocInt("cob"+X), getLocInt("cob"+Y));				//업무의내용
	        addText(rec.labst.substring(0,2), getLocInt("labst1"+X), getLocInt("labst1"+Y));		//소정근로시작시간(시)
	        addText(rec.labst.substring(2), getLocInt("labst2"+X), getLocInt("labst2"+Y));		//소정근로시작시간(분)
	        addText(rec.labet.substring(0,2), getLocInt("labet1"+X), getLocInt("labet1"+Y));		//소정근로종료시간(시)
	        addText(rec.labet.substring(2), getLocInt("labet2"+X), getLocInt("labet2"+Y));		//소정근로종료시간(분)
	        addText(rec.rstst.substring(0,2), getLocInt("rstst1"+X), getLocInt("rstst1"+Y));		//휴게시작시간(시)
	        addText(rec.rstst.substring(2), getLocInt("rstst2"+X), getLocInt("rstst2"+Y));		//휴게시작시간(분)
	        addText(rec.rstet.substring(0,2), getLocInt("rstet1"+X), getLocInt("rstet1"+Y));		//휴게종료시간(시)
	        addText(rec.rstet.substring(2), getLocInt("rstet2"+X), getLocInt("rstet2"+Y));		//휴게종료시간(분)
	        addText(rec.wkd, getLocInt("wkd"+X), getLocInt("wkd"+Y));				//근무일수(매주)
	        addText(rec.hld, getLocInt("hld"+X), getLocInt("hld"+Y));				//휴일(요일)
	        addText(StringUtil.makeMoneyType(rec.mpay), getLocInt("mpay"+X), getLocInt("mpay"+Y));			//월급
	        
	        //상여금여부
	        if ("Y".equals(rec.bnsyn)) {
	        	addText("V",getLocInt("bnsyn1"+X), getLocInt("bnsyn1"+Y));
	        	addText(StringUtil.makeMoneyType(rec.bnsamt), getLocInt("bnsamt"+X), getLocInt("bnsamt"+Y));	//상여금액
			} else {
				addText("V",getLocInt("bnsyn2"+X), getLocInt("bnsyn2"+Y));
			}
	        
	        //기타급여여부
	        if ("Y".equals(rec.opyn)) {
	        	addText("V",getLocInt("opyn1"+X), getLocInt("opyn1"+Y));
	        	addText(StringUtil.makeMoneyType(rec.opamt1), getLocInt("opamt1"+X), getLocInt("opamt1"+Y));	//기타급여금액1
	        	addText(StringUtil.makeMoneyType(rec.opamt2), getLocInt("opamt2"+X), getLocInt("opamt2"+Y));	//기타급여금액2
	        	addText(StringUtil.makeMoneyType(rec.opamt3), getLocInt("opamt3"+X), getLocInt("opamt3"+Y));	//기타급여금액3
	        	addText(StringUtil.makeMoneyType(rec.opamt4), getLocInt("opamt4"+X), getLocInt("opamt4"+Y));	//기타급여금액4
			} else {
				addText("V",getLocInt("opyn2"+X), getLocInt("opyn2"+Y));
			}
	        
	        addText(rec.dpsdat, getLocInt("dpsdat"+X), getLocInt("dpsdat"+Y));		//입금지급일(매월)
	        
	        //지급방법
	        if ("1".equals(rec.mthd)) {
	        	addText("V",getLocInt("mthd1"+X), getLocInt("mthd1"+Y)); 			//근로자에게 직접지급
			} else {
				addText("V",getLocInt("mthd2"+X), getLocInt("mthd2"+Y)); 			//근로자 명의 예금통장에 입금
			}
	        
	        //계약일
	    	addText(rec.cntdat.substring(0,4), getLocInt("cntdat1"+X), getLocInt("cntdat1"+Y));	//년
	        addText(rec.cntdat.substring(4,6), getLocInt("cntdat2"+X), getLocInt("cntdat2"+Y));	//월
	        addText(rec.cntdat.substring(6), getLocInt("cntdat3"+X), getLocInt("cntdat3"+Y));	//일
	        
	        addText(rec.bsnm, getLocInt("bsnm2"+X), getLocInt("bsnm2"+Y));			//사업체명
	        addText(SupportUtil.convertTEL(rec.bstel), getLocInt("bstel"+X), getLocInt("bstel"+Y));			//사업체연락처
	        addText(rec.bsaddr, getLocInt("bsaddr"+X), getLocInt("bsaddr"+Y));		//사업체주소
	        addText(rec.bsceo, getLocInt("bsceo"+X), getLocInt("bsceo"+Y));			//사업체대표자명
	        addSign(prop.getProperty("SIGN.SRC")+rec.cnno+"_sign.png",getLocInt("sign1"+X), getLocInt("sign1"+Y), 100, 50);			//기업체sign
		}
	}
	
	public Map<String, String> getLocMap(JXParser parser, int pageNo) throws Exception {
		Map<String,String> map	= new HashMap<String,String>();
		Element		page	= null;
		Element[]	texts	= null;
		
    	try{
			page	= parser.getElement("//page[@value='"+pageNo+"']");
			texts	= parser.getElements(page,"text");
			for (int i = 0; i < texts.length; i++) {
				map.put(parser.getAttribute(texts[i], "key")+X, parser.getAttribute(texts[i], "x"));
				map.put(parser.getAttribute(texts[i], "key")+Y, parser.getAttribute(texts[i], "y"));
			}
    		
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	return map;
    }
	
	public int getLocInt(String key){
		return Integer.parseInt(location.get(key));
	}
}
