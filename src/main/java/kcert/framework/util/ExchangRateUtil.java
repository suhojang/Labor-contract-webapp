package kcert.framework.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.RoundingMode;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Currency;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.dom4j.Element;

public class ExchangRateUtil {
	
	/**
	 * 위안환율 계산
	 * @param link	: 환율정보를 받아올 url
	 * @param amt	: KRW 금액(환율계산할 금액)
	 * @param lst	: 환율정보를 받아올 리스트
	 * @return
	 */
	public static final String exchangCNY(String link, String amt, String[] lst){
		String result	= "";
		HttpURLConnection conn 	= null;
		BufferedReader rd		= null;
		StringBuffer sb			= new StringBuffer();
		Map<String,Double> excMap	= new HashMap<String,Double>();
		try{
			StringBuilder urlBuilder = new StringBuilder(link);
			URL url = new URL(urlBuilder.toString());
		    conn = (HttpURLConnection) url.openConnection();
		    conn.setRequestMethod("GET");
		    conn.setRequestProperty("Content-type", "application/json");
		    
		    if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
		        rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		    } else {
		        rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		        throw new Exception("에러 : ["+rd.toString()+"]");
		    }
		    String line;
		    while ((line = rd.readLine()) != null) {
		        sb.append(line);
		    }
		    
		    JXParser jxp	= new JXParser(sb.toString().substring(0,sb.toString().indexOf("<!--")));
		    List<Map<String,String>> list	= new ArrayList<Map<String,String>>();
		    
		    Element[] arr	= jxp.getElements("//resources//resource");
		    for(int i=0;i<arr.length;i++){
		    	Element[] arr2	= jxp.getElements(arr[i],"field");
		    	Map<String,String> map	= new HashMap<String,String>();
		    	for(int j=0;j<arr2.length;j++){
		    		map.put(jxp.getAttribute(arr2[j],"name"), 	jxp.getElement(jxp.getAbsolutePath(arr2[j])).getText());
		    	}
		    	list.add(map);
		    }
		    
		    for(int i=0;i<list.size();i++){
		    	Iterator<String> keys	= list.get(i).keySet().iterator();
		    	while(keys.hasNext()){
		    		String key	= keys.next();
		    		for(int j=0;j<lst.length;j++){
		    			if(lst[j].equals(list.get(i).get(key))){
		    				excMap.put(lst[j].substring(lst[j].indexOf("/")+1), 1 / Double.parseDouble(list.get(i).get("price")));
		    			}
		    		}
		    	}
		    }
		    DecimalFormat df	= new DecimalFormat("#.##");
		    df.setRoundingMode(RoundingMode.CEILING);
		    
		    result				= df.format(Double.parseDouble(amt) * (excMap.get("KRW") / excMap.get("CNY")));
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}

	public static void main(String[] args) {
		String[] lst	= new String[]{"USD/KRW","USD/CNY"};
		String krw		= "10,000";
		String result	= exchangCNY("http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote", krw.replaceAll(",", ""), lst);
		
		System.out.println(Currency.getInstance(Locale.KOREA).getSymbol()+krw+" = "+"¥"+result);
	}
}
