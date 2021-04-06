package kcert.framework.util;

import java.awt.Desktop;
import java.io.File;
import java.util.List;

import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfWriter;

/**
 * pdf 다운로드 및 보여주기 Utility
 * */
public class PdfUtil {
	public static final String FILE_TEMPORARY		= "temp_";
	public static final String PDF_EXTENTION		= ".pdf";
	public static final String PDF_CONTENT_TYPE		= "application/pdf";
	
	public static final File createPdf(String folderPath,String name, List<String> imgPathList){
		return createPdf(folderPath, name, imgPathList,false);
	}
	/**
	 * 주어진 이미지 경로로 pdf파일 생성
	 * @param folderPath 이미지 저장 폴더경로
	 * @param name 이미지명
	 * @param imgPathList List<String> 이미지 경로 목록
	 * */
	public static final File createPdf(String folderPath,String name, List<String> imgPathList,boolean isTemp){
        /*Document	document	= new Document();
        File		folder 		= new File(folderPath);
        if (!folder.exists())
        	folder.mkdirs();
        
        if(name.toLowerCase(Locale.KOREA).endsWith(PDF_EXTENTION))
        	name	= name.concat(PDF_EXTENTION);
        if(new File(folder,name).exists())
        	name	= name.replaceAll(PDF_EXTENTION,"").concat("_").concat(String.valueOf(System.currentTimeMillis())).concat(PDF_EXTENTION);
        
        File file	= new File(folderPath,name);
		//임시파일 삭제
        if(isTemp)
        	file.deleteOnExit();
        
        FileOutputStream	fos		= null;
        PdfWriter			writer	= null;
        try {
            fos		= new FileOutputStream(file);
            writer	= PdfWriter.getInstance(document, fos);
            
            writer.open();
            document.open();
            
            Image			img	= null;
            ExifInterface	ei	= null;
            int				ort	= -1;
            float			scale	= 0;
            for(int i=0;i<imgPathList.size();i++){
            	img	= Image.getInstance( imgPathList.get(i) );
            	ei	= new ExifInterface( imgPathList.get(i) );
            	ort	= ei.getAttributeInt ( ExifInterface.TAG_ORIENTATION ,  ExifInterface.ORIENTATION_NORMAL );
            	
            	switch(ort){
	                case ExifInterface.ORIENTATION_ROTATE_90:
	                    img.setRotationDegrees(-90);
	                    break ;
	                case ExifInterface.ORIENTATION_ROTATE_180:
	                    img.setRotationDegrees(-180);
	                    break ;
            	}
            	
            	scale	= ((document.getPageSize().getWidth() - document.leftMargin() - document.rightMargin() ) / img.getWidth()) * 100;
                img.scalePercent(scale);
                document.add(img);
            }
        }catch(Exception e){
        	
        }finally{
        	try{if(document!=null)document.close();}catch(Exception ex){}
        	try{if(writer!=null)writer.close();}catch(Exception ex){}
        }*/
        return new File(folderPath,name);
	}
	
	/**
	 * pdf 보여주기
	 * @param context Context
	 * @param pdfFile pdf File Object
	 * */
	public static final void viewPdf(File pdfFile){
		if(Desktop.isDesktopSupported()){
			try {
				Desktop.getDesktop().open(pdfFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	//PDF 특정위치에 작성 
    public static void absText(PdfContentByte cb, String text, float x, float y) throws Exception{
    	BaseFont bf = BaseFont.createFont("E:/eclipseEgovWeb/workspace/kcplaa_server/src/main/webapp/font/NanumGothicBold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
    	//BaseFont bf = BaseFont.createFont("/home/kcplaa_server/webapps/kcplaa_server/font/NanumGothicBold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        cb.saveState();
        cb.beginText();
        cb.moveText(x, y);
        cb.setFontAndSize(bf, 11);
        cb.showText(text);
        cb.endText();
        cb.restoreState();
    }
	//PDF 특정위치에 특정 크기로 작성 
    public static void absText(PdfContentByte cb, String text, float x, float y,int size) throws Exception {
    	BaseFont bf = BaseFont.createFont("E:/eclipseEgovWeb/workspace/kcplaa_server/src/main/webapp/font/NanumGothicBold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
    	//BaseFont bf = BaseFont.createFont("/home/kcplaa_server/webapps/kcplaa_server/font/NanumGothicBold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        cb.saveState();
        cb.beginText();
        cb.moveText(x, y);
        cb.setFontAndSize(bf, size);
        cb.showText(text);
        cb.endText();
        cb.restoreState();
    }
    
    //PDF 특정위치에 특정 크기로 이미지 적용 
  	public static void setImage(PdfContentByte cb,String path,float pX,float pY,int sW,int sH) throws Exception{
  		Image image	= null;
  		try{
  	        image			= Image.getInstance(path);
  	        image.setAbsolutePosition(pX,pY);
  	        if(sW!=0 && sH!=0)
  	        	image.scaleToFit(sW, sH);
  	        else
      			image.scaleToFit(100, 50);
  	        cb.addImage(image);
  		}catch(Exception e){
  			throw e;
  		}
  	}
	
	public void absText3(PdfWriter writer, String text, int x, int y) throws Exception {
        try {
            PdfContentByte cb = writer.getDirectContent();
            BaseFont bf = BaseFont.createFont("E:/eclipseEgovWeb/workspace/kcplaa_server/src/main/webapp/font/NanumGothicBold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            //BaseFont bf = BaseFont.createFont("/home/kcplaa_server/webapps/kcplaa_server/font/NanumGothicBold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            cb.saveState();
            cb.beginText();
            cb.moveText(x, y);
            cb.setFontAndSize(bf, 8);
            cb.setRGBColorFill(100,0,0);
            cb.showText(text);
            cb.endText();
            cb.restoreState();
        } catch (NullPointerException e) {
        	throw e;
        } catch (IndexOutOfBoundsException e) {
        	throw e;
        } catch (ClassCastException e) {
        	throw e;
        } catch (Exception e) {
        	throw e;
        }
    }
    public void absText4(PdfWriter writer, String text, int x, int y) throws Exception {
    	try {
    		PdfContentByte cb = writer.getDirectContent();
    		BaseFont bf = BaseFont.createFont("E:/eclipseEgovWeb/workspace/kcplaa_server/src/main/webapp/font/NanumGothicBold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            //BaseFont bf = BaseFont.createFont("/home/kcplaa_server/webapps/kcplaa_server/font/NanumGothicBold.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
    		cb.saveState();
    		cb.beginText();
    		cb.moveText(x, y);
    		cb.setFontAndSize(bf, 16);
    		cb.setRGBColorFill(0,0,255);//파란색
    		cb.showText(text);
    		cb.endText();
    		cb.restoreState();
    	} catch (NullPointerException e) {
    		throw e;
    	} catch (IndexOutOfBoundsException e) {
    		throw e;
    	} catch (ClassCastException e) {
    		throw e;
    	} catch (Exception e) {
    		throw e;
    	}
    }
    
    /**
     * 테스트 할 수 있도록 좌표를 찍어준다.
     * @param writer
     */
    public void Grid_Test(PdfWriter writer) throws Exception {
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
}
