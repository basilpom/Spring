<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!-- include header -->
<%@ include file="../includes/header.jsp" %>

<style>
	.uploadResult {width : 100%; background-color : gray; }
	.uploadResult ul {display : flex; flex-flow : row; justify-content : center; align-items : center; }
	.uploadResult ul li {list-style : none; padding : 10px; }
	.uploadResult ul li img {width : 100px; }
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
	}
	.bigPicture img { width : 600px; }
</style>

        <!-- Begin Page Content -->
        <div class="container-fluid">

          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">Board Register</h1>

          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h4 class="m-0 font-weight-bold text-primary">Register</h4>
            </div>
            <div class="card-body">
            	<form role="form" action="/board/register" method="post">
            		<div class="form-group">
            			<label>Title</label>
            			<input class="form-control" name="title" />
            		</div>
            		<div class="form-group">
            			<label>Content</label>
            			<!-- CDN for CKEditor -->
            			<script src="//cdn.ckeditor.com/4.13.0/standard/ckeditor.js"></script>
            			<textarea class="form-control" rows=10 name="content" id="content"></textarea>
            			<!-- <script type="text/javascript"> 
    						CKEDITOR.replace('content', {height: 500});
						</script> -->
            		</div>
            		<div class="form-group">
            			<label>Writer</label>
            			<input class="form-control" name="writer" readonly="readonly"
            				value="<sec:authentication property='principal.username' />"
            			/>
            		</div>
            		<!-- file upload. start --------------------------->
					<div class="form-group uploadDiv">
						<label>File Attach</label><br/>
						<input type="file" name="uploadFile" multiple />
					</div>
					<div class="uploadResult">
						<ul>
						</ul>
					</div>
					<!-- file upload. end -->
					<hr/>
            		<button type="submit" class="btn btn-primary">Submit</button>
            		<button type="reset" class="btn btn-primary">Reset</button>
            		
            		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				</form>
            </div>
            <!-- card-body end -->
          </div>
          
<!--           For Attach File. Start ------------------------------------------------------
        <div class="row">
        	<div class="col-lg-12">
	        	<div class="card shadow mb-4">
		            <div class="card-header py-3">
		              <h4 class="m-0 font-weight-bold text-primary">File Attach</h4>
		            </div>
		            <div class="card-body">
		            	<div class="form-group uploadDiv">
		            		<input type="file" name="uploadFile" multiple />
		            	</div>
		            	<div class="uploadResult">
		            		<ul>
		            		</ul>
		            	</div>
		            </div>
		            card-body end
				</div>
				card end
			</div>
        </div>
        For Attach File. End -->
        
        </div>
        <!-- /.container-fluid -->

<%@ include file="../includes/footer.jsp" %>

<script>
	$(document).ready(function(){
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
		
		// post 방식으로 ajax 처리 시 spring security token 값 전달
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$("input[type='file']").change(function(e){
			var formData = new FormData();	// form tag에 대응되는 객체
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
				formData.append("uploadFile", files[i]);	// form tag 내 input tag에 대응.
			}
			
			$.ajax({
				url : "/uploadAjaxAction",
				processData : false,
				contentType : false,
				data : formData,
				dataType : "json",
				type : "POST",
				beforeSend : function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				success : function(result){
					console.log(result);
					$(".uploadDiv").html(cloneObj.html());
					showUploadResult(result);
				}
			});
			
		});

		// 업로드 결과 화면에 보여주기
		function showUploadResult(uploadResultArr){
			if(!uploadResultArr || uploadResultArr.length == 0)
			{
				return;
			}
			var uploadUL = $(".uploadResult ul");
			var str = "";
			
			$(uploadResultArr).each(function(i, obj){
				if(!obj.image)
				{
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
					str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>";
					str += "<div>";
					str += "	<span>" + obj.fileName + "</span>";
					str += "	<button type='button' data-file='" + fileCallPath + "' data-type='file' class='btn btn-warning btn-circle'>";
					str += "		<i class='fa fa-times'></i>";
					str += "	</button><br />";
					str += "	<img src='/resources/img/attach.png'>";
					str += "</div>";
					str += "</li>";
				}
				else
				{
					// path for show thumbnail image
					var fileCallPath = encodeURIComponent(
							obj.uploadPath+"/s_" + obj.uuid + "_" + obj.fileName);
					// path for show original image
					//var originPath = obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName;
					// '\' 기호가 일반 문자열과 다르게 처리되므로 '/'로 변환
					//originPath = originPath.replace(new RegExp(/\\/g), "/");
					
					str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>";
					str += "<div>";
					str += "	<span>" + obj.fileName + "</span>";
					str += "	<button type='button' data-file='" + fileCallPath +"' data-type='image' class='btn btn-warning btn-circle'>";
					str += "		<i class='fa fa-times'></i>";
					str += "	</button><br/>";
					str += "	<img src='/display?fileName=" + fileCallPath + "'>";
					str += "</div>";
					str += "</li>";
				}
			});
			uploadUL.append(str);
		}
		
		// 삭제 버튼 누르면 ajax 요청
		$(".uploadResult").on("click", "button", function(e){
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			console.log("!!! TARGET FILE : " + targetFile);
			// 첨부파일 미리보기 삭제
			var targetLi = $(this).closest("li");
			
			// upload 된 파일 삭제
			$.ajax({
				url : "/deleteFile",
				data : {fileName : targetFile, type : type},
				dataType : "text",
				type : "POST",
				beforeSend : function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				success : function(result){
					alert(result);
					targetLi.remove();
				}
			});
			
		});
		
		
		var formObj = $("form[role='form']");
		$("button[type='submit']").on("click", function(e){
			e.preventDefault();
			console.log("SUBMIT CLICKED!");
			
			var str = "";
			$(".uploadResult ul li").each(function(i, obj){
				var jobj = $(obj);
				console.dir(jobj);
				
				str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") +"'>";
				str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
			});
			formObj.append(str).submit();
		});
		
		
	});

</script>