<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- include header -->
<%@ include file="../includes/header.jsp" %>
        


        <!-- Begin Page Content -->
        <div class="container-fluid">

          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">Board</h1>

          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h4 class="m-0 font-weight-bold text-primary">
              	List 
              	<!-- 한 페이지당 표시할 글의 갯수 조정 -->
              	<select name="setAmount" id="setAmount">
              		<option value="10">10개씩 보기</option>
              		<option value="15">15개씩 보기</option>
              		<option value="20">20개씩 보기</option>
              	</select>
              	<a href="/board/register" class="btn btn-sm btn-outline-secondary float-right">글쓰기</a>
              </h4>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>번호</th>
                      <th width="40%">제목</th>
                      <th>작성자</th>
                      <th>작성일</th>
                      <th>수정일</th>
                    </tr>
                  </thead>
                  <!-- 테이블 내용 시작 ------------------------------------------->
                  <!-- BoardController 에서 list 로 보낸 값 받아오기! -->
                  <!-- sorting, paging 은 DB 에서 하지 않고 여기서 -->
                  <c:forEach var="board" items="${list}">
                  	<tr>
                  		<td><c:out value="${board.bno}" /></td>
                  		<td>
                  			<a href="${board.bno}" class="move">
                  				<c:out value="${board.title}" />
                  				<c:choose>
                  					<c:when test="${board.replyCnt == 0}">
                  						<!-- 댓글이 없다면 badge 안나오게 -->
                  					</c:when>
                  					<c:otherwise>
                  						<span class="badge badge-primary">${board.replyCnt}</span>
                  					</c:otherwise>
                  				</c:choose>
                  			</a>
                  		</td>
                  		<td><c:out value="${board.writer}" /></td>
                  		<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}" /></td>
                  		<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}" /></td>
                  	</tr>
                  </c:forEach>
                  <!-- 테이블 내용 끝 -->
                </table>
                <!-- Paging. Start ------------------------------------------------>
                <div class="float-right">
                	<ul class="pagination">
                		<c:if test="${pageMaker.prev}">
                			<li class="page-item previous">
                				<a class="page-link" href="${pageMaker.startPage - 1}">Prev</a>
                			</li>
                		</c:if>
                	
                		<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                			<li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                				<a class="page-link" href="${num}">${num}</a>
                			</li>
                		</c:forEach>
                		
                		<c:if test="${pageMaker.next}">
                			<li class="page-item next">
                				<a class="page-link" href="${pageMaker.endPage + 1}">Next</a>
                			</li>
                		</c:if>
                	</ul>
                </div>
                <form id="actionForm" action="/board/list" method="get">
                	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}" />
                	<input type="hidden" name="amount" value="${pageMaker.cri.amount}" />
                	<input type="hidden" name="type" value="${pageMaker.cri.type}" />
                	<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}" />
                </form>
                <!-- Paging. End -->
                <!-- Search. Start --------------------------------------------------------->
                <div class="row clearfix" style="width: 100%; text-align:center; ">
                	<div class="col-lg-12">
                		<form id="searchForm" action="/board/list" method="get">
                			<select name="type">
                				<option value="">--</option>
                				<option value="T">제목</option>
                				<option value="C">내용</option>
                				<option value="W">작성자</option>
                				<option value="TC">제목 or 내용</option>
                				<option value="TW">제목 or 작성자</option>
                				<option value="TCW">제목 or 내용 or 작성자</option>
                			</select>
                			<input type="text" name="keyword" />
                			<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}" />
                			<input type="hidden" name="amount" value="${pageMaker.cri.amount}" />
                			<button class="btn btn-primary btn-sm">Search</button>
                		</form>
                	</div>
                </div>
                <!-- Search. End -->
                <!-- Modal. Start ------------------------------------------>
                <!-- The Modal -->
				<div class="modal" id="myModal">
				  <div class="modal-dialog">
				    <div class="modal-content">
				
				      <!-- Modal Header -->
				      <div class="modal-header">
				        <h4 class="modal-title">알림</h4>
				        <button type="button" class="close" data-dismiss="modal">&times;</button>
				      </div>
				
				      <!-- Modal body -->
				      <div class="modal-body">
				     	처리가 완료되었습니다.
				      </div>
				
				      <!-- Modal footer -->
				      <div class="modal-footer">
				        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				      </div>
				
				    </div>
				  </div>
				</div>
                <!-- Modal. End -->
              </div>
            </div>
          </div>

        </div>
        <!-- /.container-fluid -->

<%@ include file="../includes/footer.jsp" %>

<script>
	$(document).ready(function(){
		var result = '<c:out value="${result}" />';
		
		checkModal(result);
		
		// 뒤로가기 시 모달창 계속 뜨는 것 방지
		history.replaceState({}, null, null);
		        		
		function checkModal(result){
			if(result === '' || history.state) {return;}
			if(result === 'modify')
			{
				$(".modal-body").text("수정이 완료되었습니다.");
			}
			if(result === 'remove')
			{
				$(".modal-body").text("삭제가 완료되었습니다.");
			}
			if(parseInt(result) > 0)
			{
				$(".modal-body").html("게시글 " + parseInt(result) + "번이 등록되었습니다.")
			}
			$("#myModal").modal("show");
		}
		
		// for paging
		var actionForm = $("#actionForm");
		$(".page-item a").on("click", function(e){
			e.preventDefault();
			console.log("!!! CLICKED !!!");
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
		});
		
		// for searching
		var searchForm = $("#searchForm");
		
		$("#searchForm button").on("click", function(e){
			if(!searchForm.find("option:selected").val())
			{
				alert("검색 종류를 선택하세요!");
				return false;
			}
			if(!searchForm.find("input[name='keyword']").val())
			{
				alert("키워드를 입력하세요!");
				searchForm.find("input").focus();
				return false;
			}
			searchForm.find("input[name='pageNum']").val("1");
			//e.preventDefault();
			
			//searchForm.submit();
		});
		
		// 상세보기 시 parameter 가지고 넘어가도록
		$(".move").on("click", function(e){
			e.preventDefault();
			
			actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
			actionForm.attr("action", "/board/get");
			actionForm.submit();
		});
		
		// 페이지당 표시할 글 수 조정
		var comboBox = $("#setAmount");
		comboBox.on("change", function(){
			var setAmount = $(this).val();
			console.log(setAmount);
			actionForm.find("input[name='amount']").val(setAmount);
			actionForm.submit();
		});
		// 콤보박스에서 값 선택 후 페이지 넘어가서도 선택된 값 유지.
		var amount = actionForm.find("input[name='amount']").val();
		comboBox.val(amount).prop("selected", true);
		
	});
</script>