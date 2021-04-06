package kcert.web.vo;

import java.io.Serializable;

public class ClientVO implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private String NO;
	private String ID;
	private String PWD;
	private String NM;
	private String HP;
	private String EML;
	private String BSNM;
	private String ADDR;
	private String TEL;
	private String DELYN;
	private String ANDID;
	private String TKNID;
	private String GCMID;
	private String RDT;
	private String UDT;
	
	public String getNO() {
		return NO;
	}
	public void setNO(String nO) {
		NO = nO;
	}
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public String getPWD() {
		return PWD;
	}
	public void setPWD(String pWD) {
		PWD = pWD;
	}
	public String getNM() {
		return NM;
	}
	public void setNM(String nM) {
		NM = nM;
	}
	public String getHP() {
		return HP;
	}
	public void setHP(String hP) {
		HP = hP;
	}
	public String getEML() {
		return EML;
	}
	public void setEML(String eML) {
		EML = eML;
	}
	public String getBSNM() {
		return BSNM;
	}
	public void setBSNM(String bSNM) {
		BSNM = bSNM;
	}
	public String getADDR() {
		return ADDR;
	}
	public void setADDR(String aDDR) {
		ADDR = aDDR;
	}
	public String getDELYN() {
		return DELYN;
	}
	public void setDELYN(String dELYN) {
		DELYN = dELYN;
	}
	public String getANDID() {
		return ANDID;
	}
	public void setANDID(String aNDID) {
		ANDID = aNDID;
	}
	public String getTKNID() {
		return TKNID;
	}
	public void setTKNID(String tKNID) {
		TKNID = tKNID;
	}
	public String getGCMID() {
		return GCMID;
	}
	public void setGCMID(String gCMID) {
		GCMID = gCMID;
	}
	public String getRDT() {
		return RDT;
	}
	public void setRDT(String rDT) {
		RDT = rDT;
	}
	public String getUDT() {
		return UDT;
	}
	public void setUDT(String uDT) {
		UDT = uDT;
	}
	public String getTEL() {
		return TEL;
	}
	public void setTEL(String tEL) {
		TEL = tEL;
	}
}
