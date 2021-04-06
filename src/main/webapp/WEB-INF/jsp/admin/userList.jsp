<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/jsp/common/header.jspf"%>
<jsp:include page="/WEB-INF/jsp/common/header.jsp" flush="false">
 <jsp:param name="menu01" value="active"/>
</jsp:include>

<body>
    <div class="container">
      <div class="row row-offcanvas row-offcanvas-right">
        <div class="col-xs-12 col-sm-12">
	        <div class="row">
				<div class="jumbotron">
				  <h2>사용자 현황</h2>
				  <p>${totCnt}개의 사용자 정보</p>
				</div>

				<div class="panel panel-default">
				  <div class="panel-heading"><span class="glyphicon glyphicon-filter"></span> 조건</div>
				  <div class="panel-body">
				  	<form:form commandName="searchVO" name="listForm" method="post" class="form-inline" role="search" onsubmit="return false;">   
					<input type="hidden" name="selectedId" />
					<form:hidden path="pageIndex" />
						<!-- 시작일 -->
						<div class="form-group">
							<span class="glyphicon glyphicon-calendar">설치일시</span>
							<form:input  path="stDate" cssClass="form-control" size="8" placeholder="2016-01-01" readonly="true" style="cursor: pointer;"/>						
					        <span style="width: 20px;padding: 3px;">&nbsp;~</span>
							<!-- 종료일 -->
							<form:input  path="etDate" cssClass="form-control" size="8" placeholder="2099-12-31" readonly="true" style="cursor: pointer;"/>
						</div>
						<div class="form-group">
							<!-- 검색조건 -->
							<form:select path="searchCondition" cssClass="selectpicker" >
								<form:option value="0"  label="전체" />
								<form:option value="1"  label="성명" />
								<form:option value="2"  label="연락처" />
							</form:select>
							<!-- 검색입력 -->
							<form:input path="searchKeyword" cssClass="form-control"  placeholder="Search"  onkeydown="javascript:if(event.keyCode==13){fn_egov_selectList();return false;}"/>
							<!-- 검색-->
							<input type="button" class="btn btn-default" onclick="javascript:fn_egov_selectList();" value="검색" />
							<!-- 엑셀다운로드 -->
							<input type="button" class="btn btn-default" onclick="javascript:fn_egov_selectExcel();" value="엑셀다운로드" />
						</div>
					</form:form>
				  </div>
				</div>
				
	         	<div class="table-responsive" style="clear: both;">
	         	 <table class="table table-hover table-striped">
	         	 <thead>
		 			<tr>
			 			<th>성명</th>
			 			<th>연락처</th>
			 			<th>설치일시</th>			 			
		 			</tr>
	         	 </thead>
	         	 <tbody>
				<c:forEach var="result" items="${result}" varStatus="status">
				<tr>
					<td><c:out value="${result.clinfNm}"/></td>
					<td><c:out value="${result.clinfHp}"/></td>
					<td><c:out value="${result.clinfRdt}"/></td>
				</tr>
				</c:forEach>
	         	 </tbody>
				 </table>
	             <div id="paging" align="center">
					<ui:pagination paginationInfo = "${paginationInfo}"
							   type="image"
							   jsFunction="fn_egov_link_page"
							   />
			     </div>
	            </div>
	        </div>
        </div>
      </div><!--/row-->
      
      <hr>
      
<jsp:include page="/WEB-INF/jsp/common/footer.jsp" flush="false">
 <jsp:param name="param" value=""/>
</jsp:include>
    </div><!--/.container-->
    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
	<%@include file="/WEB-INF/jsp/common/footer.jspf"%>    
	<script type="text/javaScript" language="javascript" defer="defer">
	<!--
	$(function() {
		$( "#stDate" ).datepicker({
		      changeMonth: true,
		      changeYear: true,
		      dateFormat: "yy-mm-dd"
		    });
		$( "#etDate" ).datepicker({
		      changeMonth: true,
		      changeYear: true,
		      dateFormat: "yy-mm-dd"
		    });
		$('.selectpicker').selectpicker({
	      style: 'btn-primary',
	      size: 5
	  	});
	  });
	/* 글 목록 화면 function */
	function fn_egov_selectList() {
		document.listForm.pageIndex.value = '1';
		document.listForm.action = "/admin/userList.do";
		document.listForm.submit();
	}
	
	/* pagination 페이지 링크 function */
	function fn_egov_link_page(pageNo){
		document.listForm.pageIndex.value = pageNo;
		document.listForm.action = "/admin/userList.do";
		document.listForm.submit();
	}
	function fn_egov_selectExcel(){
		document.listForm.action = "/admin/userListExcel.do";
		document.listForm.submit();
	}
	
	-->
	</script>
  </body>
</html>
