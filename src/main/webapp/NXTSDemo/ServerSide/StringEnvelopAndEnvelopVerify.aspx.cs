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
	/// StringEnvelopAndEnvelopVerify�� ���� ��� �����Դϴ�.
	/// </summary>
	public class StringEnvelopAndEnvelopVerify : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox plainText;
		protected System.Web.UI.WebControls.Button Envelopbtn;
		protected System.Web.UI.WebControls.TextBox Envelopdata;
		protected System.Web.UI.WebControls.Button Developbtn;
		protected System.Web.UI.WebControls.TextBox Developdata;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{
			// ���⿡ ����� �ڵ带 ��ġ�Ͽ� �������� �ʱ�ȭ�մϴ�.

			//Envelop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Envelopbtn.Attributes.Add("onclick", "return signfilechk();");
			
			//Develop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Developbtn.Attributes.Add("onclick", "return Verifychk();");
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
			this.Envelopbtn.Click += new System.EventHandler(this.Envelopbtn_Click);
			this.Developbtn.Click += new System.EventHandler(this.Developbtn_Click); 
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void Envelopbtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(config_path);
			
				// Enveloped ����Ÿ�� ������ ����
				byte[] envData;	
			
				// EnvelopedData ��ü ����
				KTNET.EnvelopedData ed = new KTNET.EnvelopedData();
			
				// ȯ�� ���� ���Ͽ� ����� ���� ������ ����
				ed.PeerCert = Config.getKmCert(0);

				// plainText �� �Էµ� ����Ÿ�� �о�� ���ں��� ����
				envData = ed.makeEnvelopData(encoding.GetBytes(plainText.Text));

				// ���� �� ���� ���� ������ Base64 ���ڵ��� Envelopdata �ʵ忡 ����				
				Envelopdata.Text = KTNET.Util.Base64Encoding(envData);
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	
		private void Developbtn_Click(object sender, System.EventArgs e)
		{
			
			try
			{
				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(config_path);
			
				byte[] devData;	// ����� ����Ÿ�� ������ ����
			
				// EnvelopedData ��ü ����
				KTNET.EnvelopedData ed = new KTNET.EnvelopedData();
			
				ed.PeerCert = Config.getKmCert(0);

				// ���ں��� ������ ���� ���� ������ ���� ������, ����Ű, ����Ű ��ȣ�� ����
				ed.KmCert = Config.getKmCert(0);
				ed.KmKey = Config.getKmKey(0);
				ed.KmCertPwd = Config.getKmPwd(0);
			
				// Envelopdata �ʵ忡 ������ ���ں��� ����Ÿ ������ Base64 ���ڵ� �� Tmpbuf �� ����
				byte[] Tmpbuf = KTNET.Util.Base64Decoding(Envelopdata.Text);
			
				// b64buf�� ����� ����Ÿ�� �����Ѵ�. �� ����Ÿ��  ed.OutData �� ����				
				devData = ed.decryptEnvelopedData(Tmpbuf);
			
				// devData ����Ÿ�� Developdata �� �����ش�.
				Developdata.Text = encoding.GetString(devData);
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
				plainText.Text="";
				Envelopdata.Text = "";
				Developdata.Text = "";
				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	}

}
