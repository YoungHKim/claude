# 결과보고서 HTML 제작 — 공통 가이드 (CLAUDE.md)

PPT 형태의 결과보고서를 **HTML 슬라이드(1장 = 파일 1개)** 로 만드는 작업의 **공통(범용) 규칙**입니다.
이 문서와 `design/CLAUDE.md`는 **어느 프로젝트에나 똑같이** 적용됩니다.
각 보고서만의 내용(제목·수치·페이지 구성)은 프로젝트마다 있는 **`project.md`** 에 있습니다.

> 원본 PDF가 있으면 **내용·구조 참고용**으로만 봅니다. 문구는 그대로 베끼지 않고, 아래 워딩 원칙에 맞춰 다시 씁니다.

---

## 0. 작업 시작 시 — 어떤 문서를 먼저 볼까

**일을 시작하기 전에, 요청 성격에 맞는 문서를 먼저 읽고 그 규칙을 따른다.**

| 내가 요청한 일 | 먼저 참고할 문서 |
|---|---|
| 이 보고서의 **제목·수치·페이지 구성** (프로젝트 고유 내용) | **`project.md`** |
| **페이지를 어떻게 짜고 무엇을 쓰는지**(골격·작성 지침) | **`outline.md`** |
| **용어의 쉬운 뜻**(조회수·저장·오가닉·잔존가치 등) | **`glossary.md`** |
| **크리에이터 선별 지표·등급**(ER·도달배수·중앙값) | **`screening.md`** |
| 색·폰트·레이아웃·컴포넌트·**애니메이션** 등 "겉모습/움직임" | **`design/CLAUDE.md`** |
| 스타일 코드 수정 | `assets/report.css`, `assets/report.js` |
| 산출물 구조·워딩·작업 방식 (공통) | 이 문서 `CLAUDE.md` |

예) "이 페이지에 카운트업 애니메이션 넣어줘" → `design/CLAUDE.md`의 애니메이션 가이드를 먼저 본다.
예) "slide-05 만들어줘" → `project.md`에서 그 페이지의 수치·메시지를 확인하고, 공통 규칙대로 만든다.

**구분 원칙**: `CLAUDE.md`(+`design/CLAUDE.md`)는 **범용**, `project.md`는 **이 보고서 전용 양식**. 수치·고유명사·페이지 목록은 항상 `project.md`가 기준이다.

---

## 1. 폴더 구조

```
32_ppt-Report-skill/
├─ CLAUDE.md            ← (이 문서) 공통 규칙 · 워딩 · 작업 방식
├─ project.md           ← 이 보고서 전용 양식 (제목·수치·페이지 맵)
├─ assets/
│  ├─ report.css        ← 디자인 시스템 (컬러/타이포/컴포넌트)
│  ├─ report.js         ← 화면 맞춤 스케일 + 애니메이션 헬퍼
│  ├─ vendor/           ← 외부 라이브러리 로컬 사본 (html2canvas)
│  └─ fonts/            ← 로컬 폰트 (KoPub 등) 넣는 곳
├─ design/
│  ├─ CLAUDE.md         ← 공통 디자인 시스템 + 애니메이션 + PDF 안전 규칙
│  └─ fonts.md          ← 폰트 특성·규칙
├─ project/             ← ⭐ 실제 슬라이드는 프로젝트별 하위폴더에
│  └─ <프로젝트명>/       ← 예: sample-influencer-campaign (ASCII명 권장 — 한글은 NFD 문제)
│     ├─ 01-cover.html … 0N-*.html   ← 슬라이드 (자산은 ../../assets/ 로 참조)
│     ├─ pages.js       ← 이 프로젝트의 페이지 순서 (← → 이동)
│     ├─ thumb/         ← 크리에이터 썸네일 등 프로젝트 이미지
│     └─ report-output.pdf  ← 이 프로젝트 병합 PDF
└─ build-report.py      ← 슬라이드를 1개 PDF로 병합 (project/*/ 자동 인식)
```

> **CLAUDE.md·design/·assets/ 는 공통 자산**(다른 프로젝트에 그대로 재사용).
> **project.md 와 `project/<프로젝트명>/` 폴더는 프로젝트마다 새로** 만든다.
> 슬라이드는 프로젝트 폴더(`project/<이름>/`) 안에 두고 공통 자산은 **`../../assets/`** 로 참조한다(한 단계 더 깊음).
> 새 슬라이드는 `project/sample-influencer-campaign/`에서 필요한 조각(차트·레이아웃·footer)을 **복사해 시작**한다.
> 빌드: `python build-report.py`(프로젝트 하나면 자동) / 여러 개면 `python build-report.py <프로젝트명>`.

---

## 2. 산출물 규칙

- **슬라이드 1장 = HTML 파일 1개.** 파일명 `slide-01.html` … `slide-18.html`.
- 공통 자산(`assets/report.css`, `assets/report.js`)은 모든 슬라이드가 공유한다.
- 각 슬라이드 HTML 뼈대:

```html
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <link rel="stylesheet" href="assets/report.css">
</head>
<body>
  <section class="slide content">
    <!-- 여기에 슬라이드 내용 -->
  </section>
  <script src="assets/report.js"></script>
</body>
</html>
```

- 외부 라이브러리(차트 라이브러리 등)는 쓰지 않는다. **차트는 순수 HTML/CSS/SVG.** → 파일 하나로 자립.
- 예외: 화면 캡처용 **html2canvas**만 `assets/vendor/`의 로컬 사본을 쓴다. 사용법과 주의점은 6번 항목.
- 여러 슬라이드에 공통으로 바꿀 것이 생기면 개별 파일이 아니라 **`assets/report.css`에서** 바꾼다.

---

## 2-1. 로고·이미지 자산 규칙

- **폰트 종류·특성**은 `design/fonts.md`. **로고 파일**은 `assets/logo/` 에 둔다.
  - `assets/logo/` — petoday 자체 로고 자리. 지금은 로고 파일 없이 글자 워드마크(`<p class="wordmark">PETODAY</p>`)를 쓴다.
  - `assets/logo/client/` — **클라이언트/브랜드 로고** 넣는 곳.
- **형식: SVG 권장, PNG 가능**(투명 배경·고해상도). 다크 배경에 올리는 단색 로고는 `filter: brightness(0) invert(1)`로 흰색 변환.
- ⭐ **필요한 로고가 없으면**: 먼저 **해당 경로(폴더)를 만들어 두고**, 사용자에게 *"여기(`assets/logo/client/`)에 로고를 넣어주세요 — SVG 권장, PNG 가능"* 라고 **안내한 뒤**, 넣기 전까지는 텍스트/빈자리(placeholder)로 진행한다. 로고를 임의로 만들어내지 않는다.

---

## 3. 워딩(카피) 원칙 ⭐

> 목표: **작위적이지 않고, 쉬운 말로, 담백하게.** 읽는 사람이 한 번에 이해되게.

0. **톤: 쉽지만 전문적으로.** 이 문서는 **마케팅 대행사가 고객사에 전달하는 보고서**다. 쉽게 쓰되 **구어체·유아적 표현은 피하고**, 실무 용어(언박싱·시식 리뷰·사전 바이럴·중앙값·산술평균 등)는 그대로 쓰되 **어려운 것만 풀이**한다. 담백한 문어체 존댓말.
   - ✅ "크리에이터가 직접 구매·언박싱·시식 리뷰를 진행하고 구매처를 안내"  ❌ "직접 사서 뜯어보고 먹어본 뒤 어디서 파는지 알려줌"
   - ✅ "성과는 산술평균보다 중앙값으로 봐야 정확합니다"  ❌ "평균만 보면 착각합니다 · 평소 실력"
1. **쉬운 단어를 쓴다.** 어려운 마케팅 용어는 풀어서 쓰거나 괄호로 뜻을 단다. 용어 풀이는 **`glossary.md`** 를 기준으로 하고, 없는 용어를 새로 쓰면 사전에 추가한다.
   - ✅ "나중에 다시 보려고 저장한 횟수(저장)"  ❌ "리텐션 인텐트 시그널"
2. **과장·미사여구를 뺀다.** "폭발적/압도적/역대급"은 숫자로 대체.
   - ✅ "업계 평균의 2.6배"  ❌ "압도적인 성과"
3. **숫자에는 항상 '무슨 뜻인지' 한 줄을 붙인다.**
   - ✅ "132.9만 회 — 콘텐츠 59편을 합친 총 조회 수"
4. **한 페이지 = 한 메시지.** 제목이 곧 결론. 본문은 그 근거만.
5. **주장에는 근거를 붙인다.** 배수·비교엔 기준/출처를 캡션으로 명시.
6. **문장은 짧게.** 한 문장에 한 가지만.
7. **담백한 존댓말 종결**("~했습니다/~입니다"). 느낌표·이모지는 쓰지 않는다.
8. **고유명사·수치는 원본과 정확히 일치.** 표현만 다듬고 **사실은 바꾸지 않는다.**

---

## 4. 페이지 맵

페이지 목록과 각 페이지의 핵심 메시지·수치는 **`project.md`의 「페이지 맵」** 에 있다. (프로젝트마다 다르므로 이 공통 문서에는 두지 않는다.)

---

## 5. 작업 방식

- **한 장씩** 만든다 → Chrome 헤드리스로 렌더한 이미지로 확인 → 피드백 → 다음 장.
- 렌더 확인(참고):
  `chrome --headless --screenshot=out.png --window-size=1920,1080 --hide-scrollbars "file:///.../cover.html"`
- 디자인·애니메이션 관련 판단이 필요하면 **`design/CLAUDE.md`를 먼저 본다.**
- 표지 파일은 `cover.html`, 내용은 `slide-02.html`~`slide-18.html`(PDF 페이지번호와 일치).

### PDF 내보내기
- 새 슬라이드는 만들면 **PDF로 뽑아 "파일 1개 = 1페이지 + 내용 온전"** 을 확인한다.
- HTML→PDF에서 **내용이 사라지지 않게 하는 규칙**은 `design/CLAUDE.md`의 **「7. PDF 안전 규칙」** 을 반드시 지킨다(삐져나가는 장식은 배경으로, `print-color-adjust: exact` 유지 등).
- 전체 병합 PDF: `python build-report.py` → `report-output.pdf`.

---

## 6. 필요 환경 · 라이브러리 ⭐

컴퓨터마다 도구가 다를 수 있으니, **작업 시작 전에 아래 설치 여부를 먼저 확인**하고, 없으면 설치한 뒤 진행한다. (여기에 적어두고, 새 도구를 쓰게 되면 이 표에 추가한다.)

| 도구 | 용도 | 확인 | 설치 |
|---|---|---|---|
| **Python 3** | PDF/CSV 처리·집계, 빌드 스크립트 | `python --version` | python.org (Win) |
| **pymupdf** (`fitz`) | PDF 렌더·병합 (`build-report.py`) | `python -c "import fitz"` | `pip install pymupdf` |
| **fonttools** | 폰트 내부 이름 확인(폰트 추가·정리 시) | `python -c "import fontTools"` | `pip install fonttools` |
| **Chrome/Edge (headless)** | 슬라이드 렌더(스크린샷)·PDF 인쇄 | 아래 경로 존재 확인 | Chrome 설치 |
| **html2canvas** 1.4.1 (MIT) | 브라우저 안에서 슬라이드를 PNG로 저장 (선택) | `ls assets/vendor/html2canvas.min.js` | 폴더에 포함됨. 다시 받기: `npm pack html2canvas@1.4.1` 후 `dist/html2canvas.min.js` 복사 |

- Python 라이브러리는 `requirements.txt`로 한 번에: **`pip install -r requirements.txt`**
- **Chrome 경로**(Windows 기본): `C:\Program Files\Google\Chrome\Application\chrome.exe`
  - 없으면 Edge: `C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe`
  - `build-report.py`는 이 경로들을 자동으로 찾는다(`CHROME_CANDIDATES`). 다른 위치면 그 배열에 추가.

### html2canvas로 슬라이드 캡처 (선택)

PDF·검수용 이미지는 위의 Chrome 헤드리스가 더 정확하다. html2canvas는 **브라우저 화면 안에서 바로 PNG로 저장**해야 할 때만 쓴다. 슬라이드 기본 뼈대에는 넣지 않고, 필요한 페이지에서만 불러온다.

```html
<script src="../../assets/vendor/html2canvas.min.js"></script>
<script>
async function captureSlide() {
  await document.fonts.ready;
  return html2canvas(document.querySelector('.slide'), {
    scale: 1, x: 0, y: 0, width: 1920, height: 1080, windowWidth: 1920, windowHeight: 1080,
    onclone: d => {
      const st = d.createElement('style');
      st.textContent = 'html,body{width:1920px;height:1080px;margin:0;overflow:hidden}'
        + '.deck-nav{display:none!important}'
        + '.slide{position:static!important;transform:none!important;margin:0!important}';
      d.head.appendChild(st);
      d.querySelectorAll('hr.rule').forEach(h => {
        const v = d.createElement('div'); v.className = 'rule'; h.replaceWith(v);
      });
    }
  });
}
</script>
```

실측 주의점 (2026-11-05):
- 위 `onclone` 없이 부르면 슬라이드 중앙 배치와 화면 맞춤 `transform` 때문에 내용이 밀리고 잘리며, `<hr class="rule">` 구분선도 빠진다. **오류 없이 깨진 이미지가 나오니** 결과를 눈으로 확인한다.
- **CSS `filter`가 적용되지 않는다.** `.on-dark` 로고는 흰색으로 바뀌지 않고, `.mosaic` 블러는 풀려서 밑 글자가 그대로 보인다. 실제 이름을 모자이크로 가린 장은 캡처하지 않는다.
- 그림이 있는 슬라이드를 `file://`로 열면 `toDataURL`이 `SecurityError`로 막힌다. `http://localhost`로 띄우거나 Chrome을 `--allow-file-access-from-files`로 연다.

### 시작 전 한 번에 확인 (복사해서 실행)
```bash
python --version && \
python -c "import fitz, fontTools; print('py libs OK')" && \
ls "/c/Program Files/Google/Chrome/Application/chrome.exe" >/dev/null 2>&1 && echo "chrome OK" || echo "chrome 확인 필요"
```
- **하나라도 실패하면** 해당 도구를 먼저 설치한 뒤 작업을 이어간다.
- 렌더/PDF 없이 **문서(md)만 고치는 작업**이면 위 도구는 없어도 된다.

> ⚠️ 콘솔에서 한글이 깨지면(cp949) 파이썬 출력은 **UTF-8 파일로 저장해 읽는다**(`io.open(..., encoding='utf-8')`). 스크립트 출력은 `sys.stdout.reconfigure(encoding='utf-8')`로 해결.
> ⚠️ 한글 파일/폴더명은 **자소분리(NFD)** 로 저장돼 셸 글롭·`.gitignore` 매칭이 어긋날 수 있다. 파이썬 `os.listdir` + `unicodedata.normalize('NFC', name)` 로 다룬다.
