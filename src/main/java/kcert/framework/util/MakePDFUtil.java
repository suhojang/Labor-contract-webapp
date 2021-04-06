package kcert.framework.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.lang.reflect.Constructor;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import kcert.bill.PropertiesInfo;
import kcert.bill.maker.BillMaker;
import kcert.bill.rec.BillRec;

import org.dom4j.Element;

import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfWriter;

public class MakePDFUtil {
	private String pdfPath;
	private String billPath;
	
	public MakePDFUtil() {
		Properties prop	= new Properties();
    	try{
    		prop.load(new FileInputStream(new File(PropertiesInfo.properties_Path)));
    		
    		this.pdfPath	= prop.getProperty("ORIGINALPDF.SRC");
    		this.billPath	= prop.getProperty("PDF.SRC")+"bw"+new java.text.SimpleDateFormat("yyyyMMdd")+"_complete.pdf";
    	}catch(Exception e){
    		e.printStackTrace();
    	}
	}
	
	public MakePDFUtil(String path, String billPath) {
		this.pdfPath	= path;
		this.billPath	= billPath;
	}
	
	public void makeBillPDF(Map<String,String> info, String xml, String type){
		try{
			BillRec bill		= new BillRec(info);
			Class<?> cls		= Class.forName("kcert.bill."+bill.iccd.toUpperCase(Locale.KOREA));
			Constructor<?> cstr	= cls.getConstructor(new Class[]{BillRec.class, String.class, String.class});
			BillMaker maker		= (BillMaker) cstr.newInstance(new Object[]{bill, xml, type});
			
			writeBill(maker.toXml());
			//PdfUtil.viewPdf(new File(billPath));
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	//청구서 작성
	public void writeBill(String xml){
	    Document document	= new Document(PageSize.A4);
		JXParser pointer	= null;
	    PdfWriter writer 	= null;
	    PdfReader reader	= null;
	    PdfContentByte cb	= null;
	    PdfImportedPage pPage = null;
	    FileInputStream is	= null;
		try{
			is		= new FileInputStream(new File(pdfPath));
	        writer	= PdfWriter.getInstance(document, new FileOutputStream(billPath));
		    document.open();
		    cb		= writer.getDirectContent();
		    reader	= new PdfReader(is);
			
			pointer	= new JXParser(xml);
			Element		page	= null;
			Element[]	texts	= null;
			Element[]	signs	= null;
			Element[]	psigns	= null;
			int totPage	= pointer.getElements("//page").length;
			
			for(int i=1;i<=totPage;i++){
				pPage	= writer.getImportedPage(reader, i);
			    document.newPage();
			    cb.addTemplate(pPage, 0, 0);

				page	= pointer.getElement("//page[@value='"+i+"']");
				texts	= pointer.getElements(page,"text");
				for(int j=0;j<texts.length;j++){
					PdfUtil.absText(
							cb
							,pointer.getValue(texts[j])
							,Float.parseFloat(pointer.getAttribute(texts[j], "x"))
							,Float.parseFloat(pointer.getAttribute(texts[j], "y"))
							);
				}
				
				signs	= pointer.getElements(page,"sign");
				for(int j=0;j<signs.length;j++){
					PdfUtil.setImage(
							cb
							,pointer.getAttribute(signs[j], "path")
							,Float.parseFloat(pointer.getAttribute(signs[j], "x"))
							,Float.parseFloat(pointer.getAttribute(signs[j], "y"))
							,Integer.parseInt(pointer.getAttribute(signs[j], "w"))
							,Integer.parseInt(pointer.getAttribute(signs[j], "h")) 
							);
				}
				
				psigns	= pointer.getElements(page,"psign");
				for(int j=0;j<psigns.length;j++){
					PdfUtil.setImage(
							cb
							,pointer.getAttribute(psigns[j], "path")
							,Float.parseFloat(pointer.getAttribute(psigns[j], "x"))
							,Float.parseFloat(pointer.getAttribute(psigns[j], "y"))
							,Integer.parseInt(pointer.getAttribute(psigns[j], "w"))
							,Integer.parseInt(pointer.getAttribute(psigns[j], "h")) 
							);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{if(document!=null)document.close();}catch(Exception e){}
			try{if(reader!=null)reader.close();}catch(Exception e){}
			try{if(writer!=null)writer.close();}catch(Exception e){}
			try{if(is!=null)is.close();}catch(Exception e){}
		}
	}
}
