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
	/// FileEnvelopAndEnvelopVerify�� ���� ��� �����Դϴ�.
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
			// ���⿡ ����� �ڵ带 ��ġ�Ͽ� �������� �ʱ�ȭ�մϴ�.

			//Envelop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			envbtn.Attributes.Add("onclick", "return signfilechk();");
			
			//Develop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			devbtn.Attributes.Add("onclick", "return Verifychk();");
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
				// ���� �̸� ��������
				string fn = System.IO.Path.GetFileName(envfile.PostedFile.FileName);
				
				// ���� ������ġ ����
				string SaveLocation = Server.MapPath("Data") + "\\" +  fn;
				try
				{
					System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
					
					// SaveLocation �� ��������
					envfile.PostedFile.SaveAs(SaveLocation);

					// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
					string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
					// ȯ�� ���� ������ load �Ѵ�. 
					Config.loadConfig(cfg_file);
					
					// EnvelopedData ��ü ����
					KTNET.EnvelopedData ed = new KTNET.EnvelopedData();
					
					// EnvelopedData �� ����� ��� ����
					string outfile = SaveLocation+".ber";
					
					// ȯ�� ���� ���Ͽ� ����� ���� ������ ����
					ed.PeerCert = Config.getKmCert(0);

					// SaveLocation �� ����� ������ �о�� ���ں��� ������ ������ outfile ��ο� ����
					ed.makeEnvelopDataFile(SaveLocation, outfile, true);

					envmsg.Text = "Envelop �� ������ <BR>"+outfile+" �� ����";

					byte[] filedata;
					
					// SaveLocation �� ����� ���� ������ �о� filedata �� ����
					FileInfo f= new FileInfo(SaveLocation );
					filedata = new byte[f.Length];
					using ( FileStream fos = new FileStream(SaveLocation , FileMode.Open, FileAccess.Read) )
					{
						fos.Read(filedata, 0, (int)f.Length);
					}

					// filedata �� ����� ������ plaindata�� �����ش�
					plaindata.Text = KTNET.Util.Base64Encoding(filedata);
					
					// Upload �� ������ �����. �����󿡼� ���ε带 Ȯ���ϰ� ������ ����
					f.Delete();

					// outfile �� ����� Enveloped �� ������ �о� filedata �� ����
					f= new FileInfo(outfile);
					filedata = new byte[f.Length];
					using ( FileStream fos = new FileStream(outfile, FileMode.Open, FileAccess.Read) )
					{
						fos.Read(filedata, 0, (int)f.Length);
					}

					// filedata �� ����� ������ envdata�� �����ش�
					envdata.Text = KTNET.Util.Base64Encoding(filedata);
					
					// envdata �� ������ �����. �����󿡼� ���� ������ Ȯ���ϰ� ������ ����
					f.Delete();
				}
				catch ( Exception ex )
				{
					Response.Write("Env Error: " + ex.Message);
				}
			}
			else
			{
				Response.Write("Envelop �� ������ ������ �ּ���");
			}
		}
		private void devbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(config_path);
			
				// Enveloped�� ������ �о�� ���Ϸ� ������ ��� ���� 
				string SaveLocation = Server.MapPath("Data") + "\\envdata.env";  

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// envdata �ʵ忡 ����� ������ �Ͼ�� Savelocation�� �����Ѵ�.
				byte[] Orgdata = KTNET.Util.Base64Decoding(envdata.Text);
				using ( FileStream fos = new FileStream(SaveLocation, FileMode.Create, FileAccess.Write) )
				{
					fos.Write(Orgdata, 0, Orgdata.Length);
				}
			
				// EnvelopedData ��ü ����
				KTNET.EnvelopedData ed = new KTNET.EnvelopedData();
			
				// ���ں������� ������ ���� ������, ����Ű, ����Ű ��ȣ�� ����
				ed.KmCert = Config.getKmCert(0);
				ed.KmKey = Config.getKmKey(0);
				ed.KmCertPwd = Config.getKmPwd(0);
			
				// SaveLocation �� ����� Enveloped ����Ÿ�� Develop �Ѵ�.
				ed.decryptEnvelopedDataFile(SaveLocation, SaveLocation + ".dev", true);
										
				byte[] conInsd = KTNET.Util.loadFile(SaveLocation + ".dev");
			
				// conInsd ������ verifydata �ʵ忡 �����ش�.
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
				// ������ �ʵ� ����Ÿ �ʱ�ȭ
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
