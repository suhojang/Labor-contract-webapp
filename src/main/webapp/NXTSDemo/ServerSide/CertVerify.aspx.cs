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
	/// CertVerify�� ���� ��� �����Դϴ�.
	/// </summary>
	public class CertVerify : System.Web.UI.Page
	{
		protected System.Web.UI.HtmlControls.HtmlInputFile veryfifile;
		protected System.Web.UI.WebControls.Label cert;
		protected System.Web.UI.WebControls.Label verifymsg;
		protected System.Web.UI.WebControls.Button verifybtn;
		protected System.Web.UI.WebControls.Label SubjectDN;
		protected System.Web.UI.WebControls.Label SerialNumber;
		protected System.Web.UI.WebControls.Label CertPolicy;
		protected System.Web.UI.WebControls.Label IssuerDN;
		protected System.Web.UI.WebControls.Label ValidityBefore;
		protected System.Web.UI.WebControls.Label ValidityAfter;

		private void Page_Load(object sender, System.EventArgs e)
		{
			//������ ���� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			verifybtn.Attributes.Add("onclick", "return signfilechk();");
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
			this.verifybtn.Click += new System.EventHandler(this.verifybtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void verifybtn_Click(object sender, System.EventArgs e)
		{
			
			if( ( veryfifile.PostedFile != null ) && ( veryfifile.PostedFile.ContentLength > 0 ) )
			{
				try
				{
					// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
					string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
					// ȯ�� ���� ������ load �Ѵ�. 
					Config.loadConfig(cfg_file);

					// ���ε� �� ���� ũ�� ���ϱ�
					int len = veryfifile.PostedFile.ContentLength;

					// ���ε� �� ���� ũ�⸸ŭ filedata �Ҵ�
					byte[] filedata = new byte[len];
					
					// filedata �� �о���δ�
					veryfifile.PostedFile.InputStream.Read (filedata, 0, len);

					// SaveLocation �� ����� ������ ������ ������ X509Certificate ��ü c �� ����
					X509Certificate c = new X509Certificate(filedata);		
			
					// �������� �����Ѵ�.
					c.validate();

					// ������ DN �� SubjectDN �� ����
					SubjectDN.Text = "DN : " + c.SubjectDN;
					
					// ������ Serial �� SerialNumber �� ����
					SerialNumber.Text = "Serial : " + c.SerialNumber;
					
					// ������ ��������å CertPolicy �� ����
					CertPolicy.Text = "��������å : " + c.CertPolicy;
					
					// ������ �߱��� DN IssuerDN �� ����
					IssuerDN.Text = "�߱��� DN: " + c.IssuerDN;
					
					// ������ ��ȿ�Ⱓ ���� ValidityBefore �� ����
					ValidityBefore.Text = "��ȿ�Ⱓ ����: " + c.ValidityBefore;
					
					// ������ ��ȿ�Ⱓ �� ValidityAfter �� ����
					ValidityAfter.Text = "��ȿ�Ⱓ ��: " + c.ValidityAfter;
				}
				catch ( Exception ex )
				{
					Response.Write("Error: " + ex.Message);
				}
				
			}
			else
			{
				Response.Write("������ ������ ������ �ּ���");
			}
		}
	}
}
