package kcert.bill.maker;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfWriter;

public class BillGridTest {
	public BillGridTest(String pdfPath, String billPath, int totPage) throws Exception {
		Document document	= new Document(PageSize.A4);
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
			
			for(int i=1;i<=totPage;i++){
				pPage	= writer.getImportedPage(reader, i);			
			    document.newPage();
			    cb.addTemplate(pPage, 0, 0);

			    grid_pdf(writer);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{if(document!=null)document.close();}catch(Exception e){}
			try{if(reader!=null)reader.close();}catch(Exception e){}
			try{if(writer!=null)writer.close();}catch(Exception e){}
			try{if(is!=null)is.close();}catch(Exception e){}
			
			System.out.println(billPath+" PDF파일이 생성 되었습니다.");
			System.out.println("======================================================");
		}
	}
	
	/**
     * 테스트 할 수 있도록 좌표를 찍어준다.
     * @param writer
     */
    public void grid_pdf(PdfWriter writer){
        for(int i =0; i < 1000; i=i+40){
            for(int j =0; j < 1000; j=j+10){
            	absText3(writer, ""+i+","+j,i, j);
            }
        }
       for(int i =0; i < 1000; i=i+10){
	       	for(int j =0; j < 1000; j=j+10){
	       		absText4(writer, ".",i, j);
	       	}
       }
    }
    
    public void absText3(PdfWriter writer, String text, int x, int y) {
        try {
            PdfContentByte cb = writer.getDirectContent();
            BaseFont bf = BaseFont.createFont("E:/HMKMMAG.TTF", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            cb.saveState();
            cb.beginText();
            cb.moveText(x, y);
            cb.setFontAndSize(bf, 8);
            cb.setRGBColorFill(100,0,0);
            cb.showText(text);
            cb.endText();
            cb.restoreState();
        } catch (NullPointerException e) {
        	e.printStackTrace();
        } catch (IndexOutOfBoundsException e) {
        	e.printStackTrace();
        } catch (ClassCastException e) {
        	e.printStackTrace();
        } catch (Exception e) {
        	e.printStackTrace();
        }
    }
    public void absText4(PdfWriter writer, String text, int x, int y) {
    	try {
    		PdfContentByte cb = writer.getDirectContent();
    		BaseFont bf = BaseFont.createFont("E:/HMKMMAG.TTF", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
    		cb.saveState();
    		cb.beginText();
    		cb.moveText(x, y);
    		cb.setFontAndSize(bf, 16);
    		cb.setRGBColorFill(0,0,255);//파란색
    		cb.showText(text);
    		cb.endText();
    		cb.restoreState();
    	} catch (NullPointerException e) {
    		e.printStackTrace();
    	} catch (IndexOutOfBoundsException e) {
    		e.printStackTrace();
    	} catch (ClassCastException e) {
    		e.printStackTrace();
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
	
	public static void main(String[] args) {
		try {
			System.out.println("======================================================");
			System.out.println("PDF파일이 생성을 시작합니다.");
			System.out.println("======================================================");
			//원본PDF경로, 좌표찍어서보여줄 PDF경로, PDF의 페이지 수
			new BillGridTest("E:/pdf/A01/bw20170309-0000001_complete.pdf","E:/pdf/A01/bw20170309-0000001_complete_grid.pdf",3);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
