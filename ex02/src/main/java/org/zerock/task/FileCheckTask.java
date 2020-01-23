package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	// 어제 날짜를 가지고 있는 folder path 구해오기
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String str = sdf.format(cal.getTime());
		return str.replace("-", File.separator);
	}
	
	@Scheduled(cron="0 0 2 * * *")
	public void checkFiles() throws Exception {
		log.warn("FILE CHECK TASK RUN ............");
		log.warn(new Date());
		
		// DB에서 어제 업로드된 첨부파일 목록 구하기
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		// 위에서 구한 첨부파일 목록의 파일 경로 구하기
		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
				.collect(Collectors.toList());
		
		// 이미지 파일의 경우 썸네일도 경로 구하기
		fileList.stream().filter(vo -> vo.isFileType() == true)
		.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName()))
		.forEach(p -> fileListPaths.add(p));
		log.warn("================================================");
		
		// DB에 있는 파일 목록 log에 출력
		fileListPaths.forEach(p -> log.warn(p));
		
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		
		// 업로드된 파일 중 DB에 없는 것 삭제
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		log.warn("------------------------------------------------");
		for(File file : removeFiles)
		{
			log.warn(file.getAbsoluteFile());
			file.delete();
		}
	}
}
