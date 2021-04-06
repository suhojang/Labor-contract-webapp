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

namespace NetToolkitDemo.ServerSide
{
	/// <summary>
	/// FileBase64에 대한 요약 설명입니다.
	/// </summary>
	public class FileBase64 : System.Web.UI.Page
	{
		protected System.Web.UI.HtmlControls.HtmlInputFile base64file;
		protected System.Web.UI.WebControls.Button base64btn;
		protected System.Web.UI.WebControls.Label base64msg;
		protected System.Web.UI.WebControls.TextBox plaindata;
		protected System.Web.UI.WebControls.TextBox b64data;
		protected System.Web.UI.WebControls.Button base64decbtn;
		protected System.Web.UI.WebControls.TextBox base64decdata;
		protected System.Web.UI.WebControls.Button Resetbtn;
			
		private void Page_Load(object sender, System.EventArgs e)
		{
			//Base64 Encode File 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			base64btn.Attributes.Add("onclick", "return signfilechk();");
			
			//Base64 Decode File 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			base64decbtn.Attributes.Add("onclick", "return Verifychk();");
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
			this.base64btn.Click += new System.EventHandler(this.base64btn_Click);
			this.base64decbtn.Click += new System.EventHandler(this.base64decbtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void base64btn_Click(object sender, System.EventArgs e)
		{
			if( ( base64file.PostedFile != null ) && ( base64file.PostedFile.ContentLength > 0 ) )
			{	
				// 파일 이름 가져오기
				string fn = System.IO.Path.GetFileName(base64file.PostedFile.FileName);

				// 파일 저장위치 설정
				string SaveLocation = Server.MapPath("Data") + "\\" +  fn;
				try
				{
					System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
					
					// SaveLocation 에 파일저장
					base64file.PostedFile.SaveAs(SaveLocation);

					byte[] filedata;
					
					// SaveLocation 에 저장된 원본 파일을 읽어 filedata 에 저장
					FileInfo f= new FileInfo(SaveLocation );
					FileStream fos = new FileStream(SaveLocation , FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					
					// filedata 에 저장된 내용을 plaindata에 보여준다
					plaindata.Text = KTNET.Util.Base64Encoding(filedata);

					// SaveLocation 에 저장된 파일을 base64 인코딩 후 SaveLocation.b64 에 저장
					KTNET.Util.Base64EncodingFile(SaveLocation , SaveLocation + ".b64" , true);
					
					base64msg.Text = "Base64Encoding 된 파일이 서버의<BR>"+SaveLocation+".b64 로 저장";
					
					// SaveLocation.b64 에 저장된 base64 인코딩 된 파일을 읽어 filedata 에 저장
					f= new FileInfo(SaveLocation + ".b64");
					fos = new FileStream(SaveLocation + ".b64", FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					f.Delete();
					
					// filedata를 읽어와 base64 인코딩 후 b64data 에 보여준다.
					b64data.Text = KTNET.Util.Base64Encoding(filedata);
					
					// SaveLocation 에 저장된 파일 삭제
					f= new FileInfo(SaveLocation );
					f.Delete();


				}
				catch ( Exception ex )
				{
					Response.Write("Error: " + ex.Message);
				}
			}
			else
			{
				Response.Write("Base64 Encoding 할 파일을 선택해 주세요");
			}
			
		}
		private void base64decbtn_Click(object sender, System.EventArgs e)
		{
			try
			{	
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// base64 인코딩 된 내용을 읽어와 파일로 저장할 경로 설정 
				string SaveLocation = Server.MapPath("Data") + "\\base64data.b64";   
			
				// b64data 에 저장되어 있는 데이타를 읽어와 base64 디코딩 후 base64data 에 저장
				byte[] base64data = KTNET.Util.Base64Decoding(b64data.Text);
			
				// base64data 를 가져다 SaveLocation 파일로 저장
				FileStream fos = new FileStream(SaveLocation, FileMode.Create, FileAccess.Write);
				fos.Write(base64data, 0, base64data.Length);
				fos.Close();


				// SaveLocation 에 저장되어있는 파일을 읽어 base64 Decoding 후 SaveLocation.org 파일로 저장
				KTNET.Util.Base64DecodingFile(SaveLocation , SaveLocation + ".org" , true);
		
				byte[] filedata;
			
				// SaveLocation.org 파일에 저장된 데이타를 filedata 로 읽어온다 
				FileInfo f= new FileInfo(SaveLocation + ".org" );
				fos = new FileStream(SaveLocation + ".org" , FileMode.Open, FileAccess.Read);
				filedata = new byte[f.Length];
				fos.Read(filedata, 0, (int)f.Length);
				fos.Close();
			
				// filedata  를 base64decdata 에 설정한다
				base64decdata.Text = KTNET.Util.Base64Encoding(filedata);
					
				f.Delete();

				f= new FileInfo(SaveLocation );
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
				base64msg.Text="";
				plaindata.Text = "";
				b64data.Text="";
				base64decdata.Text = "";

			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}

	}
}
