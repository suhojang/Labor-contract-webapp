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
	/// StringSignVerifyAndCertVerify�� ���� ��� �����Դϴ�.
	/// </summary>
	public class StringSignVerifyAndCertVerify : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox plainText;
		protected System.Web.UI.WebControls.Button Signbtn;
		protected System.Web.UI.WebControls.TextBox signdata;
		protected System.Web.UI.WebControls.Button Verifybtn;
		protected System.Web.UI.WebControls.TextBox Verifydata;

		protected System.Web.UI.WebControls.RequiredFieldValidator Requiredfieldvalidator1;
		protected System.Web.UI.WebControls.ValidationSummary Validationsummary1;

		static KTNET.SignedData sd;

		static byte[] sdData;	// ����� ����Ÿ

		private void Page_Load(object sender, System.EventArgs e)
		{
			// ���⿡ ����� �ڵ带 ��ġ�Ͽ� �������� �ʱ�ȭ�մϴ�.
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
			this.Signbtn.Click += new System.EventHandler(this.Signbtn_Click);
			this.Verifybtn.Click += new System.EventHandler(this.Verifybtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);
		}
		#endregion

		private void Signbtn_Click(object sender, System.EventArgs e)
		{
			// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
			string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
			// ȯ�� ���� ������ load �Ѵ�. 
			Config.loadConfig(cfg_file);

			System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

			sd = new KTNET.SignedData();
			
			sd.SignKey = Config.getSignKey(0);
			sd.SignCert = Config.getSignCert(0);
			
			// ������ ��й�ȣ ����
			sd.SignCertPwd = Config.getSignPwd(0);
			
			sdData = sd.makeSignData(encoding.GetBytes(plainText.Text));
		
			signdata.Text = KTNET.Util.Base64Encoding(sdData);		
		}
		private void Verifybtn_Click(object sender, System.EventArgs e)
		{
			// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
			string config_path = ConfigurationManager.AppSettings["config_path"];
				
			// ȯ�� ���� ������ load �Ѵ�. 
			Config.loadConfig(config_path);

			System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

			byte[] b64buf = KTNET.Util.Base64Decoding(signdata.Text);
			
			sd = new KTNET.SignedData();
			
			X509Certificate[] certs = sd.verify( b64buf );

			foreach ( X509Certificate c in certs)
			{	
				//������ ����
				c.validate();
			}

			byte[] conInsd = sd.ContentData;
			Verifydata.Text = encoding.GetString(conInsd);

		}
	}
}
