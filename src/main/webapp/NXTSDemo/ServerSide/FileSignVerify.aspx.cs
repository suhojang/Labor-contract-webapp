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
	/// FileSignVerify�� ���� ��� �����Դϴ�.
	/// </summary>
	public class FileSignVerify : System.Web.UI.Page
	{	
		protected System.Web.UI.HtmlControls.HtmlInputFile signfile;
		protected System.Web.UI.WebControls.Button Signbtn;
		protected System.Web.UI.WebControls.Label signmsg;
		protected System.Web.UI.WebControls.TextBox plaindata;
		protected System.Web.UI.WebControls.TextBox signdata;
		protected System.Web.UI.WebControls.Button Verifybtn;
		protected System.Web.UI.WebControls.TextBox verifydata;
		protected System.Web.UI.WebControls.Label SubjectDN;
		protected System.Web.UI.WebControls.Label SerialNumber;
		protected System.Web.UI.WebControls.Label CertPolicy;
		protected System.Web.UI.WebControls.Label IssuerDN;
		protected System.Web.UI.WebControls.Label ValidityBefore;
		protected System.Web.UI.WebControls.Label ValidityAfter;
		protected System.Web.UI.WebControls.Button Resetbtn;

		private void Page_Load(object sender, System.EventArgs e)
		{

			//�����ϱ� ��ư�� �������� �ڹ� ��ũ��Ʈ�� ���� üũ
			Signbtn.Attributes.Add("onclick", "return signfilechk();");
			
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
			if( ( signfile.PostedFile != null ) && ( signfile.PostedFile.ContentLength > 0 ) )
			{
				// ���� �̸� ��������
				string fn = System.IO.Path.GetFileName(signfile.PostedFile.FileName);
				
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
					signfile.PostedFile.SaveAs(SaveLocation);
					
					// SignedData ��ü ����
					KTNET.SignedData sd = new KTNET.SignedData();
					
					// ȯ�� ���� ���Ͽ� ����� ������ ���� �ε�
					sd.SignCert = Config.getSignCert(0);

					// ȯ�� ���� ���Ͽ� ����� ������Ű �ε�
					sd.SignKey = Config.getSignKey(0);
			
					// ������ ��й�ȣ �ε�
					sd.SignCertPwd = Config.getSignPwd(0);

					// ������ ������  SaveLocation + ".sign" �� ����
					sd.makeSignDataFile(SaveLocation, SaveLocation + ".sign" , true);

					signmsg.Text = "���� �� ������ ������<BR>"+SaveLocation+".sign �� ����";
					
					byte[] filedata;
					
					// SaveLocation �� ����� ���� ������ �о� filedata �� ����
					FileInfo f= new FileInfo(SaveLocation );
					FileStream fos = new FileStream(SaveLocation , FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					
					// filedata �� ����� ������ plaindata�� �����ش�
					plaindata.Text = KTNET.Util.Base64Encoding(filedata);
					
					// Upload �� ������ �����. �����󿡼� ���ε带 Ȯ���ϰ� ������ �Ʒ� ����
					f.Delete();
					
					// SaveLocation �� ����� Singed �� ���� �� �о� filedata �� ����
					f= new FileInfo(SaveLocation + ".sign");
					fos = new FileStream(SaveLocation + ".sign", FileMode.Open, FileAccess.Read);
					filedata = new byte[f.Length];
					fos.Read(filedata, 0, (int)f.Length);
					fos.Close();
					
					// filedata �� ����� ������ signdata�� �����ش�
					signdata.Text = KTNET.Util.Base64Encoding(filedata);
					
					// singned �� ������ �����. �����󿡼� ���� ������ Ȯ���ϰ� ������ ����
					f.Delete();

					// Config.SignCert �� ����� ������ ������ ������ X509Certificate ��ü c �� ����
					X509Certificate c = new X509Certificate(Config.getSignCert(0));		
			
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
				Response.Write("���� �� ������ ������ �ּ���");
			}
			
		}

		private void Verifybtn_Click(object sender, System.EventArgs e)
		{
			try
			{	
				// Web.config ���Ͽ��� ȯ�� ���� ���� ��� �� config_path �� �о�´� 
				string config_path = ConfigurationManager.AppSettings["config_path"];
				
				// ȯ�� ���� ������ load �Ѵ�. 
				Config.loadConfig(config_path);
			
				// ����� ������ ������ ��� ���� 
				string SaveLocation = Server.MapPath("Data") + "\\signdata.sgn";   

				System.Text.UTF8Encoding  encoding=new System.Text.UTF8Encoding();
			
				// signdata �ʵ忡 ������ ������ �о�� Signdata�� ����
				byte[] Signdata = KTNET.Util.Base64Decoding(signdata.Text);
			
				// Signdata ������ ������ ������ SaveLocation �� �����Ѵ�.
				FileStream fos = new FileStream(SaveLocation, FileMode.Create, FileAccess.Write);
				fos.Write(Signdata, 0, Signdata.Length);
				fos.Close();
			
				// SignedData ��ü ����
				KTNET.SignedData sd = new KTNET.SignedData();
			
				// SaveLocation �� ����� ���� ���� ����
				X509Certificate[] certs = sd.verifyFile(SaveLocation);
			
				// SaveLocation �� ����� ���� ����
				FileInfo file = new FileInfo(SaveLocation);
				file.Delete();

				//������ ����
				foreach ( X509Certificate c in certs)
				{
					//������ ����
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
			
				// ������ ���� ����Ÿ sd.ContentData �� conInsd �� ����
				byte[] conInsd = sd.ContentData;

				// conInsd ������ SaveLocation+".org" ���Ϸ� ����
				fos = new FileStream(SaveLocation+".org", FileMode.Create, FileAccess.Write);
				fos.Write(conInsd, 0, conInsd.Length);
				fos.Close();
			
				// SaveLocation+".org"  �� ����� ������ �����Ѵ�. ������ Ȯ���ϱ����ؼ��� �Ʒ� ����
				FileInfo f= new FileInfo(SaveLocation+".org" );
				f.Delete();
			
				// conInsd ������ verifydata �ʵ忡 �����ش�.
				verifydata.Text = KTNET.Util.Base64Encoding(conInsd);
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
				signmsg.Text = "";
				plaindata.Text = "";
				signdata.Text = "";
				verifydata.Text = "";SubjectDN.Text = "";
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
