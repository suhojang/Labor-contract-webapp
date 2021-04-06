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
	/// StringSignVerify�� ���� ��� �����Դϴ�.
	/// </summary>
	public class StringSignVerify : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.TextBox plainText;
		protected System.Web.UI.WebControls.Button Signbtn;
		protected System.Web.UI.WebControls.TextBox signdata;
		protected System.Web.UI.WebControls.Button Verifybtn;
		protected System.Web.UI.WebControls.TextBox Verifydata;
		protected System.Web.UI.WebControls.Label SubjectDN;
		protected System.Web.UI.WebControls.Label SerialNumber;
		protected System.Web.UI.WebControls.Label CertPolicy;
		protected System.Web.UI.WebControls.Label IssuerDN;
		protected System.Web.UI.WebControls.Label ValidityBefore;
		protected System.Web.UI.WebControls.Label ValidityAfter;
		protected System.Web.UI.WebControls.Button Resetbtn;
		protected System.Web.UI.WebControls.DropDownList ListBox1;

		private void Page_Load(object sender, System.EventArgs e)
		{
			// ���⿡ ����� �ڵ带 ��ġ�Ͽ� �������� �ʱ�ȭ�մϴ�.
			
			//�����ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Signbtn.Attributes.Add("onclick", "return plainTextchk();");
			
			//�����ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Verifybtn.Attributes.Add("onclick", "return Verifychk();");
			

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
			this.Resetbtn.Click += new System.EventHandler(this.Resetbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void Signbtn_Click(object sender, System.EventArgs e)
		{
			try
			{

				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string cfg_file = ConfigurationManager.AppSettings["config_path"];

				//Response.Write(verifycnd.SelectedValue
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(cfg_file);

				byte[] sdData;	// ����� ����Ÿ�� ���� ����

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();

				KTNET.SignedData sd = new KTNET.SignedData();
			
				// ȯ�� ���� ���Ͽ� ����� ������ ���� �ε�
				sd.SignCert = Config.getSignCert(0);

				// ȯ�� ���� ���Ͽ� ����� ������Ű �ε�
				sd.SignKey = Config.getSignKey(0);
			
				// ������ ��й�ȣ ����
				sd.SignCertPwd = Config.getSignPwd(0);

				// plainText �ʵ忡 �Էµ� ����� ����Ÿ�� Singed data �� �����				
				sdData = sd.makeSignData(encoding.GetBytes(plainText.Text));
			
				// Base64 ���ڵ��� ȭ�鿡 ���
				signdata.Text = KTNET.Util.Base64Encoding(sdData);				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
		private void Verifybtn_Click(object sender, System.EventArgs e)
		{
			try
			{
				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(cfg_file);

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// SignedData ��ü ����
				KTNET.SignedData sd = new KTNET.SignedData();

				// ȯ�� ���� ���Ͽ� ����� ������Ű �ε�
				sd.SignKey = Config.getSignKey(0);
				sd.SignCertPwd = Config.getSignPwd(0);

				// signdata �ʵ忡 ����� ������ Base64 ���ڵ��� ����
				byte[] sdData = KTNET.Util.Base64Decoding(signdata.Text);

				sd.verify( sdData );

				bool cert_verify = ListBox1.Items[1].Selected;
		
				// ����� ����Ÿ ����
				X509Certificate[] certs = sd.verify( sdData );
		
				//������ ���� �� ���� ���
				SubjectDN.Text = SerialNumber.Text = CertPolicy.Text = IssuerDN.Text = ValidityBefore.Text = ValidityAfter.Text = "";

				foreach ( X509Certificate c in certs)
				{	
					//������ ����
					if (cert_verify)
						c.validate();
			
					// ������ DN �� SubjectDN �� ����
					SubjectDN.Text += "<br>DN : " + c.SubjectDN;
				
					// ������ Serial �� SerialNumber �� ����
					SerialNumber.Text += "<br>Serial : " + c.SerialNumber;
				
					// ������ ��������å CertPolicy �� ����
					CertPolicy.Text += "<br>��������å : " + c.CertPolicy;
				
					// ������ �߱��� DN IssuerDN �� ����
					IssuerDN.Text += "<br>�߱��� DN: " + c.IssuerDN;
				
					// ������ ��ȿ�Ⱓ ���� ValidityBefore �� ����
					ValidityBefore.Text += "<br>��ȿ�Ⱓ ����: " + c.ValidityBefore;
				
					// ������ ��ȿ�Ⱓ �� ValidityAfter �� ����
					ValidityAfter.Text += "<br>��ȿ�Ⱓ ��: " + c.ValidityAfter;
				}
				
				// ����� ���� ����Ÿ�� ������ Verifydata �ʵ忡 ����
				byte[] conInsd = sd.ContentData;
				Verifydata.Text = encoding.GetString(conInsd);

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
				signdata.Text = "";
				Verifydata.Text = "";
				SubjectDN.Text = "";
				SerialNumber.Text = "";
				CertPolicy.Text = "";
				IssuerDN.Text = "";
				ValidityBefore.Text = "";
				ValidityAfter.Text = "";

				
			}
			catch(Exception ex)
			{
				Response.Write(ex.Message);
			}

		}
	}
}
