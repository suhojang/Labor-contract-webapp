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
using System.Configuration;
using KTNET;

namespace NetToolkitDemo.ServerSide
{
	/// <summary>
	/// CheckVID에 대한 요약 설명입니다.
	/// </summary>
	public class CheckVID : System.Web.UI.Page
	{
		protected System.Web.UI.HtmlControls.HtmlInputFile certfile;
		protected System.Web.UI.WebControls.TextBox ssn;
		protected System.Web.UI.WebControls.Button Checkbtn;
		protected System.Web.UI.WebControls.Label checkMsg;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			// 여기에 사용자 코드를 배치하여 페이지를 초기화합니다.

			//Envelop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Checkbtn.Attributes.Add("onclick", "return signfilechk();");
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
			this.Checkbtn.Click += new System.EventHandler(this.Checkbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void Checkbtn_Click(object sender, System.EventArgs e)
		{

			try
			{
				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(cfg_file);

				// 서버인증서 신원확인
				byte[] random = Util.getRandomFromKey(Config.getSignKey(0), Config.getSignPwd(0));
				X509Certificate cert = new X509Certificate(Config.getSignCert(0));

				//  넘어온 ssn 번호와 random 번호로 인증서의 신원을 확인한다.
				bool ret = cert.verifyVID(ssn.Text, random);

				if (ret)
				{
					checkMsg.Text = "신원확인 성공";
				}				
				else
				{
					checkMsg.Text = "신원확인 실패";
				}
			}
			catch ( Exception ex )
			{
				Response.Write("Error: " + ex.Message);
			}

		}

	}
}
