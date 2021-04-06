package kcert.bill.rec;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.Locale;
import java.util.Map;

/**
 * 근로계약 데이터 저장 객체
 * */
public class BillRec  implements Serializable {
	private static final long serialVersionUID = 1L;
	
	public BillRec(Map<String,String> billInfo){
		Field[] field	= this.getClass().getDeclaredFields();
		String	value	= null;
		for(int i=0;i<field.length;i++){
			value	= billInfo.get(field[i].getName().toUpperCase(Locale.KOREA));
			try {
				if(value!=null)
					field[i].set(this, value);
			}catch(Exception e){
			}
		}
	}
	public String cnno;		//근로계약일련번호
	public String iccd;		//근로계약서구분
	public String bsnm;		//사업체명
	public String bsaddr;	//사업체주소
	public String bsceo;	//사업체대표자명
	public String bstel;	//사업체연락처
	public String wknm;		//근로자명
	public String wkaddr;	//근로자주소
	public String wkhp;		//근로자연락처
	public String colsd;	//근로계약시작일
	public String coled;	//근로계약종료일
	public String pos;		//근무장소
	public String cob;		//업무의내용
	public String labst;	//소정근로시작시간
	public String labet;	//소정근로종료시간
	public String rstst;	//휴게시작시간
	public String rstet;	//휴게종료시간
	public String wkd;		//근무일수(매주)
	public String hld;		//휴일(요일)
	public String mpay;		//월급
	public String bnsyn;	//상여금여부
	public String bnsamt;	//상여금액
	public String opyn;		//기타급여여부
	public String opamt1;	//기타급여금액1
	public String opamt2;	//기타급여금액2
	public String opamt3;	//기타급여금액3
	public String opamt4;	//기타급여금액4
	public String dpsdat;	//입금지급일(매월)
	public String mthd;		//지급방법
	public String cntdat;	//계약일
}
