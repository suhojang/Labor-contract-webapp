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
using KTNET;

namespace NetToolkitDemo.ServerSide
{
	/// <summary>
	/// StringBase64에 대한 요약 설명입니다.
	/// </summary>
	public class StringBase64 : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox data;
		protected System.Web.UI.WebControls.Button Base64encbtn;
		protected System.Web.UI.WebControls.TextBox Base64encdata;
		protected System.Web.UI.WebControls.Button Base64decbtn;
		protected System.Web.UI.WebControls.TextBox Base64decdata;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			//Envelop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Base64encbtn.Attributes.Add("onclick", "return signfilechk();");
			
			//Develop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Base64decbtn.Attributes.Add("onclick", "return Verifychk();");
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
			this.Base64encbtn.Click += new System.EventHandler(this.Base64encbtn_Click);
 			this.Base64decbtn.Click += new System.EventHandler(this.Base64decbtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void Base64encbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// data 필드에 입력된 데이타를 가져와 Base64 인코딩후 Base64encdata 에 설정
				Base64encdata.Text = KTNET.Util.Base64Encoding(encoding.GetBytes(data.Text));
			}
			catch ( Exception ex )
			{
				Response.Write("Error: " + ex.Message);
			}
		}
		private void Base64decbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// Base64encdata 필드에 저장된 Base64 인코딩 데이타를 가져와 Base64 디코딩후 Tmpbuf 에 설정
				byte[] Tmpbuf = KTNET.Util.Base64Decoding(Base64encdata.Text);
			
				// Tmpbuf 에 저장된 내용을 Base64decdata 에 보여준다
				Base64decdata.Text = encoding.GetString(Tmpbuf);
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
				data.Text="";
				Base64encdata.Text = "";
				Base64decdata.Text="";
				
				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	
	}
}
