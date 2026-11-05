# 클로브AI MCP 로 전자세금계산서 자동화 — 강연자료 (project.md)

`project/clobe-mcp-lecture/` 전용 양식. 공통 규칙은 `CLAUDE.md`, 디자인은 `design/CLAUDE.md`.
전용 스타일은 `project/doc-automation-lecture/lecture.css` 를 복사한 `lecture.css`(공통 `report.css`는 건드리지 않음).

> 결과보고서가 아니라 **강연자료**입니다. 「실행요약」 자리에 **이 시간에 가져가는 것**을 둡니다. 명의는 **마음인베스트먼트**.
> 원고: `03_지식·개념/클로브AI_MCP_연동_설치과정_강의용.md` (2026-10-18~19 실제 설치 기록)
> 설치 화면 기준: 클로브AI 앱 > 자동화 > MCP 가이드 (2026-10-19 캡처 `thumb/guide-top.jpg`, `thumb/guide-claudecode.jpg`)

- 작성: 2026-10-19 · 강연 30분 + 질의응답 · AI 실무 활용 교육
- 슬로건(푸터 좌): 미리보기까지 자동, 발급은 사람의 말로

## 바꾸면 안 되는 사실

- MCP 주소: `https://api.clobe.ai/mcp` (HTTP). 클로브 MCP 가이드에 있는 연결 방법 3가지:
  1. Claude 데스크톱 앱: 설정 → 커넥터 → 커넥터 추가(이름 clobe, 위 주소) → 저장 → 연결 → 클로브 로그인·허용
  2. Claude Code 쉬운 방법: 대화창에 "clobe를 연결해줘. clobe MCP 주소는 https://api.clobe.ai/mcp 야. …" 붙여넣기
  3. Claude Code 직접: `claude mcp add --transport http clobe https://api.clobe.ai/mcp` → `/mcp` → clobe → Authenticate
  - 지원 툴 목록(화면): Claude(인기), ChatGPT, Claude Code, OpenAI Codex, Gemini CLI, Cursor
  - 가이드 문구: 로그인은 표준 인증(OAuth), 보안을 위해 주기적으로 갱신
- 세금계산서 도구: get_my_context · get_scraping_status · search_business_entities · preview_issue_tax_invoice · issue_tax_invoice · get_tax_invoices · get_monthly_revenue
- **임시저장 도구 없음.** 미리보기(previewId 10분·1회용) → 발급 두 단계.
- 발급용 인증서 오류 코드: `TAX_INVOICE_CERTIFICATE_REQUIRED`. 등록 위치: 세금계산서 > 발급 > 인증서 관리 > 인증서 선택 > 발급용으로 등록. 회사(워크스페이스)마다.
- 회사 정보 위치: 설정 > 회사 정보 (본사 주소·업태·업종·세금계산서 담당자 이메일).
- 매출 내역 > 연동하기 지원 채널 24곳(2026-10-19 화면).
- 예시 발급 값은 테스트 건: 품목 '테스트', 작성일 2026-08-21, 공급가액 1,000 / 세액 100 / 합계 1,100. 실제 거래처·금액·사업자번호는 쓰지 않는다.

## 페이지 맵

| # | 파일 | 핵심 메시지 |
|---|---|---|
| 1 | 01-cover | 클로브AI MCP 로 전자세금계산서 자동화 — 설치부터 첫 발급까지 |
| 2 | 02-summary | 가져가는 것 3: 설치는 주소 1줄 / 자동화는 미리보기까지 / 함정 3개 |
| 3 | 03-why | 홈택스 브라우저 자동화 → MCP 로 바꾼 이유 |
| 4 | 04-mcp | MCP 란: AI 툴 ↔ MCP ↔ 클로브 ↔ 국세청 |
| 5 | 05-section-install | 간지 1 · 설치 |
| 6 | 06-guide | 클로브 MCP 가이드 화면: 연결하는 툴 6개, 길 3가지 (캡처) |
| 7 | 07-claudecode | Claude Code 연결: 명령 한 줄 → /mcp → Authenticate (캡처) |
| 8 | 08-first-call | 연결 확인: get_my_context → 회사 3곳 |
| 9 | 09-tools | 세금계산서에 쓰는 도구 7개 — 임시저장은 없다 |
| 10 | 10-section-pitfalls | 간지 2 · 막혔던 곳 |
| 11 | 11-cert | 함정 1 · 수집용 ≠ 발급용 인증서 |
| 12 | 12-company | 함정 2 · 회사 정보 빈칸은 세금계산서 빈칸 |
| 13 | 13-amount | 함정 3 · 공급가액인지 합계인지 묻는다 |
| 14 | 14-section-flow | 간지 3 · 발급 흐름 |
| 15 | 15-flow | 9단계: 요청 → 회사 → 거래처 → 미리보기 → 보여 주기 → "발급해" → 발급 → 확인 → 기록 |
| 16 | 16-preview | 미리보기 응답을 표로 보여 주고 멈춘다 |
| 17 | 17-sheet | 구글시트: 읽기는 되고 셀 쓰기는 안 된다 |
| 18 | 18-rules | 안전 장치 7가지 |
| 19 | 19-next | 다음 자동화: 매출 채널 24곳 연동 |
| 20 | 20-closing | 따라 하는 순서 6단계 + 질의응답 |

## 검수 기록 (2026-10-19)

- 넘침 검사 `data-overflow` — 1차 20장 중 4장(09 136px·15 41px·17 103px·20 23px) → 제목 한 줄화·글자 17px·여백 축소 후 20장 전부 0
- Chrome 헤드리스 스크린샷 20장 렌더, 06·07·09·12·15·17·표지 육안 확인
- `python build-report.py clobe-mcp-lecture` → 20페이지 (파일 1개 = 1페이지)
- 캡처 2장: 클로브 MCP 가이드 상단(도구 선택)·Claude Code 탭. 클라이언트 로고 없음(클로브 로고는 캡처 안에만)
