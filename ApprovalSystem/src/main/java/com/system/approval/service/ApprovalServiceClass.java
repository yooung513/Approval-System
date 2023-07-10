package com.system.approval.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.system.approval.dao.ApprovalDaoInter;
import com.system.approval.domain.DocumentVO;
import com.system.approval.domain.HistoryVO;
import com.system.approval.domain.UserVO;

@Service("service")
public class ApprovalServiceClass implements ApprovalServiceInter{
	
	@Inject
	private ApprovalDaoInter dao;

	@Override
	public int idCheck(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return dao.idCheck(map);
	}
	
	@Override
	public int login(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return dao.login(map);
	}

	@Override
	public UserVO user(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return dao.user(map);
	}

	@Override
	public int findNextSeq() {
		// TODO Auto-generated method stub
		return dao.findNextSeq();
	}

	@Override
	public UserVO userByUserCode(Integer userCode) {
		// TODO Auto-generated method stub
		return dao.userByUserCode(userCode);
	}

	@Override
	public int checkDoc(int findSeq) {
		// TODO Auto-generated method stub
		return dao.checkDoc(findSeq);
	}

	@Override
	public void insertDoc(Map<String, Object> map) {
		// TODO Auto-generated method stub
		dao.insertDoc(map);
	}

	@Override
	public void insertHis(Map<String, Object> map) {
		// TODO Auto-generated method stub
		dao.insertHis(map);
	}

	@Override
	public List<HistoryVO> findHis(Integer docSeq) {
		// TODO Auto-generated method stub
		return dao.findHis(docSeq);
	}

	@Override
	public DocumentVO findDoc(int docSeq) {
		// TODO Auto-generated method stub
		return dao.findDoc(docSeq);
	}

	@Override
	public void updateDoc(Map<String, Object> updcon) {
		// TODO Auto-generated method stub
		dao.updateDoc(updcon);
		
	}

	@Override
	public List<DocumentVO> findByCon(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return dao.findByCon(map);
	}

	@Override
	public void updTmp(Map<String, Object> updcon) {
		// TODO Auto-generated method stub
		dao.updTmp(updcon);
	}

	@Override
	public Integer findWriter(Integer seq) {
		// TODO Auto-generated method stub
		return dao.findWriter(seq);
	}

	@Override
	public List<UserVO> findSub(int userCode) {
		// TODO Auto-generated method stub
		return dao.findSub(userCode);
	}

	@Override
	public void inserSub(Map<String, Object> map) {
		// TODO Auto-generated method stuba
		dao.insertSub(map);
	}

	@Override
	public UserVO chkSub(int userCode) {
		// TODO Auto-generated method stub
		return dao.chkSub(userCode);
	}

	@Override
	public List<DocumentVO> findMyDoc(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return dao.findMyDoc(map);
	}

}
