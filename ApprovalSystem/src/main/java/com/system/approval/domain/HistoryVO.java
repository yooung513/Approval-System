package com.system.approval.domain;

import java.sql.Date;

public class HistoryVO {
	
	private int hisSeq;
	private Date appDate;
	private String approver;
	private String stateName;
	private String subName;
	
	public String getSubName() {
		return subName;
	}
	public void setSubName(String subName) {
		this.subName = subName;
	}
	public int getHisSeq() {
		return hisSeq;
	}
	public void setHisSeq(int hisSeq) {
		this.hisSeq = hisSeq;
	}
	public Date getAppDate() {
		return appDate;
	}
	public void setAppDate(Date appDate) {
		this.appDate = appDate;
	}
	public String getApprover() {
		return approver;
	}
	public void setApprover(String approver) {
		this.approver = approver;
	}
	public String getStateName() {
		return stateName;
	}
	public void setStateName(String stateName) {
		this.stateName = stateName;
	}
	
}
