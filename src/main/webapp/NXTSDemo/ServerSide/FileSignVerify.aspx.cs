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
	/// FileSignVerify에 대한 요약 설명입니다.
	/// </summary>
	public class FileSignVerify : System.Web.UI.Page
	{	
		protected System.Web.UI.HtmlControls.HtmlInputFile signfile;
		protected System.Web.UI.WebControls.Button Signbtn;
		protected System.Web.UI.WebControls.Label signmsg;
		protected System.Web.UI.WebControls.TextBox plaindata;
		protected System.Web.UI.WebControls.TextBox signdata;
		protected System.Web.UI.WebControls.Button Verifybtn;
		protected System.Web.UI.WebControls.TextBox verifydata;
		protected System.Web.UI.WebControls.Label SubjectDN;
		protected System.Web.UI.WebControls.Label SerialNumber;
		protected System.Web.UI.WebControls.Label CertPolicy;
		protected System.Web.UI.WebControls.Label IssuerDN;
		protected System.Web.UI.WebControls.Label ValidityBefore;
		protected System.Web.UI.WebControls.Label ValidityAfter;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{

			//서명하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Signbtn.Attributes.Add("onclick", "return signfilechk();");
			
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
			if( ( signfile.PostedFile != null ) && ( signfile.PostedFile.ContentLength > 0 ) )
			{
				// 파일 이름 가져오기
				string fn = System.IO.Path.GetFileName(signfile.PostedFile.FileName);
				
				// 파일 저장위치 설정
				string SaveLocation = Server.MapPath("Data") + "\\" +  fn;
				
				try
				{
					// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
					string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
					// 환경 설정 파일을 load 한다. 
					Config.loadConfig(cfg_file);

					System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
					
					// SaveLocation 에 파일저장
					signfile.PostedFile.SaveAs(SaveLocation);
					
					// SignedData 객체 생성
					KTNET.SignedData sd = new KTNET.SignedData();
					
					// 환경 설정 파일에 저장된 인증서 파일 로드
					sd.SignCert = Config.getSignCert(0);

					// 환경 설정 파일에 저장된 인증서키 로드
					sd.SignKey = Config.getSignKey(0);
			
					// 인증서 비밀번호 로드
					sd.SignCertPwd = Config.getSignPwd(0);

					// 서명한 파일을  SaveLocation + ".sign" 에 저장
					sd.makeSignDataFile(SaveLocation, SaveLocation + ".sign" , true);

					signmsg.Text = "서명 된 파일이 서버의<BR>"+SaveLocation+".sign 로 저장";
					
					byte[] filedata;
					
					// SaveLocation 에 저장된 원본 파일을 읽어 filedata 에 저장
					FileInfo f= new FileInfo(SaveLocation );
					FileStream fos = new FileStream(SaveLocation , FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					
					// filedata 에 저장된 내용을 plaindata에 보여준다
					plaindata.Text = KTNET.Util.Base64Encoding(filedata);
					
					// Upload 된 파일을 지운다. 서버상에서 업로드를 확인하고 싶으면 아래 삭제
					f.Delete();
					
					// SaveLocation 에 저장된 Singed 된 파일 을 읽어 filedata 에 저장
					f= new FileInfo(SaveLocation + ".sign");
					fos = new FileStream(SaveLocation + ".sign", FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					
					// filedata 에 저장된 내용을 signdata에 보여준다
					signdata.Text = KTNET.Util.Base64Encoding(filedata);
					
					// singned 된 파일을 지운다. 서버상에서 파일 내용을 확인하고 싶으면 삭제
					f.Delete();

					// Config.SignCert 에 저장된 인증서 파일을 가져와 X509Certificate 객체 c 를 생성
					X509Certificate c = new X509Certificate(Config.getSignCert(0));		
			
					// 인증서를 검정한다.
					c.validate();

					// 인증서 DN 값 SubjectDN 에 설정
					SubjectDN.Text = "DN : " + c.SubjectDN;
					
					// 인증서 Serial 값 SerialNumber 에 설정
					SerialNumber.Text = "Serial : " + c.SerialNumber;
					
					// 인증서 인증서정책 CertPolicy 에 설정
					CertPolicy.Text = "인증서정책 : " + c.CertPolicy;
					
					// 인증서 발급자 DN IssuerDN 에 설정
					IssuerDN.Text = "발급자 DN: " + c.IssuerDN;
					
					// 인증서 유효기간 시작 ValidityBefore 에 설정
					ValidityBefore.Text = "유효기간 시작: " + c.ValidityBefore;
					
					// 인증서 유효기간 끝 ValidityAfter 에 설정
					ValidityAfter.Text = "유효기간 끝: " + c.ValidityAfter;

				}
				catch ( Exception ex )
				{
					Response.Write("Error: " + ex.Message);
				}
			}
			else
			{
				Response.Write("서명 할 파일을 선택해 주세요");
			}
			
		}

		private void Verifybtn_Click(object sender, System.EventArgs e)
		{
			try
			{	
				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(config_path);
			
				// 서명된 파일을 저장할 경로 설정 
				string SaveLocation = Server.MapPath("Data") + "\\signdata.sgn";   

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// signdata 필드에 설정된 내용을 읽어와 Signdata에 저장
				byte[] Signdata = KTNET.Util.Base64Decoding(signdata.Text);
			
				// Signdata 내용을 위에서 설정한 SaveLocation 에 저장한다.
				FileStream fos = new FileStream(SaveLocation, FileMode.Create, FileAccess.Write);
				fos.Write(Signdata, 0, Signdata.Length);
				fos.Close();
			
				// SignedData 객체 생성
				KTNET.SignedData sd = new KTNET.SignedData();
			
				// SaveLocation 에 저장된 파일 내용 검증
				X509Certificate[] certs = sd.verifyFile(SaveLocation);
			
				// SaveLocation 에 저장된 파일 삭제
				FileInfo file = new FileInfo(SaveLocation);
				file.Delete();

				//인증서 저장
				foreach ( X509Certificate c in certs)
				{
					//인증서 검증
					c.validate();

					// 인증서 DN 값 SubjectDN 에 설정
					SubjectDN.Text = "DN : " + c.SubjectDN;
					
					// 인증서 Serial 값 SerialNumber 에 설정
					SerialNumber.Text = "Serial : " + c.SerialNumber;
					
					// 인증서 인증서정책 CertPolicy 에 설정
					CertPolicy.Text = "인증서정책 : " + c.CertPolicy;
					
					// 인증서 발급자 DN IssuerDN 에 설정
					IssuerDN.Text = "발급자 DN: " + c.IssuerDN;
					
					// 인증서 유효기간 시작 ValidityBefore 에 설정
					ValidityBefore.Text = "유효기간 시작: " + c.ValidityBefore;
					
					// 인증서 유효기간 끝 ValidityAfter 에 설정
					ValidityAfter.Text = "유효기간 끝: " + c.ValidityAfter;
				}
			
				// 검증후 나온 데이타 sd.ContentData 를 conInsd 에 설정
				byte[] conInsd = sd.ContentData;

				// conInsd 정보를 SaveLocation+".org" 파일로 저장
				fos = new FileStream(SaveLocation+".org", FileMode.Create, FileAccess.Write);
				fos.Write(conInsd, 0, conInsd.Length);
				fos.Close();
			
				// SaveLocation+".org"  에 저장된 파일을 삭제한다. 파일을 확인하기위해서는 아래 삭제
				FileInfo f= new FileInfo(SaveLocation+".org" );
				f.Delete();
			
				// conInsd 정보를 verifydata 필드에 보여준다.
				verifydata.Text = KTNET.Util.Base64Encoding(conInsd);
			}
			catch ( Exception ex )
			{
				Response.Write("Error: " + ex.Message);
			}
		}
		private void Resetbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				// 각각의 필드 데이타 초기화
				signmsg.Text = "";
				plaindata.Text = "";
				signdata.Text = "";
				verifydata.Text = "";SubjectDN.Text = "";
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
