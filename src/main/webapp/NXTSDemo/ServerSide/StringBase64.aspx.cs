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
	/// StringBase64�� ���� ��� �����Դϴ�.
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
			//Envelop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Base64encbtn.Attributes.Add("onclick", "return signfilechk();");
			
			//Develop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Base64decbtn.Attributes.Add("onclick", "return Verifychk();");
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
			
				// data �ʵ忡 �Էµ� ����Ÿ�� ������ Base64 ���ڵ��� Base64encdata �� ����
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
			
				// Base64encdata �ʵ忡 ����� Base64 ���ڵ� ����Ÿ�� ������ Base64 ���ڵ��� Tmpbuf �� ����
				byte[] Tmpbuf = KTNET.Util.Base64Decoding(Base64encdata.Text);
			
				// Tmpbuf �� ����� ������ Base64decdata �� �����ش�
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
				// ������ �ʵ� ����Ÿ �ʱ�ȭ
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
