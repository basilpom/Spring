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
	.bigPicture img { width : 1000px; }
</style>
<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800">Board</h1>

	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<div class="card-header py-3">
			<h4 class="m-0 font-weight-bold text-primary">Read</h4>
		</div>

		<div class="card-body">
			<div class="form-group">
				<label>Bno</label> <input class="form-control" value="${board.bno}"
					name="bno" readonly="readonly">
			</div>
			<div class="form-group">
				<label>Title</label> <input class="form-control"
					value="${board.title}" name="title" readonly="readonly" />
			</div>
			<div class="form-group">
				<label>Content</label>
				<textarea class="form-control" rows="10" name="content"
					readonly="readonly">${board.content}</textarea>
			</div>
			<div class="form-group">
				<label>Writer</label> <input class="form-control"
					value="${board.writer}" name="writer" readonly="readonly" />
			</div>
			<!-- attachment file. start --------------------------->
			<div class="uploadResult">
				<ul>
				</ul>
			</div>
			<!-- The Modal for Show Image -->
			<div class="modal" id="imageModal">
			  <div class="modal-dialog modal-xl">
			    <div class="modal-content">
			      <!-- Modal Header -->
			      <div class="modal-header">
			        <h4 class="modal-title">Modal Heading</h4>
			        <button type="button" class="close" data-dismiss="modal">&times;</button>
			      </div>
			      <!-- Modal body -->
			      <div class="modal-body">
			      	Show Image
			      </div>
			      <!-- Modal footer -->
			      <div class="modal-footer">
			        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			      </div>
			    </div>
			  </div>
			</div>
			<!-- attachment file. end -->
			<form id="operForm" action="/board/modify" method="get">
				<input type="hidden" name="pageNum" value="${cri.pageNum}" /> 
				<input type="hidden" name="amount" value="${cri.amount}" /> 
				<input type="hidden" name="type" value="${cri.type}" /> 
				<input type="hidden" name="keyword" value="${cri.keyword}" /> 
				<input type="hidden" name="bno" id="bno" value="${board.bno}" />
				<input type="hidden" name="writer" value="${board.writer}" />
				
				<!-- 자신 작성글만 modify 보이도록 -->
				<sec:authentication property="principal" var="pinfo" />
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer}">
						<button data-oper="modify" class="btn btn-primary">Modify</button>
					</c:if>
				</sec:authorize>
				
				<button data-oper="list" class="btn btn-primary">List</button>
			</form>
			<%-- <a data-oper="modify" class="btn btn-primary" href="/board/modify?bno=${board.bno}">Modify</a>
            	<a data-oper="list" class="btn btn-primary" href="/board/list?">List</a> --%>
			<%-- <a class="btn btn-danger" href="/board/remove?bno=${board.bno}" onclick="return confirm('삭제하시겠습니까?')">Remove</a> --%>
			<!--	숙제용 삭제버튼
			<form role="form" action="/board/remove" method="post">
				<input type="hidden" name="bno" value="${board.bno}" />
				<button type="submit" data-oper="remove" class="btn btn-danger"
					onclick="return confirm('삭제하시겠습니까?')">Remove</button>
			</form>
			-->
		</div>

	</div>
	<!-- Reply List. Start ------------------------------------------------>
	<div class="card shadow mb-4">
		<div class="card-header py-3">
			<i class="fa fa-comments fa-fw"></i> Reply
			<!-- 로그인 한 사용자만 댓글 달 수 있도록  -->
			<sec:authorize access="isAuthenticated()">
				<button id="addReplyBtn" class="btn btn-primary btn-s float-right">New Reply</button>
			</sec:authorize>
		</div>
		<div class="card-body">
			<ul class="chat list-group">
			
			</ul>			
		</div>
		<div class="card-footer">
		</div>
	</div>
	<!-- Reply List. End -->
</div>
<!-- /.container-fluid -->
        

<!-- Modal for Reply. Start -->
<div class="modal" id="myModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<!-- Modal Header -->
			<div class="modal-header">
				<h4 class="modal-title">REPLY MODAL</h4>
				<button type="button" class="close" data-dismiss="modal">&times;</button>
			</div>
			<!-- Modal body -->
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name="reply" value="NEW REPLY!" />
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" name="replyer" readonly />
				</div>
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name="replyDate" value="" />
				</div>
			</div>
			<!-- Modal footer -->
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
				<button id="modalCloseBtn" type="button" class="btn btn-secondary">Close</button>
			</div>
		</div>
	</div>
</div>
<!-- Modal for Reply. End -->	
<%@ include file="../includes/footer.jsp" %>

<script>
	$(document).ready(function(){
		var operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function(e){
			e.preventDefault();
			operForm.attr("action", "/board/modify").submit();
		});
		
		$("button[data-oper='list']").on("click", function(e){
			e.preventDefault();
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list?");
			operForm.submit();
		});
	});
</script>
<!-- Script for Reply -->
<script src="/resources/js/reply.js"></script>
<script>
	$(document).ready(function(){
		
		// 첨부파일 목록 출력
		(function(){
			var bno = ${board.bno};
			$.getJSON("/board/getAttachList", {bno : bno}, function(arr){
				// console.log(arr);
				
				var str = "";
				$(arr).each(function(i, attach){
					if(!attach.fileType)
					{
						var fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
						str += "<div>";
						str += "	<span>" + attach.fileName + "</span><br/>";
						str += "	<img src='/resources/img/attach.png'>";
						str += "</div>";
						str += "</li>";
					}
					else
					{
						var fileCallPath = encodeURIComponent(
								attach.uploadPath+"/s_" + attach.uuid + "_" + attach.fileName);
						// console.log("fileCallPath!!");
						// console.log(fileCallPath);
						// console.log("!!!" + attach.image);
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
						str += "<div>";
						str += "	<img src='/display?fileName=" + fileCallPath + "'>";
						str += "</div>";
						str += "</li>";
					}
				});
				$(".uploadResult ul").html(str);
			});
		})();
		
		// 첨부파일 클릭 시 이벤트 처리
		$(".uploadResult").on("click", "li", function(e){
			console.log("file clicked!");
			var liObj = $(this);
			var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
			console.log(path);
			if(liObj.data("type"))
			{
				console.log("show image!");
				//showImage(path.replace(new RegExp(/\\/g), "/"));
				showModal(path.replace(new RegExp(/\\/g), "/"));
			}
			else
			{
				console.log("file download!");
				self.location = "/download?fileName=" + path;
			}
		});
		
		// 이미지 첨부파일 보여주는 함수
		function showImage(fileCallPath){
			console.log(fileCallPath);
			$(".bigPictureWrapper").css("display", "flex").show();
			$(".bigPicture")
			.html("<img src='/display?fileName=" + fileCallPath + "'>")
			.animate({width:'100%', height:'100%'});
		}
		
		function showModal(fileCallPath){
			console.log(fileCallPath);
			// open modal
			$("#imageModal").modal();
			// set modal title to original file name
			var originalName = fileCallPath.substr(fileCallPath.indexOf("_")+1);
			$("#imageModal .modal-title").html(decodeURIComponent(originalName));
			// modal body : show image
			$("#imageModal .modal-body").html("<img width='95%' src='/display?fileName=" + fileCallPath + "'>");
		}
		
		// 이미지 창 닫기
		$(".bigPictureWrapper").on("click", function(){
			$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
			setTimeout(function(){
				$(".bigPictureWrapper").hide();
			}, 1000);
		});
		
		// 댓글 페이지 처리
		var pageNum = 1;
		var replyPageFooter = $(".card-footer");
		
		function showReplyPage(replyCnt){
			var endNum = Math.ceil(pageNum / 10.0) * 10;
			var startNum = endNum - 9;
			
			var prev = startNum != 1;
			var next = false;
			
			if(endNum * 10 >= replyCnt)
			{
				endNum = Math.ceil(replyCnt / 10.0);
			}
			else if(endNum < replyCnt)
			{
				next = true;
			}
			
			var str = "<ul class='pagination float-right'>";
			
			if(prev)
			{
				str += "<li class='page-item'>";
				str += "	<a class='page-link previous' href='" + (startNum - 1) + "'>Prev</a>";
				str += "</li>";
			}
			for(var i = startNum; i <= endNum; i++)
			{
				var active = pageNum == i ? "active" : "";
				
				str += "<li class='page-item " + active + "'>";
				str += "	<a class='page-link' href='"+ i +"'>" + i + "</a>";
				str += "</li>";
			}
			if(next)
			{
				str += "<li class='page-item'>";
				str += "	<a class='page-link next' href='" + (endNum + 1) + "'>Next</a>";
				str += "</li>";
			}
			
			str += "</ul>";
			
			console.log(str);
			
			replyPageFooter.html(str);
		}
		
		// 댓글 페이지 이동
		replyPageFooter.on("click", "li a", function(e){
			e.preventDefault();
			console.log("PAGE CLICKED!");
			pageNum = $(this).attr("href");
			showList(pageNum);
		});
		
		
		var bnoValue = "${board.bno}";	// 부모글번호
		var replyUL = $(".chat");		// 댓글 목록 ul
		
		showList(1);
		
		// 댓글 목록 출력 함수
		function showList(page){
			replyService.getList({bno:bnoValue, page:page||1}, function(replyCnt, list){
				
				// 댓글 페이지 처리
				if(page == -1)
				{
					pageNum = Matho.ceil(replyCnt / 10.0);
					showList(pageNum);
					return;
				}
				
				var str = "";
				// 댓글 없을 경우
				if(list == null || list.length == 0)
				{
					//replyUL.html("");
					return;
				}
				// 댓글 있을 경우
 				for(var i = 0, len = list.length||0; i < len; i++)
				{
					str += "<li class='left clearfix list-group-item' data-rno='"+list[i].rno+"' style='cursor: pointer; '>";
					str += "	<div>";
					str += "		<div class='header'>";
					str += "			<strong class='text-primary'>" + list[i].replyer + "</strong>";
					str += "			<small class='float-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small>";
					str += "		</div>";
					str += "		<p>" + list[i].reply + "</p>"
					str += "	</div>";
					str += "</li>";
				}
				
				replyUL.html(str);
				
				showReplyPage(replyCnt);	// 페이지 출력
			});
		}
		
		// 댓글 관련 모달
		var modal = $("#myModal");
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		
		var replyer = null;
		// 로그인 한 사용자의 username(id)
		<sec:authorize access="isAuthenticated()">
			replyer = "<sec:authentication property='principal.username' />";
		</sec:authorize>
		
		// 댓글 등록 버튼 클릭 -> 모달
		$("#addReplyBtn").on("click", function(e){
			modal.find("input").val("");
			// 댓글 작성자를 로그인한 사용자로 고정
			modal.find("input[name='replyer']").val(replyer);
			modalInputReplyDate.closest("div").hide();	// 댓글 등록 시 날짜 입력 부분 안보이게
			modal.find("button[id!='modalCloseBtn']").hide();
			modalRegisterBtn.show();
			
			modal.modal("show");
		});
		
		// CSRF token
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		// Ajax 요청 시 마다 header에 csrf token 전달 //////////////////////////////////////////
		$(document).ajaxSend(function(e, xhr, options){
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
		///////////////////////////////////////////////////////////////////////////////
		
		// 댓글 등록 처리
		modalRegisterBtn.on("click", function(e){
			var reply = {
					reply : modalInputReply.val(),
					replyer : modalInputReplyer.val(),
					bno : bnoValue
			};
			replyService.add(reply, function(result){
				alert(result);
				modal.find("input").val("");
				modal.modal("hide");
				
				showList(1);
			});
		});
		
		// 댓글 클릭 이벤트
		$(".chat").on("click", "li", function(e){
			var rno = $(this).data("rno");
			replyService.get(rno, function(reply){
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				modal.modal("show");
			});
		});
		
		// 댓글 수정
		modalModBtn.on("click", function(e){
			// Login Check
			if(!replyer)
			{
				alert("로그인 후 수정이 가능합니다!");
				modal.modal("hide");
				return;
			}
			
			var originalReplyer = modalInputReplyer.val();
			console.log("original replyer : " + originalReplyer);
			
			// User Check
			if(replyer != originalReplyer)
			{
				alert("자신이 작성한 댓글만 수정이 가능합니다!");
				modal.modal("hide");
				return;
			}
			
			var reply = {
					rno : modal.data("rno"),
					reply : modalInputReply.val(),
					replyer : originalReplyer
			};
			
			replyService.update(reply, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		// 댓글 삭제
		modalRemoveBtn.on("click", function(e){
			var rno = modal.data("rno");
			console.log("replyer : " + replyer);
			
			// Login Check
			if(!replyer)
			{
				alert("로그인 후 삭제가 가능합니다!");
				modal.modal("hide");
				return;
			}
			
			var originalReplyer = modalInputReplyer.val();
			console.log("original replyer : " + originalReplyer);
			
			// User Check
			if(replyer != originalReplyer)
			{
				alert("자신이 작성한 댓글만 삭제가 가능합니다!");
				modal.modal("hide");
				return;
			}
			replyService.remove(rno, originalReplyer, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
	});
</script>
