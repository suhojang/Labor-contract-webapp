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
using System.Configuration;
using System.IO;
using KTNET;


namespace NetToolkitDemo.ServerSide
{
	/// <summary>
	/// StringEncryptAndDecrypt�� ���� ��� �����Դϴ�.
	/// </summary>
	public class StringEncryptAndDecrypt : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox keyPwd;
		protected System.Web.UI.WebControls.TextBox plainText;
		protected System.Web.UI.WebControls.Button Encryptbtn;
		protected System.Web.UI.WebControls.Label lblMsg;
		protected System.Web.UI.WebControls.Label Ivkey1;
		protected System.Web.UI.WebControls.TextBox encdata;
		protected System.Web.UI.WebControls.Button Decryptbtn;
		protected System.Web.UI.WebControls.TextBox decdata;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			// ���⿡ ����� �ڵ带 ��ġ�Ͽ� �������� �ʱ�ȭ�մϴ�.

			//Envelop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Encryptbtn.Attributes.Add("onclick", "return signfilechk();");
			
			//Develop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Decryptbtn.Attributes.Add("onclick", "return Verifychk();");
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
			this.Encryptbtn.Click += new System.EventHandler(this.Encryptbtn_Click);
			this.Decryptbtn.Click += new System.EventHandler(this.Decryptbtn_Click);
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void Encryptbtn_Click(object sender, System.EventArgs e)
		{
			try
			{	
				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(config_path);
				
				// Encrypt ��ü ����
				Encrypt enc = new Encrypt();
				
				// ȯ�� ���� ���Ͽ� ����� ��ȣȭ �˰���� ��ȣȭ ��� ���� 
				enc.EncryptAlgorithm = Config.EncryptionAlgorithm;
				enc.ModeOfOperation = Config.EncryptionMode;

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
				
				// ��ĪŰ ����
				enc.GenerateSecretKey();

				lblMsg.Text = "Encrypt �˰��� ���̵� : " + enc.EncryptAlgorithm.ToString();
				
				// ��ĪŰ�� IV ����Ÿ�� ������
				byte[] keyData = enc.KeyData;
				byte[] IVData = enc.IVData;
				
				// IVData �� decript �� ����ϱ� ���� Ivkey hidden �ʵ��� ������ ���� 
				Page.ClientScript.RegisterHiddenField("Ivkey", KTNET.Util.Base64Encoding(IVData)); 
				
				// ��ĪŰ ����Ÿ�� keyPwd �� ����
				keyPwd.Text = KTNET.Util.Base64Encoding(enc.KeyData);
				
				// plainText �� �Էµ� ����Ÿ�� ��ȣȭ				
				byte[] encbuf = enc.encryptData( encoding.GetBytes(plainText.Text));

				// encbuf �� ����� ��ȣȭ ����Ÿ�� encdata �ʵ忡 ���� 
				encdata.Text = KTNET.Util.Base64Encoding(encbuf);

				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}
		}

		private void Decryptbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
				
				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(config_path);

				// Encrypt ��ü ����
				Encrypt enc = new Encrypt();
				
				// ȯ�� ���� ���Ͽ� ����� ��ȣȭ �˰���� ��ȣȭ ��� ���� 
				enc.EncryptAlgorithm = Config.EncryptionAlgorithm;
				enc.ModeOfOperation = Config.EncryptionMode;
				
				// keyPwd �ʵ忡 ������ ��ĪŰ�� hidden ������ ����� Ivkey ���� ������ ��ĪŰ�� IV ����Ÿ�� ����
				enc.KeyData = KTNET.Util.Base64Decoding(keyPwd.Text);
				enc.IVData = KTNET.Util.Base64Decoding(Request["Ivkey"]);
				
				// IVData �� decript �� ����ϱ� ���� Ivkey hidden �ʵ��� ������ ���� 
				Page.ClientScript.RegisterHiddenField("Ivkey", Request["Ivkey"]); 
				
				// Encrypt �� ����Ÿ�� Base64 ���ڵ��� Tmpdata �� ����
				byte[] Tmpdata = KTNET.Util.Base64Decoding(encdata.Text);
				
				// Tmpdata �� Decrypt �Ѵ�				
				byte[] orgData = enc.decryptData( Tmpdata);
				
				//Decrypt �� ����Ÿ�� decdata �ʵ忡 �����ش�
				decdata.Text = encoding.GetString(orgData);
				
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
				keyPwd.Text="";
				plainText.Text = "";
				lblMsg.Text = "";
				encdata.Text = "";
				decdata.Text = "";
						
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}

	}
}
