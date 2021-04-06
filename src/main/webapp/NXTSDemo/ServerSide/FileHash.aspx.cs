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

using KTNET;

namespace NetToolkitDemo.ServerSide
{
	/// <summary>
	/// FileHash에 대한 요약 설명입니다.
	/// </summary>
	public class FileHash : System.Web.UI.Page
	{
		protected System.Web.UI.HtmlControls.HtmlInputFile hashfile;
		protected System.Web.UI.WebControls.Button hashbtn;
		protected System.Web.UI.WebControls.Label hashmsg;
		protected System.Web.UI.WebControls.TextBox hashdata;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			// 여기에 사용자 코드를 배치하여 페이지를 초기화합니다.

			//Hash File 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			hashbtn.Attributes.Add("onclick", "return signfilechk();");
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
			this.hashbtn.Click += new System.EventHandler(this.hashbtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion
		
		private void hashbtn_Click(object sender, System.EventArgs e)
		{
			if( ( hashfile.PostedFile != null ) && ( hashfile.PostedFile.ContentLength > 0 ) )
			{
				// 파일 이름 가져오기
				string fn = System.IO.Path.GetFileName(hashfile.PostedFile.FileName);
				
				// 파일 저장위치 설정
				string SaveLocation = Server.MapPath("Data") + "\\" +  fn;
				try
				{
					System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
					
					// SaveLocation 에 파일저장
					hashfile.PostedFile.SaveAs(SaveLocation);
					
					// SaveLocation에 저장된 file을 읽어와 설정된 Hash 알고리즘 아이디로 hash 한 후 SaveLocation.hash 로 저장 
					KTNET.Util.HashDataFile("SHA1", SaveLocation, SaveLocation + ".hash", true);
					
					hashmsg.Text = "Hash 된 파일이 서버의<BR>"+SaveLocation+".hash 로 저장";
					
					// SaveLocation.hash 파일을 base64 인코딩 한다.
					KTNET.Util.Base64EncodingFile(SaveLocation + ".hash", SaveLocation + ".b64enc" , true);
					
					byte[] hashfiledata;
					
					// base64 인코딩 된후 저장된 SaveLocation.b64enc 파일을 hashfiledata 에 읽어 들인다.
					FileInfo f= new FileInfo(SaveLocation + ".b64enc");
					FileStream fos = new FileStream(SaveLocation + ".b64enc", FileMode.Open, FileAccess.Read);
					hashfiledata = new byte[f.Length];
					fos.Read(hashfiledata, 0, (int)f.Length);
					fos.Close();
					f.Delete();
					
					// SaveLocation 에 저장된 파일 삭제
					f = new FileInfo(SaveLocation );
					f.Delete();
					
					// SaveLocation.hash 에 저장된 파일 삭제
					f = new FileInfo(SaveLocation + ".hash");
					f.Delete();
					
					// hashfiledata 에 저장된 내용을 hashdata 에 보여준다
					hashdata.Text = encoding.GetString(hashfiledata);

				}
				catch ( Exception ex )
				{
					Response.Write("Error: " + ex.Message);
				}
			}
			else
			{
				Response.Write("Hash 할 파일을 선택해 주세요");
			}
		}
		private void Resetbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				// 각각의 필드 데이타 초기화
				hashmsg.Text="";
				hashdata.Text = "";
				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	}
}
