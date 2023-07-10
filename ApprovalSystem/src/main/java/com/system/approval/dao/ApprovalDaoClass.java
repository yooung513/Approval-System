package com.system.approval.dao;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.system.approval.domain.DocumentVO;
import com.system.approval.domain.HistoryVO;
import com.system.approval.domain.UserVO;

@Repository("dao")
public class ApprovalDaoClass implements ApprovalDaoInter{
	
	@Inject
	public SqlSessionTemplate sqlSession;

	@Override
	public int idCheck(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.idCheck", map);
	}
	
	@Override
	public int login(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.login", map);
	}

	@Override
	public UserVO user(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.user", map);
	}

	@Override
	public int findNextSeq() {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.findNextSeq");
	}

	@Override
	public UserVO userByUserCode(Integer userCode) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.userByUserCode", userCode);
	}

	@Override
	public int checkDoc(int findSeq) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.checkDoc", findSeq);
	}

	@Override
	public void insertDoc(Map<String, Object> map) {
		// TODO Auto-generated method stub
		sqlSession.insert("mapper.insertDoc", map);
		
	}

	@Override
	public void insertHis(Map<String, Object> map) {
		// TODO Auto-generated method stub
		sqlSession.insert("mapper.insertHis", map);
	}

	@Override
	public List<HistoryVO> findHis(Integer docSeq) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("mapper.findHis", docSeq);
	}

	@Override
	public DocumentVO findDoc(int docSeq) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.findDoc", docSeq);
	}

	@Override
	public void updateDoc(Map<String, Object> updcon) {
		// TODO Auto-generated method stub
		sqlSession.update("mapper.updateDoc", updcon);
	}

	@Override
	public List<DocumentVO> findByCon(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("mapper.findByCon", map);
	}

	@Override
	public void updTmp(Map<String, Object> updcon) {
		// TODO Auto-generated method stub
		sqlSession.update("mapper.updTmp", updcon);
	}

	@Override
	public Integer findWriter(Integer seq) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.findWriter", seq);
	}

	@Override
	public List<UserVO> findSub(int userCode) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("mapper.findSub", userCode);
	}

	@Override
	public void insertSub(Map<String, Object> map) {
		// TODO Auto-generated method stub
		sqlSession.insert("mapper.insertSub", map);
	}

	@Override
	public UserVO chkSub(int userCode) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("mapper.chkSub", userCode);
	}

	@Override
	public List<DocumentVO> findMyDoc(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("mapper.findMyDoc", map);
	}

}
