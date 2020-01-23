console.log("!!! REPLY MODULE !!!");

var replyService = (function(){
	// 댓글 등록
	function add(reply, callback, error)
	{
		console.log("!!! ADD REPLY !!!");
		$.ajax({
			type : "post",
			url : "/replies/new",
			data : JSON.stringify(reply),						// 서버로 보내는 data
			contentType : "application/json; charset=utf-8",	// 서버로 보내는 data type
			success : function(result, status, xhr){
				if(callback)
				{
					callback(result);	// result 는 controller 에서 보냄.
				}
			},
			error : function(xhr, status, er){
				if(error)
				{
					error(er);
				}
			}
		})
	}
	// 댓글 목록
	function getList(param, callback, error){
		var bno = param.bno;
		var page = param.page || 1;
		
		$.getJSON("/replies/pages/"+bno+"/"+page+".json", 
			function(data){		// data : server 쪽에서 넘어온 것.
				if(callback)
				{
					//callback(data);	// 함수 호출
					callback(data.replyCnt, data.list);	// reply with paging
				}
			}).fail(function(xhr, status, err){
			if(error)
			{
				error();
			}
		});
	}
	// 댓글 상세보기
	function get(rno, callback, error){
		$.get("/replies/" + rno + ".json", function(result){
			if(callback)
			{
				callback(result);
			}
		}).fail(function(xhr, status, err){
			if(error)
			{
				error(err);
			}
		});
	}
	
	// 댓글 수정
	function update(reply, callback, error){
		console.log("RNO : " + reply.rno);
		
		$.ajax({
			type : "put",
			url : "/replies/" + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; chartset=utf-8",
			success : function(result, status, xhr) {
				if(callback)
				{
					callback(result);
				}
			},
			error : function(xhr, status, err) {
				if(error)
				{
					error(err);
				}
			}
		});
	}
	
	// 댓글 삭제
	function remove(rno, replyer, callback, error) {
		$.ajax({
			type : "delete",
			url : "/replies/"+rno,
			data : JSON.stringify({rno:rno, replyer:replyer}),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if(callback)
				{
					callback(result);
				}
			},
			error : function(xhr, status, err) {
				if(error)
				{
					error(err);
				}
			}
		});
	}
	
	// 시간 출력 포맷
	function displayTime(timeValue) {

		var today = new Date();

		var gap = today.getTime() - timeValue;

		var dateObj = new Date(timeValue);
		var str = "";

		if (gap < (1000 * 60 * 60 * 24)) {

			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();

			return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi,
					':', (ss > 9 ? '' : '0') + ss ].join('');

		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
			var dd = dateObj.getDate();

			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/',
					(dd > 9 ? '' : '0') + dd ].join('');
		}
	};
	
	return {
		add : add,
		getList : getList,
		get : get,
		update : update,
		remove : remove,
		displayTime : displayTime
	};
})();