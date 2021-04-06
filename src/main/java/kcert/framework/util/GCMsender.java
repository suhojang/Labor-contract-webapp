package kcert.framework.util;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import com.google.android.gcm.server.Message;
import com.google.android.gcm.server.MulticastResult;
import com.google.android.gcm.server.Result;
import com.google.android.gcm.server.Sender;

public class GCMsender {
	public static SimpleDateFormat sysDateFormat	= new SimpleDateFormat("yyyyMMddHHmmss");
	
    public static int push(String apiKey,List<String> registerIds,String cmd,String title,String msg,Map<String,String> param){
    	JSONObject obj	= new JSONObject();
    	obj.putAll(param);
    	String json	= obj.toString();
    	
    	int successCount	= 0;
    	if(registerIds==null || registerIds.size()==0)
    		return 0;
    	try{
	    	Sender sender	= new Sender(apiKey);
	    	Message message	= new Message.Builder()
	    	.addData("P_CMD_ID"	, cmd)
	    	.addData("P_SND_TM"	, sysDateFormat.format(Calendar.getInstance().getTime()))
	    	.addData("P_TTL"	, URLEncoder.encode(title,"UTF-8"))
	    	.addData("P_MSG"	, URLEncoder.encode(msg,"UTF-8"))
	    	.addData("P_EXTRA"	, URLEncoder.encode(json,"UTF-8"))
	    	.build();
	    	
	    	MulticastResult result	= sender.send(message, registerIds, 3);
	    	successCount	= result.getSuccess();
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	return successCount;
    }
    /**
     * Map<String,String>의 형태로 담은 전달 파라미터를 JSON형
     * 
     * GCM message sending 
     * */
    public static String push(String apiKey,String registerId,String cmd,String title,String msg,Map<String,String> param){
    	JSONObject obj	= new JSONObject();
    	obj.putAll(param);
    	String json	= obj.toString();
    	
    	String resultMessage	= "";
    	if(registerId==null || "".equals(registerId))
    		return "";
    	try{
	    	Sender sender	= new Sender(apiKey);
	    	Message message	= new Message.Builder()
	    	.addData("P_CMD_ID"	, cmd)
	    	.addData("P_SND_TM"	, sysDateFormat.format(Calendar.getInstance().getTime()))
	    	.addData("P_TTL"	, URLEncoder.encode(title,"UTF-8"))
	    	.addData("P_MSG"	, URLEncoder.encode(msg,"UTF-8"))
	    	.addData("P_EXTRA"	, URLEncoder.encode(json,"UTF-8"))
	    	.build();
	    	
	    	Result result	= null;
	    	result	= sender.send(message, registerId, 3);
	    	if(result.getMessageId()==null)	//get error message : result.getErrorCodeName()
	    		resultMessage	= "ERROR : "+result.getErrorCodeName();
	    	else 
	    		resultMessage	= result.getMessageId();
    	}catch(Exception e){
    		e.printStackTrace();
    		resultMessage	= "ERROR : "+e.getMessage();
    	}
    	return resultMessage;
    }

}
