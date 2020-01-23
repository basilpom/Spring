<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- include header -->
<%@ include file="../includes/header.jsp" %>
<style>
	.uploadResult {width : 100%; background-color : gray; }
	.uploadResult ul {display : flex; flex-flow : row; justify-content : center; align-items : center; }
	.uploadResult ul li {list-style : none; padding : 10px; cursor: pointer;}
	.uploadResult ul li img {width : 100px; }
	.uploadResult ul li span {color: white; }
</style>

        <!-- Begin Page Content -->
        <div class="container-fluid">

          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">Board</h1>

          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h4 class="m-0 font-weight-bold text-primary">Modify</h4>
            </div>
           <div class="card-body">
           	<form role="form" action="/board/modify" method="post">
           		<input type="hidden" name="pageNum" value="${cri.pageNum}" />
           		<input type="hidden" name="amount" value="${cri.amount}" />
           		<input type="hidden" name="type" value="${cri.type}" />
           		<input type="hidden" name="keyword" value="${cri.keyword}" />
           		<div class="form-group">
           			<label>Bno</label>
           			<input class="form-control" value="${board.bno}" name="bno" readonly="readonly" >
           		</div>
           		<div class="form-group">
           			<label>Title</label>
           			<input class="form-control" value="${board.title}" name="title" />
           		</div>
           		<div class="form-group">
           			<label>Content</label>
           			<textarea class="form-control" rows="10" name="content">${board.content}</textarea>
           		</div>
           		<div class="form-group">
           			<label>Writer</label>
           			<input class="form-control" value="${board.writer}" name="writer" />
            	</div>
            	<!-- file upload. start --------------------------->
				<div class="form-group uploadDiv">
					<label>File Attach</label><br /> 
					<input type="file" name="uploadFile" multiple />
				</div>
				<div class="uploadResult">
					<ul>
					</ul>
				</div>
				<!-- file upload. end -->
				
				<!-- 자신 작성글만 modify 보이도록 -->
				<sec:authentication property="principal" var="pinfo" />
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer}">
						<button data-oper="modify" class="btn btn-primary">Modify</button>
             		<button data-oper="remove" class="btn btn-danger">Remove</button>
					</c:if>
				</sec:authorize>

             	<button data-oper="list" class="btn btn-primary">List</button>
             	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
             </form>
            </div>
          </div>
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
		
		$("input[type='file']").on("change", function(e){
			var formData = new FormData();	// form tag에 대응되는 객체
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			console.log("input file changed!!!");
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
					console.log("ajax success!");
					console.log(result);
					//$(".uploadDiv").html(cloneObj.html());
					showUploadResult(result);
				}
			});
		});

		// 업로드 결과 화면에 보여주기
		function showUploadResult(uploadResultArr){
			console.log("show upload result!");
			if(!uploadResultArr || uploadResultArr.length == 0)
			{
				return;
			}
			console.log("add");
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
			console.log("str : " + str);
			uploadUL.append(str);
		}
		// 첨부파일 목록 출력
		(function(){
			var bno = ${board.bno};
			$.getJSON("/board/getAttachList", {bno : bno}, function(arr){
				console.log(arr);
				
				var str = "";
				$(arr).each(function(i, attach){
					if(!attach.fileType)
					{
						var fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
						str += "<div>";
						str += "	<span>" + attach.fileName + "</span>";
						str += "	<button type='button' data-file='" + fileCallPath +"' data-type='file' class='btn btn-warning btn-circle'>";
						str += "		<i class='fa fa-times'></i>";
						str += "	</button><br/>";
						str += "	<img src='/resources/img/attach.png'>";
						str += "</div>";
						str += "</li>";
					}
					else
					{
						var fileCallPath = encodeURIComponent(
								attach.uploadPath+"/s_" + attach.uuid + "_" + attach.fileName);
						console.log("fileCallPath!!");
						console.log(fileCallPath);
						console.log("!!!" + attach.fileType);
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
						str += "<div>";
						str += "	<span>" + attach.fileName + "</span>";
						str += "	<button type='button' data-file='" + fileCallPath +"' data-type='image' class='btn btn-warning btn-circle'>";
						str += "		<i class='fa fa-times'></i>";
						str += "	</button><br/>";
						str += "	<img src='/display?fileName=" + fileCallPath + "'>";
						str += "</div>";
						str += "</li>";
					}
				});
				$(".uploadResult ul").html(str);
			});
		})();

		// 첨부파일 삭제 여부 묻기
		$(".uploadResult").on("click", "button", function(){
			console.log("delete file!");
			if(confirm("Remove this file?"))
			{
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		});
		
		
		
		
		
		var formObj = $("form");
		
		$("button").on("click", function(e){
			e.preventDefault();	// 전송 막기
			
			var operation = $(this).data("oper");	// data-oper 속성 값을 읽어옴
			console.log(operation);
			
			if(operation === "remove")
			{
				if(confirm("삭제하시겠습니까?"))
				{
					formObj.attr("action", "/board/remove");
				}
				else
				{
					return;
				}
			}
			else if(operation === "list")
			{
				console.log("list button clicked!");
				// 목록으로 이동 시 parameter 모두 가지고 가도록
				formObj.attr("action", "/board/list").attr("method", "get");
				
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var typeTag = $("input[name='type']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				
				formObj.empty();
				
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(typeTag);
				formObj.append(keywordTag);
			}
			else if(operation === "modify")
			{
				console.log("modify button clicked!");
				
				var str = "";
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					console.dir(jobj);
					
					str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") +"'>";
					str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
				});
				formObj.append(str);
			}
			formObj.submit();	// 다시 전송 되도록
		});
	});
</script>