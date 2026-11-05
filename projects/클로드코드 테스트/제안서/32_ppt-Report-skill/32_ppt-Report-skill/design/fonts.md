# 폰트 가이드 (petoday 결과보고서)

이 문서는 프로젝트에 들어있는 폰트들의 **특성·용도·사용법**을 정리합니다.
실제 `@font-face`는 `../assets/fonts.css`, 폰트 파일은 `../assets/fonts/`에 있습니다.

---

## 1. 폴더·파일명 규칙

폰트가 제각각이면 관리가 어려우므로 아래 규칙으로 통일합니다. **새 폰트를 추가할 때도 이 규칙을 따릅니다.**

```
assets/fonts/
├─ pretendard/     Pretendard-<무게>.woff2     (300~900)
├─ paperlogy/      Paperlogy-<무게>.ttf        (100~900)
├─ scdream/        SCDream-<무게>.otf          (100~900)
├─ kopub-dotum/    KoPubDotum-<무게>.ttf       (300·500·700)
├─ kopub-batang/   KoPubBatang-<무게>.ttf      (300·500·700)
├─ vitro/          VitroCore.ttf / VitroInspire.ttf / VitroPride.ttf
└─ arirang/        Arirang.otf
```

- **폴더**: 패밀리마다 하나, 소문자-케밥.
- **파일명**: `PascalName-<무게숫자>.<확장자>` (무게 100~900). 단일 무게 디스플레이 폰트는 `PascalName.<확장자>`.
- **CSS 패밀리명**은 무게가 달라도 하나로 묶는다(예: `"Paperlogy"` 하나에 100~900). → `font-weight` 숫자로 굵기 조절.
- 규칙이 일정하므로 `fonts.css`는 **스크립트로 재생성** 가능(무게 리스트만 바꾸면 됨).

---

## 2. 폰트별 특성

| 폰트 | 종류 | 무게 | 성격 | 추천 용도 |
|---|---|---|---|---|
| **Pretendard** | 산세리프 | 300~900 | 현대적·중립적·가독성 최고. 원본 보고서 느낌 | 본문(대안)·제목 모두 무난 |
| **KoPubWorld 돋움** | 정통 고딕 | 300·500·700 | 차분하고 신뢰감 있는 '문서' 톤. 획이 균일 | **본문·설명(선호)** |
| **S-Core Dream** (에스코어드림) | 지오메트릭 산세리프 | 100~900 | 동글고 깔끔, 무게 폭이 넓음 | 본문·제목 대안, 숫자 강조 |
| **Paperlogy** | 모던 산세리프 | 100~900 | 힘이 있고 트렌디, 큰 숫자가 시원 | 제목·큰 숫자(포인트) |
| **KoPubWorld 바탕** | 명조/세리프 | 300·500·700 | 전통적·격식. 긴 문장에 품위 | 인용·에디토리얼 포인트 |
| **VITRO CORE / INSPIRE / PRIDE** | 디스플레이 | 단일 | 굵고 강한 브랜드 레터링 | 표지·간지 큰 타이틀 포인트 |
| **정선아리랑뿌리체** | 손글씨풍 디스플레이 | 단일 | 개성 강함 | 아주 제한적 포인트만 |

> ⚠️ **디스플레이(VITRO·아리랑)는 본문에 쓰지 않는다.** 표지·간지의 큰 포인트 한두 곳에만.

---

## 3. 이 보고서의 기본 조합 (현재 적용값)

`assets/report.css`의 `:root`:

```css
--font-body: "KoPubWorld Dotum", "Pretendard", …;   /* 설명·본문 (KoPub돋움 선호) */
--font-head: "Pretendard", "KoPubWorld Dotum", …;    /* 제목·큰 숫자 */
```

- **설명/본문 글꼴은 KoPub돋움(선호) 또는 Pretendard** 로 한다. 이 둘 중에서 고른다.
- 제목·큰 숫자는 무게 폭이 넓은 **Pretendard**(900까지)로 힘을 준다. (KoPub돋움은 700이 최대)
- **교체는 위 두 줄만** 바꾸면 전체 반영. 예: 전부 KoPub돋움으로 → `--font-head`도 `"KoPubWorld Dotum"`.

---

## 4. 자간(letter-spacing)

가독성을 위해 한글은 자간을 **살짝 좁힌다.**

```css
--tracking:      -.01em;   /* 기본(전체) */
--tracking-body: -.02em;   /* 읽는 텍스트: 본문·설명·표·캡션 */
```

- 제목·큰 숫자는 `-.01em`(또는 개별값), 읽는 문장은 `-.02em`.
- 너무 좁히면 글자가 붙어 보이므로 **-.02em 이하로는 내리지 않는다.**

---

## 5. 색(검정)

- **본문 검정은 순수 `#000` 을 쓰지 않는다.** 눈이 편한 소프트 블랙 `--ink: #23212E` (아주 옅은 보라 기운) 사용.
- 보조 설명은 `--ink-2 (#4B4666)`, 캡션·푸터는 `--muted (#928DA6)`.

---

## 6. 견본으로 비교하기

`examples/fonts.html` 을 브라우저로 열면 실제 보고서 문구로 각 폰트를 나란히 비교할 수 있다.
새 폰트를 추가하면 이 파일에 한 블록 추가해 눈으로 확인한다.

렌더 확인(참고):
`chrome --headless --screenshot=out.png --window-size=1400,1500 "file:///.../examples/fonts.html"`
