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
	/// StringHash에 대한 요약 설명입니다.
	/// </summary>
	public class StringHash : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox data;
		protected System.Web.UI.WebControls.Button Hashbtn;
		protected System.Web.UI.WebControls.TextBox hashdata;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			//Envelop 하기 버튼을 눌렀을때 자바 스크립트로 내용 체크
			Hashbtn.Attributes.Add("onclick", "return signfilechk();");
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
			this.Hashbtn.Click += new System.EventHandler(this.Hashbtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void Hashbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// data 필드에 입력된 값을 읽어와 설정된 Hash 알고리즘 아이디로 hash 한다.  
				byte[] HashText = KTNET.Util.HashData("SHA1", encoding.GetBytes(data.Text));
			
				// hash 한 데이타를 Base64 인코딩후 hashdata 에 보여준다.
				hashdata.Text = KTNET.Util.Base64Encoding(HashText);
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
				data.Text="";
				hashdata.Text = "";
				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	}
}
