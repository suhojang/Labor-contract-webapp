<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="./common.jsp" %>
    <title>전자봉투 데이터 서명/검증</title>
</head>
<body>

<div class="container">
    <div class="col-md-9">
        <div><h3>Envelop / DecryptEnvelop </h3></div>

        <div class="panel panel-primary">
            <div class="panel-heading">Envelop될 원문 데이터</div>
            <div class="panel-body">
                <form action="DemoDevelop.jsp" method="post" class="form-horizontal">
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="testCert">인증서</label>
                        <div class="col-sm-9">
                            <textarea class="form-control" id="testCert" rows="5" cols="80"></textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="testData">데이터</label>
                        <div class="col-sm-9">
                            <textarea id="testData" name="plainText" rows="3" cols="80">Envelop용 샘플 데이터 입니다.</textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-2" for="testData"></label>
                        <div class="col-sm-9">
                            <button onclick="envelopDataTest(); return false;"> Envelop</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-2" for="envdata">Envelop 결과<jlabel>
                        <div class="col-sm-9">
                			<textarea id="envelopedData" name="envdata" rows="5" cols="80"></textarea>
                		</div>
                        <div class="col-sm-9">
                        	<button>Envelop 데이터 복호화</button>
                        </div>
                	</div>

                </form>
            </div>
        </div>

        <hr>

    </div>
</div>



<script>
  
    function envelop_complete_callback(res) {
        if (res.code == 0) {
            $("#envelopedData").val(res.data);
        }
        else {
            alert("error code = " + res.code + ", message = " + res.errorMessage);
        }
    }

    function envelopDataTest() {
        var data = $("#testData").val();
        var cert = $("#testCert").val();
        $("#envelopedData").val("");
        nxTSPKI.envelopData(data,cert,{}, envelop_complete_callback);
    }


    $(document).ready(function(){
        var kmCert = "-----BEGIN CERTIFICATE-----MIIFITCCBAmgAwIBAgIEWZpPyDANBgkqhkiG9w0BAQsFADBPMQswCQYDVQQGEwJLUjESMBAGA1UECgwJVHJhZGVTaWduMRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFTATBgNVBAMMDFRyYWRlU2lnbkNBMjAeFw0xNjA2MjEwNTE3MDZaFw0xNzA3MDYwNTUyMDlaMGExCzAJBgNVBAYTAktSMRIwEAYDVQQKDAlUcmFkZVNpZ24xEzARBgNVBAsMCkxpY2Vuc2VkQ0ExDjAMBgNVBAsMBUtUTkVUMRkwFwYDVQQDDBDthYzsiqTtirgoS1RORVQpMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzfow3ncW0W69HizlJclJBa8ezllNlCAs6sAWMCknvhiOYZHdr0ZIMT5AUeNdOuERVqszjirCT3VHzAPNtz3O00OjmDMii3+8pnLnWmRdjEBm7crahhEn72svv3RY0LOVjnWxpX+mMbuAdEYVj9N+mRSEkTw6bqzSdyV7w2rkkvhWM38gv8bIXBsmeGwBkahrN3AyIj4q2GL+A5kzbWcz/uyiaBQy7il9hbKLirCaCniyNVh1d/0v5+1DpE5ZmQZpwaJx4W/wsQyyn9ci0d6VbjZgNjFTAs57bQ2jeP/346WfgNKvNCsiHcfV3cTRX8q6g9dimQAcc/clI7H0WGCpbwIDAQABo4IB8TCCAe0wgY8GA1UdIwSBhzCBhIAUTV1WCgcD34PK89Vtjxn8EqyQooqhaKRmMGQxCzAJBgNVBAYTAktSMQ0wCwYDVQQKDARLSVNBMS4wLAYDVQQLDCVLb3JlYSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSBDZW50cmFsMRYwFAYDVQQDDA1LSVNBIFJvb3RDQSA0ggIQCTAdBgNVHQ4EFgQUdZHTNkC1wD6VwPOTjZ31BRDnUgMwDgYDVR0PAQH/BAQDAgUgMHoGA1UdIAEB/wRwMG4wbAYJKoMajJpMAQEEMF8wLgYIKwYBBQUHAgIwIh4gx3QAIMd4yZ3BHLKUACCs9cd4x3jJncEcACDHhbLIsuQwLQYIKwYBBQUHAgEWIWh0dHA6Ly93d3cudHJhZGVzaWduLm5ldC9jcHMuaHRtbDBmBgNVHR8EXzBdMFugWaBXhlVsZGFwOi8vbGRhcC50cmFkZXNpZ24ubmV0OjM4OS9jbj1jcmwxZHA4NjMsb3U9Y3JsZHAyLG91PUFjY3JlZGl0ZWRDQSxvPVRyYWRlU2lnbixjPUtSMEYGCCsGAQUFBwEBBDowODA2BggrBgEFBQcwAYYqaHR0cDovL29jc3AudHJhZGVzaWduLm5ldDoxODAwMC9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBCwUAA4IBAQBTGG0u5pqdKuOuM/KnyF01mUrJ7ADurLA8jq98B7pi8bdd03U4HpKbA0GfZks+Aiz2Jb/4Mq0yW19W8HBtd51zwELfBE5F+N4eTXy/PqYhwSg1HW2/tKbPr1dBQTJSKGSWZmLJaf4fmEiwYpuUEOkt19axsa0yRWtj68H4kzfkm1+qBeCxPHFCznZV00lqW7W07nD6k4KwUHGv4FGZ/NAp/k4pIQ60rOeDiehs3HBRG2PtQwXAMbDRjioyyfndqzw96eqxg0/4QDq6JpLzMvqSi1VX82hJz6YeptdMVW987ucwz2tfBS15pv4sUmeds2abdUdrc7v964cb9LGl+9pM-----END CERTIFICATE-----";
        $("#testCert").val(kmCert);
    });
		
	//초기화 함수 필수
    $(document).ready(function(){
        nxTSPKI.onInit(function(){ 
			//nxTSPKI.init 함수 완료 후 실행해야 하는 함수나 기능 작성 위치
			//alert("Init 완료");
		});

		nxTSPKI.init(true);
    });

</script>


</body>
</html>
