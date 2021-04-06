package kcert.bill.maker;

import java.io.File;
import java.io.FileInputStream;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import kcert.bill.PropertiesInfo;
import kcert.bill.rec.BillRec;

public abstract class BillMaker {
	public static final String LF	= System.getProperty("line.separator");
	protected static final String X	= "_x";
	protected static final String Y	= "_y";
	
	protected static Properties prop	= new Properties();
	
	private Map<String,List<Text>> pageTextMap	= new HashMap<String,List<Text>>();
	private Map<String,List<Sign>> pageSignMap	= new HashMap<String,List<Sign>>();
	private Map<String,List<Psign>> pagePsignMap= new HashMap<String,List<Psign>>();
	
	protected BillRec rec;
	protected int maxPageNo;
	
	public BillMaker(BillRec rec,String locationXML,int maxPageNo, String type) throws Exception{
		this.rec		= rec;
		this.maxPageNo	= maxPageNo;
		
		prop.load(new FileInputStream(new File(PropertiesInfo.properties_Path)));
		
		maxPageNo	= 10;
		Method method	= null;
		for(int i=0;i<maxPageNo;i++){
			try{
				method	= this.getClass().getDeclaredMethod("page_"+(i+1), new Class[]{String.class, String.class});
				method.invoke(this, new Object[]{locationXML, type});
			}catch(NoSuchMethodException nsme){
				continue;
			}catch(Exception e){
				throw e;
			}
		}
	}
	//텍스트 추가
	public void addText(String value,float x,float y){
		String pageno	= new Throwable().getStackTrace()[1].getMethodName().replace("page_", "");
		if(pageTextMap.get(pageno)==null)
			pageTextMap.put(pageno, new ArrayList<Text>());
		
		pageTextMap.get(pageno).add(new Text(value,x,y));
	}
	//싸인 이미지 추가
	public void addSign(String path,float x,float y){
		String pageno	= new Throwable().getStackTrace()[1].getMethodName().replace("page_", "");
		if(pageSignMap.get(pageno)==null){
			pageSignMap.put(pageno, new ArrayList<Sign>());
		}
		pageSignMap.get(pageno).add(new Sign(path,x,y));
	}
	//싸인 이미지 추가
	public void addSign(String path,float x,float y,int w,int h){
		String pageno	= new Throwable().getStackTrace()[1].getMethodName().replace("page_", "");
		if(pageSignMap.get(pageno)==null){
			pageSignMap.put(pageno, new ArrayList<Sign>());
		}
		pageSignMap.get(pageno).add(new Sign(path,x,y,w,h));
	}
	
	//친권자 싸인 이미지 추가
	public void addPsign(String path,float x,float y){
		String pageno	= new Throwable().getStackTrace()[1].getMethodName().replace("page_", "");
		if(pagePsignMap.get(pageno)==null){
			pagePsignMap.put(pageno, new ArrayList<Psign>());
		}
		pagePsignMap.get(pageno).add(new Psign(path,x,y));
	}
	//친권자 싸인 이미지 추가
	public void addPsign(String path,float x,float y,int w,int h){
		String pageno	= new Throwable().getStackTrace()[1].getMethodName().replace("page_", "");
		if(pagePsignMap.get(pageno)==null){
			pagePsignMap.put(pageno, new ArrayList<Psign>());
		}
		pagePsignMap.get(pageno).add(new Psign(path,x,y,w,h));
	}
	
	//저장된 정보를 XML로 변경
	public String toXml(){
		StringBuffer sb	= new StringBuffer();
		sb.append("<?xml version='1.0' encoding='utf-8'?>"+LF)
		.append("<document>"+LF)
		;
		
		List<Text> textList	= null;
		List<Sign> signList	= null;
		List<Psign> psignList= null;
		Text text	= null;
		Sign sign	= null;
		Psign psign	= null;
		
		for(int i=0;i<maxPageNo;i++){
			textList	= pageTextMap.get(String.valueOf(i+1));
			signList	= pageSignMap.get(String.valueOf(i+1));
			psignList	= pagePsignMap.get(String.valueOf(i+1));
			
			sb.append("<page value='"+(i+1)+"'>");
			for(int j=0;textList!=null&&j<textList.size();j++){
				text	= textList.get(j);
				sb.append("<text x='"+text.x+"' y='"+text.y+"'><![CDATA["+text.value+"]]></text>"+LF);
			}
			for(int j=0;signList!=null&& j<signList.size();j++){
				sign	= signList.get(j);
				sb.append("<sign path='"+sign.path+"' x='"+sign.x+"' y='"+sign.y+"' w='"+sign.w+"' h='"+sign.h+"'/>"+LF);
			}
			for(int j=0;psignList!=null&& j<psignList.size();j++){
				psign	= psignList.get(j);
				sb.append("<psign path='"+psign.path+"' x='"+psign.x+"' y='"+psign.y+"' w='"+psign.w+"' h='"+psign.h+"'/>"+LF);
			}
			sb.append("</page>"+LF);
		}
		sb.append("</document>"+LF);
		return sb.toString();
	}


	
	class Text{
		public String	value;
		public float	x,y;
		public Text(String value,float x,float y){
			this.value	= value;
			this.x	= x;
			this.y	= y;
		}
	}
	class Sign{
		public String	path;
		public float	x,y;
		public int		w,h;
		public Sign(String path,float x,float y){
			this.path	= path;
			this.x	= x;
			this.y	= y;
		}
		public Sign(String path,float x,float y, int w,int h){
			this.path	= path;
			this.x	= x;
			this.y	= y;
			this.w	= w;
			this.h	= h;
		}
	}
	
	class Psign{
		public String	path;
		public float	x,y;
		public int		w,h;
		public Psign(String path,float x,float y){
			this.path	= path;
			this.x	= x;
			this.y	= y;
		}
		public Psign(String path,float x,float y, int w,int h){
			this.path	= path;
			this.x	= x;
			this.y	= y;
			this.w	= w;
			this.h	= h;
		}
	}
	
	/**
     * 오늘 날짜 문자열 취득.
     * ex) 20170308
     * @return
     */
    public static String getTodayString() {
		return new SimpleDateFormat("yyyyMMdd", Locale.getDefault()).format(new Date());
    }
}
