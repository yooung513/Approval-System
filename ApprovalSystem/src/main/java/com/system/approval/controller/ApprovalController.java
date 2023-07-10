package com.system.approval.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.system.approval.domain.DocumentVO;
import com.system.approval.domain.HistoryVO;
import com.system.approval.domain.UserVO;
import com.system.approval.service.ApprovalServiceInter;
import com.system.approval.service.MailServiceInter;

@Controller
public class ApprovalController {
	
	@Inject
	private ApprovalServiceInter service;
	
	// 로그인 및 메인 화면 접속
	@RequestMapping("/")
	public String login(@RequestParam Map<String, Object> map,
					   HttpSession session,
					   Model model) {
		
		if (session.getAttribute("user") != null) {

			main(session, model);
			return "main";
		}
		
		if (map.isEmpty()) {
			
			return "login";
			
		} else {
			
			int idCheck = service.idCheck(map);
			
			if (idCheck == 0) {
				
				model.addAttribute("result", "idFalse");
				return "login";
				
			} else {
				
				int login = service.login(map); 
				
				if (login == 0) {
					
					model.addAttribute("result", "pwFalse");
					return "login";
					
				} else {
					
					UserVO user = service.user(map);
					session.setAttribute("user", user);
					
					//대리결재자 여부 조회 및 대리자 확인
					int userCode = user.getUserCode();
					UserVO subUser = service.chkSub(userCode);
					
					if (subUser != null) {
						session.setAttribute("subUser", subUser);
					} 
					
					main(session, model);
						
					return "main";
				}
			}
		}
	}
	
	
	//로그아웃
	@RequestMapping("logout")
	public String main (HttpSession session) {
		
		session.invalidate();
		return "login";
	}
	
	
	// 게시판 메인
	@RequestMapping("main")
	public String main( HttpSession session,
					 	Model model) {
		
		UserVO user = (UserVO) session.getAttribute("user");
		UserVO subUser = (UserVO) session.getAttribute("subUser");
			
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userCode", user.getUserCode());
		
		if (subUser != null) {
			map.put("subCode", subUser.getUserCode());
		} else {
			map.put("subCode", null);
		}
		
		List<DocumentVO> document = service.findMyDoc(map);
		
		if (document.size() > 0) {
			
			model.addAttribute("document", document);
			
		} else {
			
			model.addAttribute("result", "zero");
		}
		
		return "main";
	}
	
	
	// 글 쓰기 화면 이동
	@RequestMapping("content")
	private String content(HttpSession session,
						   @RequestParam(required=false) Integer seq,
						   Model model) {
		
		// 글쓰기 화면 가져오기
		if (seq == null) {
			
			// 새로운 글 작성
			int nextSeq = service.findNextSeq();
			
			model.addAttribute("seq", nextSeq);
			model.addAttribute("result", "write");
			
		} else if (seq != null) {
			
			// 기존 글
			DocumentVO document = service.findDoc(seq);
			List<HistoryVO> history = service.findHis(seq);
			
			model.addAttribute("seq", seq);
			model.addAttribute("history", history);
			model.addAttribute("document", document);
			
			String state = document.getStateCode();
			if ("S_01".equals(state)) {
				model.addAttribute("result", "tmp");
				
			} else if("S_05".equals(state)){
				
				Integer writerCode = service.findWriter(seq);
				UserVO user = (UserVO) session.getAttribute("user");
				Integer userCode = user.getUserCode();
				
				if (userCode.equals(writerCode)) {
					model.addAttribute("writer", "mine");
				}
				model.addAttribute("result", "reject");
				
			} else {
				model.addAttribute("result", "saved");
			} 
		}

		return "content";
	}
	
	// 결재 버튼 (정보 입력 및 수정)
	@RequestMapping("approval")
	private String insert(@RequestParam Map<String, Object> map,
						  HttpSession session,
						  Model model) {
		
 		UserVO user = (UserVO) session.getAttribute("user");
		map.put("userCode", user.getUserCode());
		
		String rank = user.getRankCode();
		String subRank = (String) map.get("subRank");
		
		int docSeq = Integer.parseInt((String) map.get("seq"));
		int existDoc = service.checkDoc(docSeq);
		
		Map<String, Object> updcon = new HashMap<String, Object>();
		updcon.put("seq", docSeq);
		updcon.put("title", (String) map.get("title"));
		updcon.put("content", (String) map.get("content"));
		
		// 새로운 글 입력
		if (existDoc == 0) {
			
			if("".equals(subRank)) {
				
				if ("B".equals(rank)) {
					map.put("stateCode", "S_04");
				} else if ("G".equals(rank)){
					map.put("stateCode", "S_03");
				} else 	{
					map.put("stateCode", "S_02");
				}
				
				service.insertDoc(map);
				
			} else {
				
				int subCode = Integer.parseInt((String) map.get("subCode"));
				updcon.put("userCode", user.getUserCode());
				updcon.put("subCode", user.getUserCode());
				updcon.put("aCode", subCode);
				
				if("B".equals(subRank)) {
					updcon.put("stateCode", "S_04");
					map.put("stateCode", "S_04");
					map.put("subCode", subCode);
				} else {
					updcon.put("stateCode", "S_03");
					map.put("stateCode", "S_03");
					map.put("subCode", subCode);
				}
				
				service.insertDoc(updcon);
				
			}
			
			service.insertHis(map);
			
		// 기존 글 결재 
		} else {   
			
			String docState = (String) map.get("docState");
			
			// 임시저장 또는 반려된 글 결재
			if ("S_01".equals(docState) || "S_05".equals(docState)) {
				
				updcon.put("userCode", user.getUserCode());
				
				if ("G".equals(rank)) {
					
					updcon.put("stateCode", "S_03");
					service.updTmp(updcon);
				
				} else if ("B".equals(rank)) {
					
					updcon.put("stateCode", "S_04");
					service.updTmp(updcon);
					
				} else {
					
					updcon.put("stateCode", "S_02");
					service.updTmp(updcon);
					
				}
				
			// 기존 글 승인
			} else {
				
				if ("B".equals(rank)) {
					
					updcon.put("userCode", user.getUserCode());
					updcon.put("stateCode", "S_04");
					service.updateDoc(updcon);
				
				} else if ("G".equals(rank) && "S_02".equals(docState)) {
					
					updcon.put("userCode", user.getUserCode());
					updcon.put("stateCode", "S_03");
					service.updateDoc(updcon);
					
				} else {
					
					int subCode = Integer.parseInt((String) map.get("subCode"));
					
					updcon.put("userCode", subCode);
					updcon.put("subCode", user.getUserCode());
					
					if("B".equals(subRank)) {
						updcon.put("stateCode", "S_04");
					} else {
						updcon.put("stateCode", "S_03");
					}
					
					service.updateDoc(updcon);
					
				}
				
			}
			
			service.insertHis(updcon);
			
		}

		// 저장된 글 조회
		main(session, model);
		
		return "main";
	}
	
	
	// 임시저장
	@RequestMapping("tempSave")
	private String tempSave(@RequestParam Map<String, Object> map,
						  HttpSession session,
						  Model model) {
	
		UserVO user = (UserVO) session.getAttribute("user");
		int userCode = user.getUserCode();
		map.put("userCode", userCode);
		
		int docSeq = Integer.parseInt((String) map.get("seq"));
		int existDoc = service.checkDoc(docSeq);
		
		if (existDoc == 0) {
			
			// 새로운 글 입력
			map.put("stateCode", "S_01");
			service.insertDoc(map);
			service.insertHis(map);
			
		} else {   

			// 기존 글 재 임시저장
			Map<String, Object> updcon = new HashMap<String, Object>();
			updcon.put("seq", docSeq);
			updcon.put("userCode", userCode);
			updcon.put("stateCode", "S_01");
			updcon.put("title", (String) map.get("title"));
			updcon.put("content", (String) map.get("content"));
			
			service.updTmp(updcon);
			service.insertHis(updcon);
			
		}

		// 저장된 글 조회
		main(session, model);	
		
		return "main";
	}
	
	
	// 검색_조건
	@RequestMapping("searchByCon")
	public String searchByCon(@RequestParam Map<String, Object> map,
			  				HttpSession session,
		  					Model model) {
	
		UserVO user = (UserVO) session.getAttribute("user");
		map.put("userCode", user.getUserCode());
		
		UserVO subUser = (UserVO) session.getAttribute("subUser");
		
		if (subUser != null) {
			map.put("subCode", subUser.getUserCode());
		} else {
			map.put("subCode", null);
		}
		
		List<DocumentVO> document = service.findByCon(map);
		
		if (document.size() > 0) {
			
			model.addAttribute("document", document);
			
		} else {
			
			model.addAttribute("result", "zero");
		}
		
		model.addAttribute("search", map);
		
		return "main";
	}
	
	// 검색_상태
	@RequestMapping("searchByState")
	public String searchByState(@RequestParam Map<String, Object> map,
							  				HttpSession session,
						  					Model model) {
		
		UserVO user = (UserVO) session.getAttribute("user");
		map.put("userCode", user.getUserCode());
		
		UserVO subUser = (UserVO) session.getAttribute("subUser");
		
		if (subUser != null) {
			map.put("subCode", subUser.getUserCode());
		} else {
			map.put("subCode", null);
		}
		
		List<DocumentVO> document = service.findByCon(map);
		
		if (document.size() > 0) {
			model.addAttribute("document", document);
			model.addAttribute("search", map);
			
			return "mainlist";
		} else {
			return "nosearch";
		}
	}
	
	
	// 반려
	@RequestMapping("reject")
	public String reject(@RequestParam Map<String, Object> map,
			  			HttpSession session,
		  				Model model) {
	
		UserVO user = (UserVO) session.getAttribute("user");
		String rank = (String) map.get("rank");
		String docState = (String) map.get("docState");
		
		map.put("stateCode", "S_05");
		
		if ("B".equals(rank) || ("G".equals(rank) && "S_02".equals(docState)) ) {
			
			map.put("userCode", user.getUserCode());
			
		} else {
			
			int subCode = Integer.parseInt((String) map.get("subCode"));
			
			map.put("userCode", subCode);
			map.put("subCode", user.getUserCode());
			
		}
			
		service.updateDoc(map);
		service.insertHis(map);
		
		// 저장된 글 조회
		main(session, model);
		
		return "main";
	}
	
	
	// 대리결재 팝업창 조회
	@RequestMapping("subappPop")
	public String subapp(HttpSession session,
						Model model) {
		UserVO user = (UserVO) session.getAttribute("user");
		int userCode = user.getUserCode();
		
		List<UserVO> subUser = service.findSub(userCode);
		model.addAttribute("subUser", subUser);
				
		return "subappPop";
	}
	
	
	// 대리결재자 지정
	@RequestMapping("subUser")
	public String subuser(@RequestParam Map<String, Object> map
						, Model model) {
		
		service.inserSub(map);
		
		model.addAttribute("result", "fin");
		
		return "subappPop";
	}
	
	
	// 회원가입
	@RequestMapping("Signup")
	public String goSignup() {
		return "signup";
	}
	
	@Inject
	private MailServiceInter mailService;
	
	// 인증 메일 전송 
	@GetMapping("sendECode")
	@ResponseBody
	public String sendEcode(String email) {
		
		System.out.println("이메일 인증 주소:::::::::::" + email);
		
		return mailService.joinEmail(email);
	}
	
	
	// 인증 문자 전송
	
	
}
