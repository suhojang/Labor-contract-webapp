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
	/// FileEnvelopAndEnvelopVerify에 대한 요약 설명입니다.
	/// </summary>
	public class FileEnvelopAndEnvelopVerify : System.Web.UI.Page
	{
		protected System.Web.UI.HtmlControls.HtmlInputFile envfile;
		protected System.Web.UI.WebControls.Button envbtn;
		protected System.Web.UI.WebControls.Label envmsg;
		protected System.Web.UI.WebControls.TextBox plaindata;
		protected System.Web.UI.WebControls.TextBox envdata;
		protected System.Web.UI.WebControls.TextBox verifydata;
		protected System.Web.UI.WebControls.Button devbtn;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			// 여기에 사용자 코드를 배치하여 페이지를 초기화합니다.

			//Envelop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			envbtn.Attributes.Add("onclick", "return signfilechk();");
			
			//Develop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			devbtn.Attributes.Add("onclick", "return Verifychk();");
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
			this.envbtn.Click += new System.EventHandler(this.envbtn_Click);
			this.devbtn.Click += new System.EventHandler(this.devbtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void envbtn_Click(object sender, System.EventArgs e)
		{
			if( ( envfile.PostedFile != null ) && ( envfile.PostedFile.ContentLength > 0 ) )
			{
				// 파일 이름 가져오기
				string fn = System.IO.Path.GetFileName(envfile.PostedFile.FileName);
				
				// 파일 저장위치 설정
				string SaveLocation = Server.MapPath("Data") + "\\" +  fn;
				try
				{
					System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
					
					// SaveLocation 에 파일저장
					envfile.PostedFile.SaveAs(SaveLocation);

					// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
					string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
					// 환경 설정 파일을 load 한다. 
					Config.loadConfig(cfg_file);
					
					// EnvelopedData 객체 생성
					KTNET.EnvelopedData ed = new KTNET.EnvelopedData();
					
					// EnvelopedData 가 저장될 경로 설정
					string outfile = SaveLocation+".ber";
					
					// 환경 설정 파일에 저장된 상대방 인증서 설정
					ed.PeerCert = Config.getKmCert(0);

					// SaveLocation 에 저장된 파일을 읽어와 전자봉투 생성한 파일을 outfile 경로에 저장
					ed.makeEnvelopDataFile(SaveLocation, outfile, true);

					envmsg.Text = "Envelop 된 파일이 <BR>"+outfile+" 로 저장";

					byte[] filedata;
					
					// SaveLocation 에 저장된 원본 파일을 읽어 filedata 에 저장
					FileInfo f= new FileInfo(SaveLocation );
					filedata = new byte[f.Length];
					using ( FileStream fos = new FileStream(SaveLocation , FileMode.Open, FileAccess.Read) )
					{
						fos.Read(filedata, 0, (int)f.Length);
					}

					// filedata 에 저장된 내용을 plaindata에 보여준다
					plaindata.Text = KTNET.Util.Base64Encoding(filedata);
					
					// Upload 된 파일을 지운다. 서버상에서 업로드를 확인하고 싶으면 삭제
					f.Delete();

					// outfile 에 저장된 Enveloped 된 파일을 읽어 filedata 에 저장
					f= new FileInfo(outfile);
					filedata = new byte[f.Length];
					using ( FileStream fos = new FileStream(outfile, FileMode.Open, FileAccess.Read) )
					{
						fos.Read(filedata, 0, (int)f.Length);
					}

					// filedata 에 저장된 내용을 envdata에 보여준다
					envdata.Text = KTNET.Util.Base64Encoding(filedata);
					
					// envdata 된 파일을 지운다. 서버상에서 파일 내용을 확인하고 싶으면 삭제
					f.Delete();
				}
				catch ( Exception ex )
				{
					Response.Write("Env Error: " + ex.Message);
				}
			}
			else
			{
				Response.Write("Envelop 할 파일을 선택해 주세요");
			}
		}
		private void devbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(config_path);
			
				// Enveloped된 내용을 읽어와 파일로 저장할 경로 설정 
				string SaveLocation = Server.MapPath("Data") + "\\envdata.env";  

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// envdata 필드에 저장된 내용을 일어와 Savelocation에 저장한다.
				byte[] Orgdata = KTNET.Util.Base64Decoding(envdata.Text);
				using ( FileStream fos = new FileStream(SaveLocation, FileMode.Create, FileAccess.Write) )
				{
					fos.Write(Orgdata, 0, Orgdata.Length);
				}
			
				// EnvelopedData 객체 생성
				KTNET.EnvelopedData ed = new KTNET.EnvelopedData();
			
				// 전자봉투파일 해제를 위해 인증서, 개인키, 개인키 암호를 설정
				ed.KmCert = Config.getKmCert(0);
				ed.KmKey = Config.getKmKey(0);
				ed.KmCertPwd = Config.getKmPwd(0);
			
				// SaveLocation 에 저장된 Enveloped 데이타를 Develop 한다.
				ed.decryptEnvelopedDataFile(SaveLocation, SaveLocation + ".dev", true);
										
				byte[] conInsd = KTNET.Util.loadFile(SaveLocation + ".dev");
			
				// conInsd 정보를 verifydata 필드에 보여준다.
				verifydata.Text = KTNET.Util.Base64Encoding(conInsd);
			}
			catch ( Exception ex )
			{
				Response.Write("Dev Error: " + ex.Message);
			}
		}

		private void Resetbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				// 각각의 필드 데이타 초기화
				envmsg.Text="";
				plaindata.Text = "";
				envdata.Text = "";
				verifydata.Text = "";
				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	}
}
