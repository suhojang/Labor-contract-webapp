package kcert.framework.web.multipart;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

public class KcertMultipartResolver extends CommonsMultipartResolver{
	public KcertMultipartResolver() {
		super();
	}

	public KcertMultipartResolver(ServletContext servletContext) {
		super(servletContext);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	protected MultipartParsingResult parseRequest(HttpServletRequest request) throws MultipartException {
		String encoding			= determineEncoding(request);
		FileUpload fileUpload	= prepareFileUpload(encoding);
		try {
			List<FileItem> fileItems = ((ServletFileUpload) fileUpload).parseRequest(new ServletRequestContext(request));
			return parseFileItems(fileItems, encoding);
		}catch (FileUploadBase.SizeLimitExceededException ex) {
			throw new MaxUploadSizeExceededException(fileUpload.getSizeMax(), ex);
		}catch (Exception ex) {
			ex.printStackTrace();
			throw new MultipartException("Could not parse multipart servlet request", ex);
		}
	}
   /* protected MultipartParsingResult parseFileItems(List fileItems, String encoding){
        MultiValueMap multipartFiles = new LinkedMultiValueMap();
        Map multipartParameters = new HashMap();
        for(Iterator iterator = fileItems.iterator(); iterator.hasNext();)
        {
            FileItem fileItem = (FileItem)iterator.next();
            if(fileItem.isFormField())
            {
                String partEncoding = determineEncoding(fileItem.getContentType(), encoding);
                String value;
                if(partEncoding != null)
                    try
                    {
                        value = fileItem.getString(partEncoding);
                    }
                    catch(UnsupportedEncodingException _ex)
                    {
                        if(logger.isWarnEnabled())
                            logger.warn((new StringBuilder("Could not decode multipart item '")).append(fileItem.getFieldName()).append("' with encoding '").append(partEncoding).append("': using platform default").toString());
                        value = fileItem.getString();
                    }
                else
                    value = fileItem.getString();
                String curParam[] = (String[])multipartParameters.get(fileItem.getFieldName());
                if(curParam == null)
                {
                    multipartParameters.put(fileItem.getFieldName(), new String[] {
                        value
                    });
                } else
                {
                    String newParam[] = StringUtils.addStringToArray(curParam, value);
                    multipartParameters.put(fileItem.getFieldName(), newParam);
                }
            } else
            {
                CommonsMultipartFile file = new CommonsMultipartFile(fileItem);
                multipartFiles.add(file.getName(), file);
                if(logger.isDebugEnabled())
                    logger.debug((new StringBuilder("Found multipart file [")).append(file.getName()).append("] of size ").append(file.getSize()).append(" bytes with original filename [").append(file.getOriginalFilename()).append("], stored ").append(file.getStorageDescription()).toString());
            }
        }

        return new MultipartParsingResult(multipartFiles, multipartParameters);
    }
    private String determineEncoding(String contentTypeHeader, String defaultEncoding)
    {
        if(!StringUtils.hasText(contentTypeHeader))
        {
            return defaultEncoding;
        } else
        {
            MediaType contentType = MediaType.parseMediaType(contentTypeHeader);
            Charset charset = contentType.getCharSet();
            return charset == null ? defaultEncoding : charset.name();
        }
    }*/

}
