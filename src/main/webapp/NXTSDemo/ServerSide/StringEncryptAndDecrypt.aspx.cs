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
using System.IO;
using KTNET;


namespace NetToolkitDemo.ServerSide
{
	/// <summary>
	/// StringEncryptAndDecrypt에 대한 요약 설명입니다.
	/// </summary>
	public class StringEncryptAndDecrypt : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox keyPwd;
		protected System.Web.UI.WebControls.TextBox plainText;
		protected System.Web.UI.WebControls.Button Encryptbtn;
		protected System.Web.UI.WebControls.Label lblMsg;
		protected System.Web.UI.WebControls.Label Ivkey1;
		protected System.Web.UI.WebControls.TextBox encdata;
		protected System.Web.UI.WebControls.Button Decryptbtn;
		protected System.Web.UI.WebControls.TextBox decdata;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			// 여기에 사용자 코드를 배치하여 페이지를 초기화합니다.

			//Envelop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Encryptbtn.Attributes.Add("onclick", "return signfilechk();");
			
			//Develop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Decryptbtn.Attributes.Add("onclick", "return Verifychk();");
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
			this.Encryptbtn.Click += new System.EventHandler(this.Encryptbtn_Click);
			this.Decryptbtn.Click += new System.EventHandler(this.Decryptbtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void Encryptbtn_Click(object sender, System.EventArgs e)
		{
			try
			{	
				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(config_path);
				
				// Encrypt 객체 생성
				Encrypt enc = new Encrypt();
				
				// 환경 설정 파일에 저장된 암호화 알고리즘과 암호화 모드 설정 
				enc.EncryptAlgorithm = Config.EncryptionAlgorithm;
				enc.ModeOfOperation = Config.EncryptionMode;

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
				
				// 대칭키 생성
				enc.GenerateSecretKey();

				lblMsg.Text = "Encrypt 알고리즘 아이디 : " + enc.EncryptAlgorithm.ToString();
				
				// 대칭키와 IV 데이타를 가져옴
				byte[] keyData = enc.KeyData;
				byte[] IVData = enc.IVData;
				
				// IVData 를 decript 시 사용하기 위해 Ivkey hidden 필드의 값으로 설정 
				Page.ClientScript.RegisterHiddenField("Ivkey", KTNET.Util.Base64Encoding(IVData)); 
				
				// 대칭키 데이타를 keyPwd 에 설정
				keyPwd.Text = KTNET.Util.Base64Encoding(enc.KeyData);
				
				// plainText 에 입력된 데이타를 암호화				
				byte[] encbuf = enc.encryptData( encoding.GetBytes(plainText.Text));

				// encbuf 에 저장된 암호화 데이타를 encdata 필드에 설정 
				encdata.Text = KTNET.Util.Base64Encoding(encbuf);

				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}
		}

		private void Decryptbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
				
				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(config_path);

				// Encrypt 객체 생성
				Encrypt enc = new Encrypt();
				
				// 환경 설정 파일에 저장된 암호화 알고리즘과 암호화 모드 설정 
				enc.EncryptAlgorithm = Config.EncryptionAlgorithm;
				enc.ModeOfOperation = Config.EncryptionMode;
				
				// keyPwd 필드에 설정된 대칭키와 hidden 값으로 저장된 Ivkey 값을 가져와 대칭키와 IV 데이타로 설정
				enc.KeyData = KTNET.Util.Base64Decoding(keyPwd.Text);
				enc.IVData = KTNET.Util.Base64Decoding(Request["Ivkey"]);
				
				// IVData 를 decript 시 사용하기 위해 Ivkey hidden 필드의 값으로 설정 
				Page.ClientScript.RegisterHiddenField("Ivkey", Request["Ivkey"]); 
				
				// Encrypt 된 데이타를 Base64 디코딩후 Tmpdata 에 저장
				byte[] Tmpdata = KTNET.Util.Base64Decoding(encdata.Text);
				
				// Tmpdata 를 Decrypt 한다				
				byte[] orgData = enc.decryptData( Tmpdata);
				
				//Decrypt 한 데이타를 decdata 필드에 보여준다
				decdata.Text = encoding.GetString(orgData);
				
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
				keyPwd.Text="";
				plainText.Text = "";
				lblMsg.Text = "";
				encdata.Text = "";
				decdata.Text = "";
						
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}

	}
}
