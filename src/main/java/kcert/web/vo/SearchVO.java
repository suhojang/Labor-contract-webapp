package kcert.web.vo;

import java.io.Serializable;

import org.apache.commons.lang.builder.ToStringBuilder;

public class SearchVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	/** 검색조건 */
    private String searchCondition = "";
    
    /** 검색조건2 */
    private String searchConditionState = "";
    
    /** 검색Keyword */
    private String searchKeyword = "";
    
    /** 검색사용여부 */
    private String searchUseYn = "";
    
    /** 현재페이지 */
    private int pageIndex = 1;
    
    /** 페이지갯수 */
    private int pageUnit = 10;
    
    /** 페이지사이즈 */
    private int pageSize = 10;

    /** firstIndex */
    private int firstIndex = 1;

    /** lastIndex */
    private int lastIndex = 1;

    /** recordCountPerPage */
    private int recordCountPerPage = 10;
    
    /** 시작일*/
    private String stDate = "";
    
    /** 종료일*/
    private String etDate = "";
    
    /** 모두 체크 */
    private String chkall = "";
    /** 모두 체크  YN hidden 값 넘겨주기 */
    private String chkallYN = "";

	public int getFirstIndex() {
		return firstIndex;
	}

	public void setFirstIndex(int firstIndex) {
		this.firstIndex = firstIndex;
	}

	public int getLastIndex() {
		return lastIndex;
	}

	public void setLastIndex(int lastIndex) {
		this.lastIndex = lastIndex;
	}

	public int getRecordCountPerPage() {
		return recordCountPerPage;
	}

	public void setRecordCountPerPage(int recordCountPerPage) {
		this.recordCountPerPage = recordCountPerPage;
	}

	public String getSearchCondition() {
        return searchCondition;
    }

    public void setSearchCondition(String searchCondition) {
        this.searchCondition = searchCondition;
    }

    public String getSearchKeyword() {
        return searchKeyword;
    }

    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }

    public String getSearchUseYn() {
        return searchUseYn;
    }

    public void setSearchUseYn(String searchUseYn) {
        this.searchUseYn = searchUseYn;
    }

    public int getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(int pageIndex) {
        this.pageIndex = pageIndex;
    }

    public int getPageUnit() {
        return pageUnit;
    }

    public void setPageUnit(int pageUnit) {
        this.pageUnit = pageUnit;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

	public String getStDate() {
		return stDate;
	}

	public void setStDate(String stDate) {
		this.stDate = stDate;
	}

	public String getEtDate() {
		return etDate;
	}

	public void setEtDate(String etDate) {
		this.etDate = etDate;
	}

	public String getChkall() {
		return chkall;
	}

	public void setChkall(String chkall) {
		this.chkall = chkall;
	}

	public String getChkallYN() {
		return chkallYN;
	}

	public void setChkallYN(String chkallYN) {
		this.chkallYN = chkallYN;
	}

	public String getSearchConditionState() {
		return searchConditionState;
	}

	public void setSearchConditionState(String searchConditionState) {
		this.searchConditionState = searchConditionState;
	}
}
