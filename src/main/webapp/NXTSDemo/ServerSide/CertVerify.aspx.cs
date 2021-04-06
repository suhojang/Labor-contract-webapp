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
	/// CertVerify에 대한 요약 설명입니다.
	/// </summary>
	public class CertVerify : System.Web.UI.Page
	{
		protected System.Web.UI.HtmlControls.HtmlInputFile veryfifile;
		protected System.Web.UI.WebControls.Label cert;
		protected System.Web.UI.WebControls.Label verifymsg;
		protected System.Web.UI.WebControls.Button verifybtn;
		protected System.Web.UI.WebControls.Label SubjectDN;
		protected System.Web.UI.WebControls.Label SerialNumber;
		protected System.Web.UI.WebControls.Label CertPolicy;
		protected System.Web.UI.WebControls.Label IssuerDN;
		protected System.Web.UI.WebControls.Label ValidityBefore;
		protected System.Web.UI.WebControls.Label ValidityAfter;

		private void Page_Load(object sender, System.EventArgs e)
		{
			//인증서 검증 버튼을 눌렀을때 자바 스크립트로 내용 체크
			verifybtn.Attributes.Add("onclick", "return signfilechk();");
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
			this.verifybtn.Click += new System.EventHandler(this.verifybtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void verifybtn_Click(object sender, System.EventArgs e)
		{
			
			if( ( veryfifile.PostedFile != null ) && ( veryfifile.PostedFile.ContentLength > 0 ) )
			{
				try
				{
					// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
					string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
					// 환경 설정 파일을 load 한다. 
					Config.loadConfig(cfg_file);

					// 업로드 된 파일 크기 구하기
					int len = veryfifile.PostedFile.ContentLength;

					// 업로드 된 파일 크기만큼 filedata 할당
					byte[] filedata = new byte[len];
					
					// filedata 에 읽어들인다
					veryfifile.PostedFile.InputStream.Read (filedata, 0, len);

					// SaveLocation 에 저장된 인증서 파일을 가져와 X509Certificate 객체 c 를 생성
					X509Certificate c = new X509Certificate(filedata);		
			
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
				Response.Write("인증서 파일을 선택해 주세요");
			}
		}
	}
}
