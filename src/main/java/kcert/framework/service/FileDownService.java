package kcert.framework.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

@Service("fileDownService")
public class FileDownService{
	/**
	 * 파일다운로드를 담당한다.
	 * @param filePath 다운로드할 파일경로
	 * @param fileName 저장될 파일명
	 * @param response HttpServletResponse
	 * @exception IOException
	 */
    public void fileDown( String filePath , String fileName, HttpServletRequest request, HttpServletResponse response) throws Exception{
        String browser = getBrowser(request);
        String encodedFilename = "";
        
        if (browser.equals("MSIE")) {
            encodedFilename = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
        } else if (browser.equals("Firefox")) {
            encodedFilename = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
        } else if (browser.equals("Opera")) {
            encodedFilename = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
        } else if (browser.equals("Chrome")) {
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < fileName.length(); i++) {
                char c = fileName.charAt(i);
                if (c > '~') {
                    sb.append(URLEncoder.encode("" + c, "UTF-8"));
                } else {
                    sb.append(c);
                }
            }
            encodedFilename = sb.toString();
        } else {
            encodedFilename = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
        }
        response.setStatus(HttpServletResponse.SC_OK);
    	response.setHeader("Content-Type", "application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename="+encodedFilename);
        response.setHeader("Content-Description", "JSP Generated Data");
    	
		File fFile	= new File(filePath);
		if(!fFile.exists() || fFile.isDirectory()){
			return;
		}
		write(new FileInputStream(fFile),response.getOutputStream());
	}

    /**
	 * OutputStream 으로 write.
	 * 
	 * @param is 입력 stream
	 * @param os 출력 stream
	 * @exception IOException
	 */
    public static void write( InputStream is , OutputStream os ) throws IOException{
    	if(is==null || os==null){
    		return;
    	}
    	byte[] buf	= new byte[1024];
    	int iReadSize			= 0;
    	try{
    		while( (iReadSize=is.read(buf))!=-1 ){
    			os.write(buf,0,iReadSize);
    		}
    		os.flush();
    	}catch(IOException ie){
    		throw ie;
    	}finally{
    		try{if(is!=null){is.close();}}catch(IOException ie){}
    		try{if(os!=null){os.close();}}catch(IOException ie){}
    	}
    }    
    
    /**
     * 브라우저 구분 얻기.
     * @param request
     * @return
     */
    private static String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if(header==null){
            return "MSIE";
        }else if (header.indexOf("MSIE") > -1) {
            return "MSIE";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        }
        return "MSIE";
    }
}
