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
	/// StringEnvelopAndEnvelopVerify에 대한 요약 설명입니다.
	/// </summary>
	public class StringEnvelopAndEnvelopVerify : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox plainText;
		protected System.Web.UI.WebControls.Button Envelopbtn;
		protected System.Web.UI.WebControls.TextBox Envelopdata;
		protected System.Web.UI.WebControls.Button Developbtn;
		protected System.Web.UI.WebControls.TextBox Developdata;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			// 여기에 사용자 코드를 배치하여 페이지를 초기화합니다.

			//Envelop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Envelopbtn.Attributes.Add("onclick", "return signfilechk();");
			
			//Develop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Developbtn.Attributes.Add("onclick", "return Verifychk();");
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
			this.Envelopbtn.Click += new System.EventHandler(this.Envelopbtn_Click);
			this.Developbtn.Click += new System.EventHandler(this.Developbtn_Click); 
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void Envelopbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(config_path);
			
				// Enveloped 데이타를 저장할 변수
				byte[] envData;	
			
				// EnvelopedData 객체 생성
				KTNET.EnvelopedData ed = new KTNET.EnvelopedData();
			
				// 환경 설정 파일에 저장된 상대방 인증서 설정
				ed.PeerCert = Config.getKmCert(0);

				// plainText 에 입력된 데이타를 읽어와 전자봉투 생성
				envData = ed.makeEnvelopData(encoding.GetBytes(plainText.Text));

				// 생성 된 전자 봉투 내용을 Base64 인코딩후 Envelopdata 필드에 설정				
				Envelopdata.Text = KTNET.Util.Base64Encoding(envData);
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	
		private void Developbtn_Click(object sender, System.EventArgs e)
		{
			
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(config_path);
			
				byte[] devData;	// 서명된 데이타를 저장할 변수
			
				// EnvelopedData 객체 생성
				KTNET.EnvelopedData ed = new KTNET.EnvelopedData();
			
				ed.PeerCert = Config.getKmCert(0);

				// 전자봉투 해제를 위해 상대방 인증서 정보 인증서, 개인키, 개인키 암호를 설정
				ed.KmCert = Config.getKmCert(0);
				ed.KmKey = Config.getKmKey(0);
				ed.KmCertPwd = Config.getKmPwd(0);
			
				// Envelopdata 필드에 설정된 전자봉투 데이타 내용을 Base64 디코딩 후 Tmpbuf 에 설정
				byte[] Tmpbuf = KTNET.Util.Base64Decoding(Envelopdata.Text);
			
				// b64buf에 저장된 데이타를 해제한다. 이 데이타는  ed.OutData 에 저장				
				devData = ed.decryptEnvelopedData(Tmpbuf);
			
				// devData 데이타를 Developdata 에 보여준다.
				Developdata.Text = encoding.GetString(devData);
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
				Envelopdata.Text = "";
				Developdata.Text = "";
				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	}

}
