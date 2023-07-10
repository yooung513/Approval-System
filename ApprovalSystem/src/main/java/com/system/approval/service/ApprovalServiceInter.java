package com.system.approval.service;

import java.util.List;
import java.util.Map;

import com.system.approval.domain.DocumentVO;
import com.system.approval.domain.HistoryVO;
import com.system.approval.domain.UserVO;

public interface ApprovalServiceInter {
	
	int idCheck(Map<String, Object> map);

	int login(Map<String, Object> map);

	UserVO user(Map<String, Object> map);

	int findNextSeq();

	UserVO userByUserCode(Integer userCode);

	int checkDoc(int findSeq);

	void insertDoc(Map<String, Object> map);

	void insertHis(Map<String, Object> map);

	List<HistoryVO> findHis(Integer docSeq);

	DocumentVO findDoc(int docSeq);

	void updateDoc(Map<String, Object> updcon);

	List<DocumentVO> findByCon(Map<String, Object> map);

	void updTmp(Map<String, Object> updcon);

	Integer findWriter(Integer seq);

	List<UserVO> findSub(int userCode);

	void inserSub(Map<String, Object> map);

	UserVO chkSub(int userCode);

	List<DocumentVO> findMyDoc(Map<String, Object> map);

}
