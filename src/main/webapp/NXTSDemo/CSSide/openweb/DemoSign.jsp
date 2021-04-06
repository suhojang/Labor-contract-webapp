<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="./common.jsp" %>
    <title>데이터 서명/검증</title>
</head>
<body>

<div class="container">
    <div class="col-md-9">
        <div><h3>데이터 서명/검증</h3></div>

        <div class="panel panel-primary">
            <div class="panel-heading">서명 데이터</div>
            <div class="panel-body">
                <form class="form-horizontal" onsubmit="return false;">
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="inputData">데이터</label>
                        <div class="col-sm-10">
                            <textarea class="form-control" id="inputData" rows="3" >테스트용 서명 데이터 입니다.</textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="ssn">신원확인 정보</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="ssn" placeholder="인증서 신원확인 정보">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="inputData"></label>
                        <div class="col-sm-10">
                            <button onclick="signDataTest();">데이터 서명</button>
                        </div>
                    </div>
                </form>

            </div>
        </div>

        <div class="panel panel-success">
            <div class="panel-heading">서명결과</div>
            <div class="panel-body">
                <form class="form-horizontal" action="DemoVerify.jsp" method="post">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">서명결과</label>
                        <div class="col-sm-10">
                            <textarea class="form-control" id="signedData" rows="5" name="data1"></textarea>
                        	<input type="hidden" class="form-control" id="certVerifyType" name="certVerifyType" value="1" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">인증서 정보</label>
                        <div class="col-sm-10">
                            <div id="signCertInfo" class="scrollable-data"></div>
                        </div>
                        <button>서명 데이터 검증</button>
                    </div>
                </form>
                <div>


                </div>
            </div>
        </div>



    </div>
</div>



<script>

    function sign_complete_callback(res) {
        if (res.code == 0) {
			var signedData = res.data.signedData;
            $("#signedData").val(signedData);
            $("#signCertInfo").append(objectToTable("",res.data.certInfo));

        }

        else {
            alert("error code = " + res.code + ", message = " + res.errorMessage);
        }
    }

    function signDataTest() {
        var options = {};

        $("#signedData").val("");
        $("#signCertInfo").empty();


        var data = $("#inputData").val();
        var ssn = $("#ssn").val();
        if(ssn != "") {
            options.ssn = ssn;
        }

        nxTSPKI.signData(data, options, sign_complete_callback);

    }


	//초기화 함수 필수
    $(document).ready(function(){
        nxTSPKI.onInit(function(){ 
			//nxTSPKI.init 함수 완료 후 실행해야 하는 함수나 기능 작성 위치
			//alert("Init 완료");
		});

		nxTSPKI.init(true);
    });
	
	function fn_onclick(){
		nxTSPKI.onInit(function(){ 
			//nxTSPKI.init 함수 완료 후 실행해야 하는 함수나 기능 작성 위치
			//alert("Init 완료");
		});

		nxTSPKI.init(true);
	}

</script>


</body>
</html>
