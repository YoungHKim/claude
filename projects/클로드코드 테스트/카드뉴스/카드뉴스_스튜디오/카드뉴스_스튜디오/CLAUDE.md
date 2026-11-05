# 프로젝트 규칙: 정보제공형 카드뉴스 스튜디오

지원사업·제도처럼 **여러 항목을 정리해 알려 주는** 인스타 카드뉴스를 만드는 폴더다.
원고 파일 하나로 카드 HTML을 만들고, 화면에서 검수한 뒤 PNG로 내보낸다.

사용자가 "카드뉴스 만들어줘", "정보제공용 카드뉴스", "지원사업 정리 카드뉴스"라고 하면 이 문서의 순서를 따른다.

## 처음 한 번 환경 확인

작업 전에 아래를 확인하고, 없으면 사용자에게 설치를 안내한다. 사용자 동의 없이 시스템에 설치하지 않는다.

| 필요한 것 | 확인 | 설치 |
|---|---|---|
| Node.js | `node -v` | https://nodejs.org 의 LTS |
| Playwright | `tools/node_modules/playwright` 폴더 | `cd tools && npm install && npx playwright install chromium` (약 200MB) |
| Python + Pillow | `python -c "import PIL"` (맥은 `python3`) | `pip install pillow` |

## 카드 구성

| 카드 | 구성 | 이미지 슬롯 |
|---|---|---|
| 표지 | 사진 + 아래로 어두워지는 그늘, 칩, 3줄 제목(마지막 줄 하늘색), 넘겨보기 버튼 | `cover` |
| 본문 (항목마다 1장) | 검정 바탕, 공식 화면 캡처, 번호 제목, 하늘색 한 줄, 대상/지원/방법 표, 단서, 찾는 곳, 확인일 | `s2`, `s3` … |
| 마지막 | 표지 사진을 어둡게, 큰 제목, 필요한 도움↔찾아볼 사업 표, 저장 유도 문구 | `end` |

크기는 **1080×1440(3:4)**, 틀은 `shared/series/info.css` 하나다. 편마다 따로 고치지 않는다.

## 한 편 만드는 순서

1. **조사.** 공식 공고·누리집에서 확인한 값만 쓴다. 금액·대상·기간은 항목의 `src` 에 출처를 남기고, `checked` 에 확인일을 적는다. 확인 못 한 값은 쓰지 않고 보고에 적는다.
2. **원고.** `원고/2026-11-info-00.py` 를 복사해 `원고/YYYY-MM-info-NN.py` 로 만들고 내용을 바꾼다. 항목 수는 자유.
3. **공식 화면 캡처.** 쓸 수 있는 브라우저 도구로 찍거나 사용자에게 캡처를 받는다. 파일은 `원고/<편>/` 에 넣고 항목의 `shot` 에 적는다. 기관 로고가 들어가므로 게시 전에 사용해도 되는지 사용자에게 확인한다.
4. **표지 사진.** 사용자 제공 또는 이미지 생성 도구. 비용이 드는 도구는 먼저 묻는다. 프롬프트 틀:
   `Editorial concept photograph shot on 35mm film. <인물 + 주제를 상징하는 물건을 다루는 장면>. Plain pale desaturated backdrop, soft natural daylight, gentle film grain, muted tones with one vivid accent color. Composition: the head sits very high in the frame, the top of the hair at about 12 percent of the image height from the top, the eyes at about 24 percent, the chin at about 38 percent. Vertical 3:4. No text, no letters, no logos, no watermark.`
   **구도 숫자를 빼지 않는다.** 표지 아래쪽은 그늘로 덮이므로 턱이 40% 아래로 내려가면 얼굴이 가려진다.
5. **생성·검수.** 아래 세 줄을 돌리고 `_review.png` 를 직접 본다(§0).
   ```bash
   python tools/info_gen.py 원고/YYYY-MM-info-NN.py       # 사진을 바꿨으면 --photos
   node tools/render.js YYYY-MM-info-NN
   node tools/render.js YYYY-MM-info-NN --export          # out/card-01.png … (2160×2880)
   ```

### 원고에서 정하는 것

| 필드 | 뜻 |
|---|---|
| `slug` · `title` | 폴더 이름 · 화면 제목 |
| `chip` · `cover` · `label` | 표지 칩 · 제목 줄 목록 · 왼쪽 아래 글자 |
| `photo` | `('경로', 가로초점, 세로초점)`. 표지·마지막 카드 공용. 경로는 원고 파일 기준 |
| `checked` | 본문 맨 아래 확인일 (항목별로 다르면 항목의 `foot`) |
| `items[]` | `title` `sub` `cap` `shot` `rows[(이름, 내용)]` `notes[]` `where` `src` |
| `end` | `head` `th` `rows` `save` `lines` `foot` |
| `caption` · `tags` | meta.md 의 게시 캡션 초안 |

글자 문법: `==글자==` 하늘색 강조, `**글자**` 굵게, `\n` 줄바꿈.

표지 제목 크기는 가장 긴 줄을 폰트 파일로 재서 자동으로 정해지고(최대 94px), 브랜드 글자 색도 사진 윗부분 밝기로 자동으로 정해진다. 고정하려면 `cover_size`.
본문이 넘치면 render.js 가 `[문제]` 로 알려 준다. 줄이거나 항목을 나눈다.

### 바꾸는 곳

- **브랜드 글자:** `shared/series/brand.txt` 한 줄(편별로 다르면 원고에 `brand`). 처음 값은 `MYBRAND` 이니 사용자에게 물어 바꾼다.
- **강조색:** `info.css` 의 `--sky` 한 줄.
- **넘겨보기 문구, 카드 구조:** `tools/info_gen.py`.

### 샘플

`projects/2026-11-info-00` 은 틀 확인용이다. 사업 이름·금액이 자리표시이므로 **게시하지 않는다.** 샘플에 든 사진과 캡처도 예시용이다.

### 레퍼런스

다른 계정 게시물을 참고할 때는 **배치·글자 크기·색·말투만 참고한다.** 그 계정의 글·사진·로고·브랜드 표기는 쓰지 않는다.

---

## 0. 검수: 사용자에게 내놓기 전에 반드시 실행

**코드를 고친 것으로 끝내지 않는다. 렌더링해서 눈으로 확인한 뒤에만 "완성"이라고 말한다.**

```
1. 렌더    node tools/render.js <주제>
2. 자동검사 결과 확인          (콘솔 오류 / 요소 넘침)
3. 육안검수 out/_review.png 를 직접 열어 아래 체크리스트 확인
4. 문제 발견 → 수정 → 1번으로 돌아가 반복
5. 보고    무엇을 만들었는지, 검수에서 무엇을 고쳤는지, 남은 한계
```

자동 검사가 세는 것: 콘솔 오류, 로드 실패, 카드 밖으로 벗어난 요소.
`assets/<슬롯>.png → .jpg → …` 를 차례로 찔러보다 난 '없는 파일'은 정상 동작이라 세지 않는다.

### 육안 체크리스트

- [ ] 글자가 잘리거나 넘치지 않는가
- [ ] 표지 얼굴이 그늘이나 칩에 가려지지 않는가
- [ ] 브랜드 글자가 사진 위에서 읽히는가
- [ ] 캡처가 찌그러지지 않고 필요한 부분이 보이는가
- [ ] 의도하지 않은 빈 공간이 없는가
- [ ] 금액, 대상, 기간이 공식 공고와 같은가
- [ ] 확인일이 적혀 있는가

**렌더링 확인 없이 "완성했습니다"라고 보고하지 않는다.**

---

## 1. 폴더 구조

```
CLAUDE.md
카드뉴스_스튜디오_사용설명서.md   사람이 읽는 설명서
시작하기.bat / 시작하기.command   더블클릭으로 서버 켜기
index.html                  관리 화면 (http://localhost:5174 의 첫 화면)
font/                       폰트 (Pretendard 만 들어 있다)
shared/                     모든 편이 같이 쓰는 틀
  card.css                    카드 기본 껍데기
  series/info.css             정보제공형 틀
  series/brand.txt            브랜드 글자
  studio.css · studio.js      PNG 다운로드 · 이미지 슬롯
  editor.css · editor.js      글자 편집, 주제 목록 칸
tools/
  info_gen.py                 원고 → 카드 생성기
  render.js                   검수 · PNG 내보내기 (검수 규칙의 정본)
  serve.js                    로컬 서버 + 편집 저장 + 관리 API
원고/                        새 편의 원고와 재료
projects/                   주제별 결과. 여기만 늘어난다
  <주제>/index.html · meta.md · assets/ · out/ · .backup/
reference/                  레퍼런스 이미지 (붙여넣으면 생긴다)
_휴지통/                     삭제한 주제 (삭제하면 생긴다)
```

### 관리 화면

```bash
node tools/serve.js            # http://localhost:5174
```

화면 순서는 첫 화면(최근 카드) → 스크롤 마퀴 → 작업 목록 → 만들기(새 주제·레퍼런스) → 쓰는 법이다. 목록은 최근 수정한 순이고, 최근 3편은 크게, 4편째부터는 작은 격자로 나온다.
**검수 렌더** · **PNG 내보내기** 버튼은 `node tools/render.js <주제> [--export]` 를 그대로 돌린다. 검수 규칙이 갈라지지 않게 render.js 하나만 쓴다.

**이름 규칙:** `YYYY-MM-영문슬러그` (예: `2026-11-pet-food`). 한글·공백·대문자를 쓰지 않는다.

### 브라우저에서 글자 고치기

주제를 열면 아래에 검은 바가 뜬다. **글자 편집** → 글자 클릭 → **저장** 또는 **Ctrl+S**. 저장 직전 사본이 `.backup/` 에 최신 10개 남는다.
고칠 수 있는 것은 글자뿐이다. 카드 추가·삭제, 레이아웃은 원고와 생성기로 한다.
⚠ 편집 화면에서 고친 편을 생성기로 다시 만들면 덮어써진다. 원고에도 반영한다.

**주제 목록 칸:** 편집 화면 왼쪽. 관리 화면으로 나가지 않고 다른 주제로 옮겨 가고, 새 주제를 만들고, 삭제한다. 검은 바의 `주제 목록 N` 으로 여닫는다.

**레퍼런스:** 이미지를 붙여넣으면 `reference/` 에 저장된다. 파일 이름이 주제 이름으로 시작하고 바로 뒤가 `.` 나 `_` 이면 그 주제 것이다. `_ref1-` · `_ref2-` 가 레퍼런스 1 · 2 묶음이 된다. `GET /__api/references?project=<주제>` 로 찾아 Read 로 본다.

### 저장이 파일을 안 망가뜨리는 약속

아무것도 안 고치고 저장하면 **바이트 단위로 같은 파일**이 나온다. 이게 안전선이다.
`studio.js`·`editor.js` 에 DOM 을 넣거나 인라인 style 을 덮어쓰는 코드를 추가할 때는 표시를 같이 붙인다.

| 상황 | 붙일 것 |
|---|---|
| 요소를 새로 만들어 넣는다 | `el.dataset.x = 'drop'` |
| 원래 내용을 한 겹 감싼다 | `el.dataset.x = 'unwrap'` |
| 원래 내용을 덮어쓴다 | 덮기 전에 `el.dataset.xHtml = el.innerHTML` |
| 인라인 style 을 덮어쓴다 | 덮기 전에 `keepStyle(el)` |

body 에 붙이는 화면용 클래스는 `editor.js` 의 `RUNTIME_CLASS` 에 넣는다.
**Claude 가 `index.html` 을 고친 뒤에는 사용자에게 편집 화면을 새로고침하라고 말한다.** 먼저 열린 탭의 저장은 서버가 막는다(409).

### serve.js 가 파일을 건드리는 범위

| API | 하는 일 | 제한 |
|---|---|---|
| `POST /__save` | `index.html` 덮어쓰기 | `projects/` 아래 이미 있는 파일만 |
| `POST /__api/new` | 주제 폴더 만들기 | 이름 규칙에 맞고 없는 이름만 |
| `POST /__api/delete` | 주제 폴더를 `_휴지통/` 으로 옮기기 | 있는 주제만. 마지막 한 편은 막음. 파일을 없애지 않음 |
| `POST /__api/render` | `render.js` 실행 | 인자는 주제 이름과 `--export` 뿐 |
| `POST /__api/reference` | 붙여넣은 이미지 저장 | `reference/` 에만, 이미지만, 10MB, 덮어쓰기 없음 |

서버는 **127.0.0.1 로만** 연다. 파일을 쓰는 서버라 다른 기기에 열어두지 않는다.

### 내보내기

- **명령줄:** `node tools/render.js <주제> --export`
- **브라우저:** 카드 옆 **PNG 다운로드**. 반드시 `http://localhost:5174` 로 연다. `file://` 로 열면 조용히 실패한다.

html2canvas 는 `repeating-linear-gradient` 와 `<svg>` 에 직접 건 `position:absolute` 를 못 그린다. 새 장식을 넣으면 PNG 로 받아 확인한다.

---

## 2. 폰트

항상 `font/fonts.css` 를 불러오고, 폰트는 CSS 변수로만 지정한다. `font-family` 에 폰트 이름을 직접 쓰지 않는다.
이 배포본에는 **Pretendard** 만 들어 있다(SIL OFL 1.1, `font/Pretendard_LICENSE.txt`). 폰트만 따로 판매하지 않는다.
굵기는 `bold` 가 아니라 숫자(`600`, `800`)로 쓴다.
다른 폰트로 바꾸면 `tools/info_gen.py` 의 `title_size` 가 재는 폰트 파일도 같이 바꾼다.

## 3. 한글 타이포 기본값

```css
word-break: keep-all;      /* 어절 단위 줄바꿈 */
line-height: 1.7;          /* 본문 */
line-height: 1.3;          /* 제목 */
letter-spacing: -0.01em;   /* 본문 */
letter-spacing: -0.03em;   /* 제목 */
```

제목 줄바꿈은 브라우저에 맡기지 말고 직접 끊는다. 카드뉴스는 줄 나눔이 곧 디자인이다.

## 4. 지켜야 할 규칙

1. **확인한 값만 쓴다.** 확인 못 한 값은 쓰지 않고 보고한다.
2. **확인일을 남긴다.** 지원사업은 자주 바뀐다.
3. **샘플은 게시하지 않는다.**
4. **게시는 사람이 한다.** 자동 게시 기능은 없다.
5. **비용이 드는 작업은 먼저 묻는다.**
