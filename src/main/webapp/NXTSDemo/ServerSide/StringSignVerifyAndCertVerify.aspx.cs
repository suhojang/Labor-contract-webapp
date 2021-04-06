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
	/// StringSignVerifyAndCertVerify에 대한 요약 설명입니다.
	/// </summary>
	public class StringSignVerifyAndCertVerify : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox plainText;
		protected System.Web.UI.WebControls.Button Signbtn;
		protected System.Web.UI.WebControls.TextBox signdata;
		protected System.Web.UI.WebControls.Button Verifybtn;
		protected System.Web.UI.WebControls.TextBox Verifydata;

		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator1;
		protected System.Web.UI.WebControls.ValidationSummary Validationsummary1;

		static KTNET.SignedData sd;

		static byte[] sdData;	// 서명된 데이타

		private void Page_Load(object sender, System.EventArgs e)
		{
			// 여기에 사용자 코드를 배치하여 페이지를 초기화합니다.
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
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void Signbtn_Click(object sender, System.EventArgs e)
		{
			// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
			string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
			// 환경 설정 파일을 load 한다. 
			Config.loadConfig(cfg_file);

			System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

			sd = new KTNET.SignedData();
			
			sd.SignKey = Config.getSignKey(0);
			sd.SignCert = Config.getSignCert(0);
			
			// 인증서 비밀번호 설정
			sd.SignCertPwd = Config.getSignPwd(0);
			
			sdData = sd.makeSignData(encoding.GetBytes(plainText.Text));
		
			signdata.Text = KTNET.Util.Base64Encoding(sdData);		
		}
		private void Verifybtn_Click(object sender, System.EventArgs e)
		{
			// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
			string config_path = ConfigurationManager.AppSettings["config_path"];
				
			// 환경 설정 파일을 load 한다. 
			Config.loadConfig(config_path);

			System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

			byte[] b64buf = KTNET.Util.Base64Decoding(signdata.Text);
			
			sd = new KTNET.SignedData();
			
			X509Certificate[] certs = sd.verify( b64buf );

			foreach ( X509Certificate c in certs)
			{	
				//인증서 검증
				c.validate();
			}

			byte[] conInsd = sd.ContentData;
			Verifydata.Text = encoding.GetString(conInsd);

		}
	}
}
