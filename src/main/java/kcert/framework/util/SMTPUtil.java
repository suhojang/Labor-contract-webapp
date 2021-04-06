package kcert.framework.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class SMTPUtil {
	private static final String SMTP_HOST	= "kcert.co.kr";
	private static final String SMTP_FROM	= "kcert@kcert.co.kr"; 
	public static final String SMTP_TAR_HTML	= "HTML";
	
	/**
	 * 1명에게 메일 전송
	 * @param no
	 * @param to
	 * @param title
	 * @param content
	 * @return
	 */
	public static Map<String,Object> sendmail(String to, String from, String title, String content){
		return sendmail(to, from, title, content, SMTP_TAR_HTML);
	}
	
	public static Map<String,Object> sendmail(String to, String from, String title, String content, String tar){
		return sendmail(to, from, title, content, tar, null);
	}
	
	public static Map<String,Object> sendmail(String to, String from, String title, String content, String tar, String fileName){
		Map<String,Object> map	= new HashMap<String,Object>();
		Properties props = new Properties();
		props.put("mail.host", SMTP_HOST);
		String success = "Y";
		String errMsg	= "";
		
		try{
			Session session	= Session.getDefaultInstance(props);
			
			Message ms	= new MimeMessage(session);
			ms.setFrom(new InternetAddress("".equals(from)?SMTP_FROM:from));
			ms.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
			
			ms.setSubject(title);
			ms.setSentDate(new java.util.Date());
			
			if (fileName!=null && !"".equals(fileName)) {
				MimeBodyPart mbp1	= new MimeBodyPart();
				if (SMTP_TAR_HTML.equals(tar)) {
					mbp1.setContent(content,"text/html;charset=euc-kr");
				} else {
					mbp1.setText(content, "KCS5601");
				}
				
				Multipart mp	= new MimeMultipart();
				mp.addBodyPart(mbp1);
			
			
				FileDataSource fds	= new FileDataSource(fileName);
				
				MimeBodyPart mbp2	= new MimeBodyPart();
				mbp2.setDataHandler(new DataHandler(fds));
				mbp2.setFileName(new String(fileName.substring(fileName.lastIndexOf("/")+1).getBytes("KSC5601"),"8859_1"));
				
				mp.addBodyPart(mbp2);
				ms.setContent(mp);
			} else {
				ms.setContent(content, "text/html;charset=euc-kr");
			}
			
			Transport.send(ms);
			
		}catch(Exception e){
			success = "N";
			errMsg	= e.getMessage();
			e.printStackTrace();
		}finally{
			map.put("success", success);
			map.put("MSG", errMsg);
		}
		return map;
	}
	
	/**
	 * 다중 메일전송
	 * @param no
	 * @param to
	 * @param title
	 * @param content
	 * @return
	 */
	public static Map<String,Object> sendmail(String no, Address[] to, String title, String content){
		return sendmail(no, to, title, content, SMTP_TAR_HTML);
	}
	
	public static Map<String,Object> sendmail(String no, Address[] to, String title, String content, String tar){
		return sendmail(no, to, title, content, tar, null);
	}
	
	public static Map<String,Object> sendmail(String no, Address[] to, String title, String content, String tar, String fileName){
		Map<String,Object> map	= new HashMap<String,Object>();
		Properties props = new Properties();
		props.put("mail.host", SMTP_HOST);
		Boolean success = true;
		String errMsg	= null;
		
		try{
			Session session	= Session.getDefaultInstance(props);
			
			Message ms	= new MimeMessage(session);
			ms.setFrom(new InternetAddress(SMTP_FROM));
			ms.setRecipients(Message.RecipientType.TO, to);
			
			ms.setSubject(title);
			ms.setSentDate(new java.util.Date());
			
			if (fileName!=null && "".equals(fileName)) {
				MimeBodyPart mbp1	= new MimeBodyPart();
				if (SMTP_TAR_HTML.equals(tar)) {
					mbp1.setContent(content,"text/html;charset=euc-kr");
				} else {
					mbp1.setText(content, "KCS5601");
				}
				
				Multipart mp	= new MimeMultipart();
				mp.addBodyPart(mbp1);
			
			
				FileDataSource fds	= new FileDataSource(fileName);
				
				MimeBodyPart mbp2	= new MimeBodyPart();
				mbp2.setDataHandler(new DataHandler(fds));
				mbp2.setFileName(new String(fileName.getBytes("KSC5601"),"8859_1"));
				
				mp.addBodyPart(mbp2);
				ms.setContent(mp);
			} else {
				ms.setContent(content, "text/html;charset=euc-kr");
			}
			
			Transport.send(ms);
			
		}catch(Exception e){
			success = false;
			errMsg	= e.getMessage();
			e.printStackTrace();
		}finally{
			map.put("success", success);
			map.put("errMsg", errMsg);
		}
		return map;
	}
	
	public static void logFileCreate(File file, String log){
		BufferedWriter bw	= null;
		try{
			if(!file.getParentFile().exists())
				file.getParentFile().mkdirs();
			
			bw	= new BufferedWriter(new FileWriter(file));
			bw.write(log);
			bw.flush();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{if(bw!=null){bw.close();}}catch(Exception e){e.printStackTrace();}
		}
	}
	
	public static boolean isValidEmail(String email){
		boolean err	= false;
		String regex	= "^[0-9a-zA-Z\\_\\-\\.]{1,}@[0-9a-zA-Z\\_\\-]{1,}\\.{1}[0-9a-zA-Z\\_\\-]{1,}\\.{0,1}[0-9a-zA-Z\\_\\-]*$";
		
		Pattern pattern	= Pattern.compile(regex);
		Matcher matcher	= pattern.matcher(email);
		
		if (matcher.matches())
			err	= true;
		return err;
	}
	
	
	public static void main(String[] args) throws Exception{
	}
}
