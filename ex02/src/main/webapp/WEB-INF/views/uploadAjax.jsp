<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>UPLOAD FILE USING AJAX</title>
<style>
	.uploadResult {width : 100%; background-color : gray; }
	.uploadResult ul {display : flex; flex-flow : row; justify-content : center; align-items : center; }
	.uploadResult ul li {list-style : none; padding : 10px; }
	.uploadResult ul li img {width : 16px; }
	.thumbnail {width : 100px !important; }
	.uploadResult ul li span {color: white; }
	.bigPictureWrapper {
		position :  absolute; display : none;
		justify-content : center; align-items : center;
		top : 0%; width : 100%; height : 100%;
		background-color : gray; z-index : 100;
		background : rgba(255, 255, 255, 0.5);
	}
	.bigPicture {
		position : relative; display : flex;
		justify-content : center; align-items : center;
		/* transition: 1s; */
	}
	.bigPicture img { width : 600px; }
</style>
</head>
<body>
	<h1>Upload with Ajax</h1>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple />
	</div>
	<button id="uploadBtn">Upload</button>
	
	<div class="uploadResult">
		<ul>
		</ul>
	</div>
	
	<div class='bigPictureWrapper'>
		<div class='bigPicture'>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script>
		// 썸네일 클릭 시 원본 이미지 보여주기
		function showImage(fileCallPath){
			//alert(fileCallPath);
			$(".bigPictureWrapper").css("display", "flex").show();
			$(".bigPicture").html("<img src='/display?fileName=" + encodeURI(fileCallPath) + "'>")
			.animate({width : '100%', height : '100%' }, 1000);
		}
	
		$(document).ready(function(){
			// <input type="file"> 초기화를 위한 복제
			var cloneObj = $(".uploadDiv").clone();
			
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5*1024*1024;
			
			// 파일 확장자, 크기 체크 함수
			function checkExtension(fileName, fileSize){
				if(fileSize >= maxSize)
				{
					alert("파일 사이즈 초과!");
					return false;
				}
				if(regex.test(fileName))
				{
					alert("해당 종류의 파일은 업로드할 수 없습니다!");
					return false;
				}
				return true;
			}
			
			// 업로드 버튼
			$("#uploadBtn").on("click", function(e){
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				console.log(files);
				
				for(var i = 0; i < files.length; i++)
				{
					// 파일 확장자, 크기 체크!
					if(!checkExtension(files[i].name, files[i].size))
					{
						return false;
					}
					formData.append("uploadFile", files[i]);
				}
				$.ajax({
					url : "/uploadAjaxAction",
					processData : false,
					contentType : false,
					data : formData,
					dataType : "json",
					type : "POST",
					success : function(result){
						// 덮어써서 초기화
						$(".uploadDiv").html(cloneObj.html());
						// 목록에 파일이름 추가
						showUploadedFile(result);
					}
				});
			});
			
			// 업로드 후 목록 출력
			var uploadResult = $(".uploadResult ul");
			function showUploadedFile(uploadResultArr){
				var str = "";
				$(uploadResultArr).each(function(i, obj){
					if(!obj.image)
					{
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						str += "<li>";
						str += "	<a href='/download?fileName=" + fileCallPath + "'>";
						str += "		<img src='/resources/img/attach.png'>";
						str += 			obj.fileName;
						str += "	</a>";
						str += "	<span data-file='" + fileCallPath + "' data-type='file'> &times; </span>";
						str += "</li>";
					}
					else
					{
						//str += "<li>" + obj.fileName + "</li>";
						
						// path for show thumbnail image
						var fileCallPath = encodeURIComponent(
								obj.uploadPath+"/s_" + obj.uuid + "_" + obj.fileName);
						// path for show original image
						var originPath = obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName;
						// '\' 기호가 일반 문자열과 다르게 처리되므로 '/'로 변환
						originPath = originPath.replace(new RegExp(/\\/g), "/");
						
						str += "<li>";
						str += "	<a href=\"javascript:showImage('" + originPath + "')\">";
						str += "		<img class='thumbnail' src='/display?fileName=" + fileCallPath + "'>";
						str += "	</a>";
						str += "	<span data-file='" + fileCallPath + "' data-type='image'> &times; </span>";
						str += "</li>";
					}
				});
				uploadResult.append(str);
			}
			
			// 원본 이미지 보여준 후 다시 안보이게
			$(".bigPictureWrapper").on("click", function(e){
				$(".bigPicture").animate({width : '0%', height : '0%'}, 1000);
				setTimeout(function(){
					$(".bigPictureWrapper").hide();
				}, 1000);
			});
			
			// 삭제 버튼 누르면 ajax 요청
			$(".uploadResult").on("click", "span", function(e){
				var targetFile = $(this).data("file");
				var type = $(this).data("type");
				console.log("!!! TARGET FILE : " + targetFile);
				
				$.ajax({
					url : "/deleteFile",
					data : {fileName : targetFile, type : type},
					dataType : "text",
					type : "POST",
					success : function(result){
						alert(result);
					}
				});
			});
			
		});
	</script>
</body>
</html>