package kcert.bill.maker;

import java.io.FileOutputStream;
import java.io.OutputStream;

import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfSignatureAppearance;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.security.LtvTimestamp;

public class BillEncrypt {
	public static byte[] USER = "Hello".getBytes();
	public static byte[] OWNER = "World".getBytes();

	public static void pdfEncrypt(String src, byte[] ownerPassword, byte[] userPassword, String dest) throws Exception {
		PdfReader reader	= null;
		OutputStream os		= null;
		PdfStamper stamper	= null;
		try{
			reader	= new PdfReader(src);
			os		= new FileOutputStream(dest);
			stamper	= new PdfStamper(reader, os);
			
			stamper.setEncryption(
					userPassword, 
					ownerPassword, 
					PdfWriter.ALLOW_PRINTING, 
					PdfWriter.ENCRYPTION_AES_128 | PdfWriter.DO_NOT_ENCRYPT_METADATA
					);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(reader!=null){reader.close();}
			if(os!=null){os.close();}
			try{if(stamper!=null){stamper.close();}}catch(Exception ex){ex.printStackTrace();}
		}
		// step 1
        Document document = new Document();
        // step 2
        PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(dest));
        writer.setEncryption(USER, OWNER, PdfWriter.ALLOW_PRINTING, PdfWriter.STANDARD_ENCRYPTION_128);
        writer.createXmpMetadata();
        // step 3
        document.open();
        // step 4
        document.add(new Paragraph("Hello World"));
        // step 5
        document.close();
        
		//LtvTimestamp.timestamp(sap, tsa, signatureName);
	}
	
	
	
	public static void main(String[] args) throws Exception {
		try{
			String inputPdfFile	= "E:/pdf/N10.pdf";
			byte[] ownerPassword	= "111".getBytes();
			byte[] userPassword		= "222".getBytes();
			String outputPdf		= "E:/pdf/N10_encryt.pdf";
			
			pdfEncrypt(inputPdfFile, ownerPassword, userPassword, outputPdf);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

}
