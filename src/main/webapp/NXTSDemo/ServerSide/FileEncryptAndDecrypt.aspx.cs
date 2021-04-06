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
	/// FileEncryptAndDecrypt�� ���� ��� �����Դϴ�.
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
			//Encrypt File ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			encbtn.Attributes.Add("onclick", "return plainTextchk();");
			
			//Decrypt File ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			decbtn.Attributes.Add("onclick", "return Verifychk();");
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
				// ���� �̸� ��������
				string fn = System.IO.Path.GetFileName(encfile.PostedFile.FileName);
				
				// ���� ������ġ ����
				string SaveLocation = Server.MapPath("Data") + "\\" +  fn;
				try
				{

					// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
					string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
					// ȯ�� ���� ������ load �Ѵ�. 
					Config.loadConfig(cfg_file);

					System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
					
					// SaveLocation �� ��������
					encfile.PostedFile.SaveAs(SaveLocation);

					byte[] filedata;
					
					// SaveLocation �� ����� ���� ������ �о� filedata �� ����
					FileInfo f= new FileInfo(SaveLocation );
					FileStream fos = new FileStream(SaveLocation , FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					
					// filedata �� ����� ������ plaindata�� �����ش�
					plaindata.Text = KTNET.Util.Base64Encoding(filedata);

					// Encrypt ��ü ����
					KTNET.Encrypt enc = new KTNET.Encrypt();
					
					// ȯ�� ���� ���Ͽ� ����� ��ȣȭ �˰���� ��ȣȭ ��� ���� 
					enc.EncryptAlgorithm = Config.EncryptionAlgorithm;
					enc.ModeOfOperation = Config.EncryptionMode;
					
					// ��ĪŰ ����
					enc.GenerateSecretKey();
	
					// IV ����Ÿ�� ������
					byte[] IVData = enc.IVData;
					
					// IVData �� decript �� ����ϱ� ���� Ivkey hidden �ʵ��� ������ ���� 
					Page.ClientScript.RegisterHiddenField("Ivkey", KTNET.Util.Base64Encoding(IVData)); 
					
					// ��ĪŰ ����Ÿ�� keyPwd �� ����
					keyPwd.Text = KTNET.Util.Base64Encoding(enc.KeyData);
					
					// SaveLocation �� ����� ������ SaveLocation.enc ���Ϸ� ��ȣȭ
					enc.encryptFile(SaveLocation, SaveLocation + ".enc", true);

					// SaveLocation.enc ������ base64 ���ڵ� �� SaveLocation.b64enc ���Ϸ� ����.
					KTNET.Util.Base64EncodingFile(SaveLocation + ".enc", SaveLocation + ".b64enc" , true);
					
					// SaveLocation.b64enc �� ����� Encrypt �� ������ �о� filedata �� ����
					f= new FileInfo(SaveLocation + ".b64enc");
					fos = new FileStream(SaveLocation + ".b64enc", FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					//f.Delete();
					
					// filedata �� ����� ������ encdata �� �����ش�
					encdata.Text = KTNET.Util.Base64Encoding(filedata);
					encmsg.Text = "Encrypt �� ������ ������<BR>"+SaveLocation+".b64enc �� ����";

					//decfile.Text = SaveLocation + ".b64enc";

					
				}
				catch ( Exception ex )
				{
					Response.Write("Error: " + ex.Message);
				}
			}
			else
			{
				Response.Write("Encrypt �� ������ ������ �ּ���");
			}
		}
		private void decbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(cfg_file);

				// Encrypt ��ü ����
				KTNET.Encrypt enc = new KTNET.Encrypt();
			
				// keyPwd �ʵ忡 ������ ��ĪŰ�� hidden ������ ����� Ivkey ���� ������ ��ĪŰ�� IV ����Ÿ�� ����
				enc.KeyData = KTNET.Util.Base64Decoding(keyPwd.Text);
				enc.IVData = KTNET.Util.Base64Decoding(Request["Ivkey"]);
			
				// Encrypt �� ������ �о�� ���Ϸ� ������ ��� ���� 
				string SaveLocation = Server.MapPath("Data") + "\\signdata.sgn";  

				// Encrypt �� ������ �о�� Encdata �� ����
				byte[] Encdata = KTNET.Util.Base64Decoding(encdata.Text);
			
				// Encdata�� ����� ������ �о�� Savelocation�� �����Ѵ�.
				FileStream fos = new FileStream(SaveLocation, FileMode.Create, FileAccess.Write);
				fos.Write(Encdata, 0, Encdata.Length);
				fos.Close();
			
				// �� ���� ������ Base64 ���ڵ� �� SaveLocation.b64_dec �� �����Ѵ�.
				KTNET.Util.Base64DecodingFile(SaveLocation, SaveLocation + ".b64_dec", true);
			
				// SaveLocation.b64_dec ������ �о�� SaveLocation.dec ���Ϸ� �����Ѵ�.  
				enc.decryptFile(SaveLocation+ ".b64_dec", SaveLocation + ".dec", true);
			
				byte[] filedata;
			
				// SaveLocation.dec ���Ͽ� ����� ����Ÿ�� filedata �� �о�´� 
				FileInfo f= new FileInfo(SaveLocation + ".dec" );
				fos = new FileStream(SaveLocation + ".dec" , FileMode.Open, FileAccess.Read);
				filedata = new byte[f.Length];
				fos.Read(filedata, 0, (int)f.Length);
				fos.Close();
					
				// filedata  �� decdata �� �����Ѵ�
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
				// ������ �ʵ� ����Ÿ �ʱ�ȭ
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
