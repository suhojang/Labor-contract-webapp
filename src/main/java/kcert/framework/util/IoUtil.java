package kcert.framework.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.security.MessageDigest;

import org.apache.commons.codec.binary.Base64;

public class IoUtil {
	public static final void fileWrite(String path,byte[] bytes) throws Exception{
		FileOutputStream fos	= null;
		try{
			makFolder(path);
			
			fos	= new FileOutputStream(new File(path));
			fos.write(bytes);
			fos.flush();
			
		}catch(Exception e){
			throw e;
		}finally{
			try{if(fos!=null)fos.close();}catch(Exception ex){}
		}
	}
	
	public static final void fileWrite(String opath,String npath) throws Exception{
		FileInputStream fis		= null;
		FileOutputStream fos	= null;
		byte[] bytes	= new byte[1024];
		int size	= -1;
		try{
			makFolder(npath);
			
			fis	= new FileInputStream(new File(opath));
			fos	= new FileOutputStream(new File(npath));
			
			while( (size=fis.read(bytes))>=0 ){
				fos.write(bytes, 0, size);
				fos.flush();
			}
		}catch(Exception e){
			throw e;
		}finally{
			try{if(fis!=null)fis.close();}catch(Exception ex){}
			try{if(fos!=null)fos.close();}catch(Exception ex){}
		}
	}
	
	public static final void copyFile(String opath,String npath) throws Exception{
		FileInputStream fis		= null;
		FileOutputStream fos	= null;
		byte[] bytes	= new byte[1024];
		int size	= -1;
		try{
			makFolder(npath);
			
			fis	= new FileInputStream(new File(opath));
			fos	= new FileOutputStream(new File(npath));
			
			while( (size=fis.read(bytes))>=0 ){
				fos.write(bytes, 0, size);
				fos.flush();
			}
		}catch(Exception e){
			throw e;
		}finally{
			try{if(fis!=null)fis.close();}catch(Exception ex){}
			try{if(fos!=null)fos.close();}catch(Exception ex){}
		}
	}
	
	public static final void copyFile(InputStream input, String npath) throws Exception{
		FileOutputStream fos	= null;
		byte[] bytes	= new byte[1024];
		int size	= -1;
		try{
			makFolder(npath);
			
			fos	= new FileOutputStream(new File(npath));
			
			while( (size=input.read(bytes))>=0 ){
				fos.write(bytes, 0, size);
				fos.flush();
			}
		}catch(Exception e){
			throw e;
		}finally{
			try{if(fos!=null)fos.close();}catch(Exception ex){}
		}
	}
	
	public static final void deleteFile(String path){
		File file	= new File(path);
		if (file!=null && file.listFiles()!=null && file.listFiles().length > 0) {
			for (File f : file.listFiles()) {
        		if (f.isFile())
        			f.delete();
        		else
        			deleteFile(f.getAbsolutePath());
			}
			file.delete();
		}
	}
	
	public static final void delete(String path){
		if (new File(path).exists())
			new File(path).delete();
	}
	
	public static final void makFolder(String path) throws Exception{
		if(!new File(path).getParentFile().exists())
			new File(path).getParentFile().mkdirs();
	}
	
	public static final void signImgWrite(String data, String path) throws Exception{
		byte[] imgBytes		= Base64.decodeBase64(data.getBytes());
		FileOutputStream fos= new FileOutputStream(new File(path));
		fos.write(imgBytes);
		fos.close();
		fos.flush();
	}
	
	public static final void makeFolder(String path) throws Exception{
		if(!new File(path).exists())
			new File(path).mkdirs();
	}
	
	public static final String makeHashSHA256(String path, String algorm){
		StringBuffer data	= new StringBuffer();
		int size			= 1024;
		try{
			RandomAccessFile raf	= new RandomAccessFile(path, "r");
			MessageDigest hashSum	= MessageDigest.getInstance(algorm);
			
			byte[] buf	= new byte[size];
			byte[] partialHash	= null;
			
			long read	= 0;
			long offset	= raf.length();
			int unitsize;
			
			while(read < offset){
				unitsize	= (int) (((offset - read) >= size) ? size : (offset - read));
				raf.read(buf, 0, unitsize);
				hashSum.update(buf, 0, unitsize);
				
				read += unitsize;
			}
			
			raf.close();
			partialHash	= new byte[hashSum.getDigestLength()];
			partialHash	= hashSum.digest();
			
			StringBuffer sb	= new StringBuffer();
			for (int i = 0; i < partialHash.length; i++)
				sb.append(Integer.toString((partialHash[i] & 0xff) + 0x100, 16).substring(1));
			data.append(sb.toString());
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return data.toString();
	}
}
