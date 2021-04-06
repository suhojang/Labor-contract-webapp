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
	/// FileEncryptAndDecrypt에 대한 요약 설명입니다.
	/// </summary>
	public class FileEncryptAndDecrypt : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox keyPwd;
		protected System.Web.UI.HtmlControls.HtmlInputFile encfile;
		protected System.Web.UI.WebControls.TextBox plaindata;
		protected System.Web.UI.WebControls.Button encbtn;
		protected System.Web.UI.WebControls.TextBox encdata;
		protected System.Web.UI.WebControls.Label encmsg;
		protected System.Web.UI.WebControls.TextBox decdata;
		protected System.Web.UI.WebControls.Button decbtn;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			//Encrypt File 버튼을 눌렀을때 자바 스크립트로 내용 체크
			encbtn.Attributes.Add("onclick", "return plainTextchk();");
			
			//Decrypt File 버튼을 눌렀을때 자바 스크립트로 내용 체크
			decbtn.Attributes.Add("onclick", "return Verifychk();");
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
			this.encbtn.Click += new System.EventHandler(this.encbtn_Click);
			this.decbtn.Click += new System.EventHandler(this.decbtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void encbtn_Click(object sender, System.EventArgs e)
		{
			if( ( encfile.PostedFile != null ) && ( encfile.PostedFile.ContentLength > 0 ) )
			{
				// 파일 이름 가져오기
				string fn = System.IO.Path.GetFileName(encfile.PostedFile.FileName);
				
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
					encfile.PostedFile.SaveAs(SaveLocation);

					byte[] filedata;
					
					// SaveLocation 에 저장된 원본 파일을 읽어 filedata 에 저장
					FileInfo f= new FileInfo(SaveLocation );
					FileStream fos = new FileStream(SaveLocation , FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					
					// filedata 에 저장된 내용을 plaindata에 보여준다
					plaindata.Text = KTNET.Util.Base64Encoding(filedata);

					// Encrypt 객체 생성
					KTNET.Encrypt enc = new KTNET.Encrypt();
					
					// 환경 설정 파일에 저장된 암호화 알고리즘과 암호화 모드 설정 
					enc.EncryptAlgorithm = Config.EncryptionAlgorithm;
					enc.ModeOfOperation = Config.EncryptionMode;
					
					// 대칭키 생성
					enc.GenerateSecretKey();
	
					// IV 데이타를 가져옴
					byte[] IVData = enc.IVData;
					
					// IVData 를 decript 시 사용하기 위해 Ivkey hidden 필드의 값으로 설정 
					Page.ClientScript.RegisterHiddenField("Ivkey", KTNET.Util.Base64Encoding(IVData)); 
					
					// 대칭키 데이타를 keyPwd 에 설정
					keyPwd.Text = KTNET.Util.Base64Encoding(enc.KeyData);
					
					// SaveLocation 에 저장된 파일을 SaveLocation.enc 파일로 암호화
					enc.encryptFile(SaveLocation, SaveLocation + ".enc", true);

					// SaveLocation.enc 파일을 base64 인코딩 후 SaveLocation.b64enc 파일로 저장.
					KTNET.Util.Base64EncodingFile(SaveLocation + ".enc", SaveLocation + ".b64enc" , true);
					
					// SaveLocation.b64enc 에 저장된 Encrypt 된 파일을 읽어 filedata 에 저장
					f= new FileInfo(SaveLocation + ".b64enc");
					fos = new FileStream(SaveLocation + ".b64enc", FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					//f.Delete();
					
					// filedata 에 저장된 내용을 encdata 에 보여준다
					encdata.Text = KTNET.Util.Base64Encoding(filedata);
					encmsg.Text = "Encrypt 된 파일이 서버의<BR>"+SaveLocation+".b64enc 로 저장";

					//decfile.Text = SaveLocation + ".b64enc";

					
				}
				catch ( Exception ex )
				{
					Response.Write("Error: " + ex.Message);
				}
			}
			else
			{
				Response.Write("Encrypt 할 파일을 선택해 주세요");
			}
		}
		private void decbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

				// Web.config 파일에서 환경 설정 파일 경로 값 config_path 을 읽어온다 
				string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
				// 환경 설정 파일을 load 한다. 
				Config.loadConfig(cfg_file);

				// Encrypt 객체 생성
				KTNET.Encrypt enc = new KTNET.Encrypt();
			
				// keyPwd 필드에 설정된 대칭키와 hidden 값으로 저장된 Ivkey 값을 가져와 대칭키와 IV 데이타로 설정
				enc.KeyData = KTNET.Util.Base64Decoding(keyPwd.Text);
				enc.IVData = KTNET.Util.Base64Decoding(Request["Ivkey"]);
			
				// Encrypt 된 내용을 읽어와 파일로 저장할 경로 설정 
				string SaveLocation = Server.MapPath("Data") + "\\signdata.sgn";  

				// Encrypt 된 내용을 읽어와 Encdata 에 저장
				byte[] Encdata = KTNET.Util.Base64Decoding(encdata.Text);
			
				// Encdata에 저장된 내용을 읽어와 Savelocation에 저장한다.
				FileStream fos = new FileStream(SaveLocation, FileMode.Create, FileAccess.Write);
				fos.Write(Encdata, 0, Encdata.Length);
				fos.Close();
			
				// 이 파일 내용을 Base64 디코딩 후 SaveLocation.b64_dec 에 저장한다.
				KTNET.Util.Base64DecodingFile(SaveLocation, SaveLocation + ".b64_dec", true);
			
				// SaveLocation.b64_dec 파일을 읽어와 SaveLocation.dec 파일로 저장한다.  
				enc.decryptFile(SaveLocation+ ".b64_dec", SaveLocation + ".dec", true);
			
				byte[] filedata;
			
				// SaveLocation.dec 파일에 저장된 데이타를 filedata 로 읽어온다 
				FileInfo f= new FileInfo(SaveLocation + ".dec" );
				fos = new FileStream(SaveLocation + ".dec" , FileMode.Open, FileAccess.Read);
				filedata = new byte[f.Length];
				fos.Read(filedata, 0, (int)f.Length);
				fos.Close();
					
				// filedata  를 decdata 에 설정한다
				decdata.Text = KTNET.Util.Base64Encoding(filedata);
					
				f.Delete();
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
				keyPwd.Text="";
				plaindata.Text = "";
				encdata.Text = "";
				encmsg.Text = "";
				decdata.Text = "";
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	}
}
