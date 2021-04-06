package kcert.framework.util;

public class SupportUtil {
	public static String pureNumber(String val){
		if(val==null || "".equals(val))
			return val;
		StringBuffer sb	= new StringBuffer();
		
		for(int i=0;i<val.length();i++){
			if(val.charAt(i)>=48 && val.charAt(i)<=57)
				sb.append(val.charAt(i));
		}
		return sb.toString();
	}
	
	public static final String convertHP(String hpno){
		hpno	= pureNumber(hpno);
		if(hpno==null || hpno.length()<10)
			return hpno;
		if(hpno.length()==10){
			hpno	= hpno.substring(0,3)+"-"+hpno.substring(3,6)+"-"+hpno.substring(6);
		}else if(hpno.length()==11){
			hpno	= hpno.substring(0,3)+"-"+hpno.substring(3,7)+"-"+hpno.substring(7);
		}else if(hpno.length()>11){
			hpno	= hpno.substring(0,3)+"-"+hpno.substring(3,7)+"-"+hpno.substring(7,11);
		}
		return hpno;
	}
	
	public static final String convertTEL(String tel){
		if(tel==null || tel.length()<9)
			return tel;
		if(tel.startsWith("02") && tel.length()>=9){
			if(tel.length()==9){
				tel	= tel.substring(0,2)+")"+tel.substring(2,5)+"-"+tel.substring(5);
			}else{
				tel	= tel.substring(0,2)+")"+tel.substring(2,6)+"-"+tel.substring(6,10);
			}
		}else{
			if(tel.length()==10){
				tel	= tel.substring(0,3)+")"+tel.substring(3,6)+"-"+tel.substring(6);
			}else{
				tel	= tel.substring(0,3)+")"+tel.substring(3,7)+"-"+tel.substring(7,11);
			}
		}
		return tel;
	}
	
	 /**
     * str의 사이즈가 size보다 작은 경우 "0"으로 채워서 리턴한다.
     * 
     * @param	str
     * @param	size
     * @return 	String	
     */
    public static String getZeroBaseString(String str, int size) {
        StringBuffer temp = new StringBuffer();
        if (str == null) {
            return "";
        }

        int strSize = str.length();
        if (strSize < size) {
            for (int i=0;i<(size-strSize);i++) {
                temp.append("0");
            }
        }
        temp.append(str.trim());
        
        return temp.toString();
    }
}
