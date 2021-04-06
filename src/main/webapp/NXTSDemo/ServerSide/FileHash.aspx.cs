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
	/// FileHash�� ���� ��� �����Դϴ�.
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
			// ���⿡ ����� �ڵ带 ��ġ�Ͽ� �������� �ʱ�ȭ�մϴ�.

			//Hash File �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			hashbtn.Attributes.Add("onclick", "return signfilechk();");
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
			this.hashbtn.Click += new System.EventHandler(this.hashbtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion
		
		private void hashbtn_Click(object sender, System.EventArgs e)
		{
			if( ( hashfile.PostedFile != null ) && ( hashfile.PostedFile.ContentLength > 0 ) )
			{
				// ���� �̸� ��������
				string fn = System.IO.Path.GetFileName(hashfile.PostedFile.FileName);
				
				// ���� ������ġ ����
				string SaveLocation = Server.MapPath("Data") + "\\" +  fn;
				try
				{
					System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
					
					// SaveLocation �� ��������
					hashfile.PostedFile.SaveAs(SaveLocation);
					
					// SaveLocation�� ����� file�� �о�� ������ Hash �˰��� ���̵�� hash �� �� SaveLocation.hash �� ���� 
					KTNET.Util.HashDataFile("SHA1", SaveLocation, SaveLocation + ".hash", true);
					
					hashmsg.Text = "Hash �� ������ ������<BR>"+SaveLocation+".hash �� ����";
					
					// SaveLocation.hash ������ base64 ���ڵ� �Ѵ�.
					KTNET.Util.Base64EncodingFile(SaveLocation + ".hash", SaveLocation + ".b64enc" , true);
					
					byte[] hashfiledata;
					
					// base64 ���ڵ� ���� ����� SaveLocation.b64enc ������ hashfiledata �� �о� ���δ�.
					FileInfo f= new FileInfo(SaveLocation + ".b64enc");
					FileStream fos = new FileStream(SaveLocation + ".b64enc", FileMode.Open, FileAccess.Read);
					hashfiledata = new byte[f.Length];
					fos.Read(hashfiledata, 0, (int)f.Length);
					fos.Close();
					f.Delete();
					
					// SaveLocation �� ����� ���� ����
					f = new FileInfo(SaveLocation );
					f.Delete();
					
					// SaveLocation.hash �� ����� ���� ����
					f = new FileInfo(SaveLocation + ".hash");
					f.Delete();
					
					// hashfiledata �� ����� ������ hashdata �� �����ش�
					hashdata.Text = encoding.GetString(hashfiledata);

				}
				catch ( Exception ex )
				{
					Response.Write("Error: " + ex.Message);
				}
			}
			else
			{
				Response.Write("Hash �� ������ ������ �ּ���");
			}
		}
		private void Resetbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				// ������ �ʵ� ����Ÿ �ʱ�ȭ
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
