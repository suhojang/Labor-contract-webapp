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
	/// FileBase64�� ���� ��� �����Դϴ�.
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
			//Base64 Encode File �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			base64btn.Attributes.Add("onclick", "return signfilechk();");
			
			//Base64 Decode File �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			base64decbtn.Attributes.Add("onclick", "return Verifychk();");
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
				// ���� �̸� ��������
				string fn = System.IO.Path.GetFileName(base64file.PostedFile.FileName);

				// ���� ������ġ ����
				string SaveLocation = Server.MapPath("Data") + "\\" +  fn;
				try
				{
					System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
					
					// SaveLocation �� ��������
					base64file.PostedFile.SaveAs(SaveLocation);

					byte[] filedata;
					
					// SaveLocation �� ����� ���� ������ �о� filedata �� ����
					FileInfo f= new FileInfo(SaveLocation );
					FileStream fos = new FileStream(SaveLocation , FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					
					// filedata �� ����� ������ plaindata�� �����ش�
					plaindata.Text = KTNET.Util.Base64Encoding(filedata);

					// SaveLocation �� ����� ������ base64 ���ڵ� �� SaveLocation.b64 �� ����
					KTNET.Util.Base64EncodingFile(SaveLocation , SaveLocation + ".b64" , true);
					
					base64msg.Text = "Base64Encoding �� ������ ������<BR>"+SaveLocation+".b64 �� ����";
					
					// SaveLocation.b64 �� ����� base64 ���ڵ� �� ������ �о� filedata �� ����
					f= new FileInfo(SaveLocation + ".b64");
					fos = new FileStream(SaveLocation + ".b64", FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					f.Delete();
					
					// filedata�� �о�� base64 ���ڵ� �� b64data �� �����ش�.
					b64data.Text = KTNET.Util.Base64Encoding(filedata);
					
					// SaveLocation �� ����� ���� ����
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
				Response.Write("Base64 Encoding �� ������ ������ �ּ���");
			}
			
		}
		private void base64decbtn_Click(object sender, System.EventArgs e)
		{
			try
			{	
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// base64 ���ڵ� �� ������ �о�� ���Ϸ� ������ ��� ���� 
				string SaveLocation = Server.MapPath("Data") + "\\base64data.b64";   
			
				// b64data �� ����Ǿ� �ִ� ����Ÿ�� �о�� base64 ���ڵ� �� base64data �� ����
				byte[] base64data = KTNET.Util.Base64Decoding(b64data.Text);
			
				// base64data �� ������ SaveLocation ���Ϸ� ����
				FileStream fos = new FileStream(SaveLocation, FileMode.Create, FileAccess.Write);
				fos.Write(base64data, 0, base64data.Length);
				fos.Close();


				// SaveLocation �� ����Ǿ��ִ� ������ �о� base64 Decoding �� SaveLocation.org ���Ϸ� ����
				KTNET.Util.Base64DecodingFile(SaveLocation , SaveLocation + ".org" , true);
		
				byte[] filedata;
			
				// SaveLocation.org ���Ͽ� ����� ����Ÿ�� filedata �� �о�´� 
				FileInfo f= new FileInfo(SaveLocation + ".org" );
				fos = new FileStream(SaveLocation + ".org" , FileMode.Open, FileAccess.Read);
				filedata = new byte[f.Length];
				fos.Read(filedata, 0, (int)f.Length);
				fos.Close();
			
				// filedata  �� base64decdata �� �����Ѵ�
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
				// ������ �ʵ� ����Ÿ �ʱ�ȭ
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
