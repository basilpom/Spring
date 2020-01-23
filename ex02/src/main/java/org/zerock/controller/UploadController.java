package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Log4j
@Controller
public class UploadController {
	// form tag 이용하여 업로드
	@RequestMapping(value = "/uploadForm", method = RequestMethod.GET)
	public void uploadForm() {
		log.info("!!! UPLOAD FORM !!!");
	}
	
	@RequestMapping(value = "/uploadFormAction", method = RequestMethod.POST)
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		String uploadFolder = "C:/upload";
		
		for(MultipartFile multipartFile : uploadFile) 
		{
			log.info("===============================");
			log.info("!!! UPLOAD FILE NAME : " + multipartFile.getOriginalFilename());
			log.info("!!! UPLOAD FILE SIZE : " + multipartFile.getSize());
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
		
			try
			{
				multipartFile.transferTo(saveFile);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		
		}
	}
	
	// ajax 이용하여 업로드
	@RequestMapping(value = "/uploadAjax", method = RequestMethod.GET)
	public void uploadAjax() {
		log.info("!!! UPLOAD AJAX !!!");
	}
	
	@ResponseBody	// ResponseBody 가 붙으면 jsp 를 찾아가는 것이 아닌 json data return!
	@PreAuthorize("isAuthenticated()")
	@RequestMapping(value = "/uploadAjaxAction", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "C:/upload";
		
		String uploadFolderPath = getFolder();
		
		// make folder
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("!!! UPLOAD PATH : " + uploadPath);
		if(uploadPath.exists() == false)
		{
			uploadPath.mkdirs();
		}
		
		for(MultipartFile multipartFile : uploadFile) 
		{
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			log.info("===============================");
			log.info("!!! UPLOAD FILE NAME : " + multipartFile.getOriginalFilename());
			log.info("!!! UPLOAD FILE SIZE : " + multipartFile.getSize());
			
			String uploadFileName = multipartFile.getOriginalFilename();
			attachDTO.setFileName(uploadFileName);
			
			// UUID
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "_" + uploadFileName;

			try
			{
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				// Check Image Type File
				if(checkImageType(saveFile))
				{
					attachDTO.setImage(true);
					
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					thumbnail.close();
				}
				list.add(attachDTO);	// add to list
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	// 나중엔 별도의 클래스로 만들어서 사용
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	
	private boolean checkImageType(File file) {
		try
		{
			String contentType = Files.probeContentType(file.toPath());
			log.info("!!! CONTENT TYPE !!!" + contentType);
			return contentType.startsWith("image");
		}
		catch(NullPointerException nulle)
		{
			// php 등 contentType null 인 경우 처리를 위해
			System.out.println("!!!!! NULL !!!!!");
			return false;
		}
		catch(Exception e)
		{
			e.printStackTrace();
			
		}
		return false;
	}
	
	// show thumbnail image
	@ResponseBody
	@RequestMapping(value = "/display", method = RequestMethod.GET)
	public ResponseEntity<byte[]> getFiles(String fileName) {
		log.info("!!! FILENAME :" + fileName);
		File file = new File("C:/upload/" + fileName);
		log.info("!!! FILE : " + file);
		
		ResponseEntity<byte[]> result = null;
		try
		{
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return result;
	}
	
	// download attachment file
	@ResponseBody
	@RequestMapping(value = "/download", method = RequestMethod.GET, produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
		log.info("!!! DOWNLOAD FILE : " + fileName);
		Resource resource = new FileSystemResource("C:/upload/" + fileName);
		
		if(resource.exists() == false)
		{
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		log.info("!!! RESOURCE : " + resource);
		String resourceName = resource.getFilename();
		// remove uuid filename
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		
		HttpHeaders header = new HttpHeaders();
		try
		{
			String downloadName = null;
			// downloadName 을 브라우저 종류에 따라 다르게
			if(userAgent.contains("Trident"))
			{
				log.info("!!! IE BROWSER !!!");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
			}
			else if(userAgent.contains("Edge"))
			{
				log.info("!!! EDGE BROWSER !!!");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
			}
			else
			{
				log.info("!!! OTHER BROWSERS !!!");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			log.info("!!! DOWNLOAD NAME : " + downloadName);
			
			header.add("Content-Disposition", "attachment; fileName=" + downloadName);
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
	}
	
	// 첨부파일 삭제
	@ResponseBody
	@PreAuthorize("isAuthenticated()")
	@RequestMapping(value = "/deleteFile", method = RequestMethod.POST)
	public ResponseEntity<String> deleteFile(String fileName, String type){
		log.info("!!! DELETE FILE : " + fileName);
		File file;
		try
		{
			file = new File("C:/upload/" + URLDecoder.decode(fileName, "UTF-8"));
			file.delete();
			if(type.equals("image"))
			{
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				file = new File(largeFileName);
				file.delete();
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
}
