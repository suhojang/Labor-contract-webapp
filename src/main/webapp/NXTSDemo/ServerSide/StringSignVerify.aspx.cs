using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Configuration;
using KTNET;

namespace NetToolkitDemo.ServerSide
{
	/// <summary>
	/// StringSignVerify에 대한 요약 설명입니다.
	/// </summary>
	public class StringSignVerify : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox plainText;
		protected System.Web.UI.WebControls.Button Signbtn;
		protected System.Web.UI.WebControls.TextBox signdata;
		protected System.Web.UI.WebControls.Button Verifybtn;
		protected System.Web.UI.WebControls.TextBox Verifydata;
		protected System.Web.UI.WebControls.Label SubjectDN;
		protected System.Web.UI.WebControls.Label SerialNumber;
		protected System.Web.UI.WebControls.Label CertPolicy;
		protected System.Web.UI.WebControls.Label IssuerDN;
		protected System.Web.UI.WebControls.Label ValidityBefore;
		protected System.Web.UI.WebControls.Label ValidityAfter;
		protected System.Web.UI.WebControls.Button Resetbtn;
		protected System.Web.UI.WebControls.DropDownList ListBox1;

		private void Page_Load(object sender, System.EventArgs e)
		{
			// 여기에 사용자 코드를 배치하여 페이지를 초기화합니다.
			
			//서명하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Signbtn.Attributes.Add("onclick", "return plainTextchk();");
			
			//검정하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Verifybtn.Attributes.Add("onclick", "return Verifychk();");
			

		}

		#region Web Form 디자이너에서 생성한 코드
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: 이 호출은 ASP.NET Web Form 디자이너에 필요합니다.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// 디자이너 지원에 필요한 메서드입니다.
		/// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
		/// </summary>
		private void InitializeComponent()
		{   
			this.Signbtn.Click += new System.EventHandler(this.Signbtn_Click);
			this.Verifybtn.Click += new System.EventHandler(this.Verifybtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void Signbtn_Click(object sender, System.EventArgs e)
		{
			try
			{

				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string cfg_file = ConfigurationManager.AppSettings["config_path"];

				//Response.Write(verifycnd.SelectedValue
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(cfg_file);

				byte[] sdData;	// 서명된 데이타를 넣을 변수

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

				KTNET.SignedData sd = new KTNET.SignedData();
			
				// 환경 설정 파일에 저장된 인증서 파일 로드
				sd.SignCert = Config.getSignCert(0);

				// 환경 설정 파일에 저장된 인증서키 로드
				sd.SignKey = Config.getSignKey(0);
			
				// 인증서 비밀번호 설정
				sd.SignCertPwd = Config.getSignPwd(0);

				// plainText 필드에 입력된 사용자 데이타로 Singed data 를 만든다				
				sdData = sd.makeSignData(encoding.GetBytes(plainText.Text));
			
				// Base64 인코딩후 화면에 출력
				signdata.Text = KTNET.Util.Base64Encoding(sdData);				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
		private void Verifybtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(cfg_file);

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// SignedData 객체 생성
				KTNET.SignedData sd = new KTNET.SignedData();

				// 환경 설정 파일에 저장된 인증서키 로드
				sd.SignKey = Config.getSignKey(0);
				sd.SignCertPwd = Config.getSignPwd(0);

				// signdata 필드에 저장된 내용을 Base64 디코딩후 저장
				byte[] sdData = KTNET.Util.Base64Decoding(signdata.Text);

				sd.verify( sdData );

				bool cert_verify = ListBox1.Items[1].Selected;
		
				// 서명된 데이타 검증
				X509Certificate[] certs = sd.verify( sdData );
		
				//인증서 검증 및 정보 출력
				SubjectDN.Text = SerialNumber.Text = CertPolicy.Text = IssuerDN.Text = ValidityBefore.Text = ValidityAfter.Text = "";

				foreach ( X509Certificate c in certs)
				{	
					//인증서 검증
					if (cert_verify)
						c.validate();
			
					// 인증서 DN 값 SubjectDN 에 설정
					SubjectDN.Text += "<br>DN : " + c.SubjectDN;
				
					// 인증서 Serial 값 SerialNumber 에 설정
					SerialNumber.Text += "<br>Serial : " + c.SerialNumber;
				
					// 인증서 인증서정책 CertPolicy 에 설정
					CertPolicy.Text += "<br>인증서정책 : " + c.CertPolicy;
				
					// 인증서 발급자 DN IssuerDN 에 설정
					IssuerDN.Text += "<br>발급자 DN: " + c.IssuerDN;
				
					// 인증서 유효기간 시작 ValidityBefore 에 설정
					ValidityBefore.Text += "<br>유효기간 시작: " + c.ValidityBefore;
				
					// 인증서 유효기간 끝 ValidityAfter 에 설정
					ValidityAfter.Text += "<br>유효기간 끝: " + c.ValidityAfter;
				}
				
				// 서명된 원문 데이타를 가져와 Verifydata 필드에 설정
				byte[] conInsd = sd.ContentData;
				Verifydata.Text = encoding.GetString(conInsd);

			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}

		private void Resetbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				// 각각의 필드 데이타 초기화
				plainText.Text="";
				signdata.Text = "";
				Verifydata.Text = "";
				SubjectDN.Text = "";
				SerialNumber.Text = "";
				CertPolicy.Text = "";
				IssuerDN.Text = "";
				ValidityBefore.Text = "";
				ValidityAfter.Text = "";

				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	}
}
