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
using KTNET;

namespace NetToolkitDemo.ServerSide
{
	/// <summary>
	/// CheckVID�� ���� ��� �����Դϴ�.
	/// </summary>
	public class CheckVID : System.Web.UI.Page
	{
		protected System.Web.UI.HtmlControls.HtmlInputFile certfile;
		protected System.Web.UI.WebControls.TextBox ssn;
		protected System.Web.UI.WebControls.Button Checkbtn;
		protected System.Web.UI.WebControls.Label checkMsg;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			// ���⿡ ����� �ڵ带 ��ġ�Ͽ� �������� �ʱ�ȭ�մϴ�.

			//Envelop �ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Checkbtn.Attributes.Add("onclick", "return signfilechk();");
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
			this.Checkbtn.Click += new System.EventHandler(this.Checkbtn_Click);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void Checkbtn_Click(object sender, System.EventArgs e)
		{

			try
			{
				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string cfg_file = ConfigurationManager.AppSettings["config_path"];
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(cfg_file);

				// ���������� �ſ�Ȯ��
				byte[] random = Util.getRandomFromKey(Config.getSignKey(0), Config.getSignPwd(0));
				X509Certificate cert = new X509Certificate(Config.getSignCert(0));

				//  �Ѿ�� ssn ��ȣ�� random ��ȣ�� �������� �ſ��� Ȯ���Ѵ�.
				bool ret = cert.verifyVID(ssn.Text, random);

				if (ret)
				{
					checkMsg.Text = "�ſ�Ȯ�� ����";
				}				
				else
				{
					checkMsg.Text = "�ſ�Ȯ�� ����";
				}
			}
			catch ( Exception ex )
			{
				Response.Write("Error: " + ex.Message);
			}

		}

	}
}
