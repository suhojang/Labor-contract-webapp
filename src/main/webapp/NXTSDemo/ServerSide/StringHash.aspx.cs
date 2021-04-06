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
	/// StringHash�� ���� ��� �����Դϴ�.
	/// </summary>
	public class StringHash : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox data;
		protected System.Web.UI.WebControls.Button Hashbtn;
		protected System.Web.UI.WebControls.TextBox hashdata;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			//Envelop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Hashbtn.Attributes.Add("onclick", "return signfilechk();");
		}

		#region Web Form �����̳ʿ��� ������ �ڵ�
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: �� ȣ���� ASP.NET Web Form �����̳ʿ� �ʿ��մϴ�.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// �����̳� ������ �ʿ��� �޼����Դϴ�.
		/// �� �޼����� ������ �ڵ� ������� �������� ���ʽÿ�.
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
			
				// data �ʵ忡 �Էµ� ���� �о�� ������ Hash �˰��� ���̵�� hash �Ѵ�.  
				byte[] HashText = KTNET.Util.HashData("SHA1", encoding.GetBytes(data.Text));
			
				// hash �� ����Ÿ�� Base64 ���ڵ��� hashdata �� �����ش�.
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
				// ������ �ʵ� ����Ÿ �ʱ�ȭ
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
