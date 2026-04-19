# dirini-harness

> Claude Code를 **사고 파트너**로 쓰기 위한 스킬, 에이전트, 훅, 글쓰기 시스템 세트

---

## 30초 요약

| 질문 | 답 |
|------|-----|
| 이게 뭔가? | Claude Code 개인 하네스. 스킬·에이전트·훅이 묶인 공유 패키지 |
| 누구에게 맞나? | 코딩이 아닌 **글쓰기·사고·기획**에 Claude를 쓰고 싶은 사람 |
| 핵심 기능은? | 인터뷰 → 글쓰기 → 자기 스타일 유지 → 세션 연속성 |
| 설치 방법은? | `git clone` → `./install.sh` → 훅 연결 |
| 지금 바로 쓸 수 있는 건? | `/clarify` `/interview` `/wrap` |

---

## 설치

```bash
git clone https://github.com/Dirini/dirini-harness.git
cd dirini-harness
./install.sh
```

`~/.claude/` 아래에 심볼릭 링크로 연결됩니다. `git pull` 하면 즉시 반영.

기존 `CLAUDE.md`가 있으면 자동으로 백업 후 덮어씁니다.

---

## 훅 연결 (필수)

설치 후 `~/.claude/settings.json`에 아래 블록을 추가하세요.

```json
{
  "hooks": {
    "PreToolUse": [
      {"matcher": "Write|Edit", "hooks": [{"type": "command", "command": "~/.claude/hooks/guard-protected-files.sh"}]}
    ],
    "PostToolUse": [
      {"matcher": "Write|Edit", "hooks": [{"type": "command", "command": "~/.claude/hooks/post-tool-format.sh"}]}
    ],
    "SessionStart": [
      {"matcher": "*", "hooks": [{"type": "command", "command": "~/.claude/hooks/session-start-guide.sh"}]}
    ]
  }
}
```

`settings.example.json`에 전체 예시가 있습니다.

---

## 설치 직후 해야 할 3가지

**① CLAUDE.md 완성**

`~/.claude/CLAUDE.md` 파일 상단에 아래 섹션을 추가하세요. Claude가 매 세션 참고하는 전역 기억입니다.

```markdown
## 나는 누구인가

| 항목 | 내용 |
|------|------|
| 직업 | 학생 / PM / 개발자 / 디자이너 |
| 관심 분야 | 기획, 개발, 글쓰기 |
| 목표 | (한 줄로) |

## 현재 진행 중

- (지금 작업 중인 것)
```

**② 첫 스킬 실행**

```
/clarify    ← 모호한 요청을 꼬리질문으로 정리
/interview  ← 생각을 끌어내는 5-7라운드 인터뷰
/wrap       ← 세션 마무리 + 다음 세션 인수인계
```

**③ 조민 하네스 읽기**

`docs/조민-하네스.md`에 10가지 멘탈모델이 있습니다.  
특히 **"암묵지 → 명시지"** 와 **"판단의 해상도"** 두 원칙이 CLAUDE.md를 어떻게 채울지 방향을 잡아줍니다.

---

## 전체 구성

```
dirini-harness/
│
├── CLAUDE.md                    ← 전역 지침 (Guardrails, 워크플로우, 소통 규칙)
├── install.sh                   ← 설치 스크립트
├── settings.example.json        ← 훅 연결 예시
│
├── skills/                      ← 슬래시 커맨드로 부르는 스킬들
│   ├── clarify/                 ← 요청 명확화
│   ├── interview/               ← 깊이 인터뷰
│   ├── checkinbox/              ← 인박스 트리아지 + 학습 로그
│   ├── checkpoint/              ← 세션 진행상황 저장
│   ├── resume/                  ← 이전 세션 재개
│   ├── assignment-brainstorming/ ← 과제 브리프 정리
│   ├── assignment-planning/     ← 개요·논리 설계
│   ├── style-learning/          ← 내 글에서 말투 규칙 추출
│   ├── copywriting/             ← 마케팅 카피
│   ├── copy-editing/            ← 문장 편집
│   ├── cover-letter/            ← 자기소개서 (7항목 루브릭)
│   ├── ux-writing/              ← UX 라이팅
│   ├── korean-spell-check/      ← 맞춤법 교정
│   ├── interview-script/        ← 인터뷰 스크립트 설계
│   └── summarize-interview/     ← 인터뷰 내용 구조화 요약
│
├── agents/                      ← 서브에이전트 (Claude가 자동 호출)
│   ├── writing-router.md        ← 형식·목적 분류
│   ├── writing-orchestrator.md  ← 글쓰기 순서·게이트 조율
│   ├── writing-intake.md        ← 요구사항·맥락 수집
│   ├── voice-profiler.md        ← 말투 규칙 추출
│   ├── background-researcher.md ← 배경자료 조사
│   ├── argument-architect.md    ← 주장·문단 구조 설계
│   ├── draft-writer.md          ← 근거 기반 초안 작성
│   ├── output-evaluator.md      ← 결과물 품질 평가
│   └── verification.md          ← 코드 변경 후 자동 검증
│
├── plugins/                     ← 번들 플러그인 (설치 시 자동 연결)
│   ├── clarify/                 ← /clarify
│   └── session-wrap/            ← /wrap
│
├── hooks/
│   ├── guard-protected-files.sh ← 중요 파일 실수 수정 차단 (PreToolUse)
│   ├── post-tool-format.sh      ← 포매팅 + diff 피드백 (PostToolUse)
│   └── session-start-guide.sh  ← 미완료 작업 안내 (SessionStart)
│
├── writing-system/              ← 글쓰기 형식·목적·루브릭 레퍼런스
│   ├── formats/                 ← 독후감, 에세이, 성찰문, 보고서, 자기소개
│   ├── purposes/                ← 분석, 설득, 정보전달, 성찰, 지원
│   ├── rubrics/                 ← 채점 기준
│   ├── voice-rubrics/           ← 말투 채점 기준
│   └── samples/                 ← 샘플 보관 위치
│
├── rules/
│   └── follow-up-questions.md  ← 꼬리질문 원칙 (모호함 감지 → 모드 선택)
│
├── templates/
│   └── handoff-template.md     ← 세션 인수인계 문서 템플릿
│
└── docs/
    └── 조민-하네스.md           ← 핵심 멘탈모델 10원칙
```

---

## 추천 워크플로우

### 시나리오 1 — 모호한 요청을 구체화할 때

```
/clarify  →  /interview
```

요청을 명확하게 쪼갠 다음, 필요하면 인터뷰로 더 파고듭니다.  
글쓰기나 실행에 들어가기 전에 방향이 흔들리지 않게 잡아주는 흐름입니다.

---

### 시나리오 2 — 과제·독후감·에세이를 쓸 때

```
/assignment-brainstorming
  → /style-learning  (내 샘플로 말투 학습)
  → /assignment-planning  (개요 설계)
  → Claude가 agents 자동 호출:
       writing-intake → voice-profiler → background-researcher
       → argument-architect → draft-writer
  → /output-evaluator (독립 품질 평가)
  → /korean-spell-check
```

`writing-system/` 안의 형식별 루브릭이 자동으로 참조됩니다.  
샘플을 `writing-system/samples/`에 넣어두면 말투 학습 정확도가 올라갑니다.

---

### 시나리오 3 — 긴 세션을 이어갈 때

```
오늘: /checkpoint  →  다음 날: /resume
세션 끝: /wrap
```

`/checkpoint`가 진행상황을 저장하고, 다음 날 `/resume`이 바로 이어줍니다.  
`session-start-guide.sh` 훅이 세션 시작 시 미완료 항목을 자동으로 알려줍니다.

---

### 시나리오 4 — 인박스·뉴스레터·자료를 정리할 때

```
/checkinbox
```

콘텐츠를 4가지 축(도메인 연관성, 실행 가능성, 시의성, 출처 신뢰도)으로 점수화하고,  
★★★ 항목은 즉시 하네스 반영까지 닫힌 루프로 처리합니다.

---

## 스킬 레퍼런스

### 사고·인터뷰

| 슬래시 커맨드 | 역할 |
|--------------|------|
| `/clarify` | 모호한 요청 → 객관식 꼬리질문 3종 모드로 명확화 |
| `/interview` | 5-7라운드 깊이 인터뷰 → 스펙·브리프 문서 도출 |
| `/summarize-interview` | 인터뷰 내용 구조화 요약 |
| `/checkinbox` | 인박스 점수화 → 학습 로그 → 하네스 반영 |

### 글쓰기

| 슬래시 커맨드 | 역할 |
|--------------|------|
| `/assignment-brainstorming` | 과제가 실제로 요구하는 것 명확화 + 브리프 설계 |
| `/assignment-planning` | 개요·주장 흐름·문단 구조 설계 |
| `/style-learning` | 내 샘플에서 말투 규칙을 명시적 기준으로 변환 |
| `/copywriting` | 마케팅 카피 작성 |
| `/copy-editing` | 문장 다듬기·편집 |
| `/cover-letter` | 자기소개서 (7항목 100점 루브릭) |
| `/ux-writing` | UX 라이팅 |
| `/korean-spell-check` | 국립국어원 기준 맞춤법 교정 |
| `/interview-script` | 사용자 인터뷰 스크립트 설계 |

### 세션 관리

| 슬래시 커맨드 | 역할 |
|--------------|------|
| `/checkpoint` | 긴 세션 중 진행상황 파일로 저장 |
| `/resume` | 이전 세션에서 멈춘 지점부터 재개 |
| `/wrap` | 세션 마무리 + 학습 추출 + 다음 세션 인수인계 |

---

## 포함 안 된 것

의도적으로 제외했습니다.

| 제외 | 이유 |
|------|------|
| API 키·MCP 토큰 | 개인 보안 정보 |
| 세션 히스토리·로그 | 개인 대화 내용 |
| 개인 퍼소나·계정 | 계정 정보 포함 |
| 지역 검색·특정 서비스 스킬 | 범용성 없음 |
| 개인 프로젝트 맥락 | 진행 중인 과제·회사명 등 |

---

## 크레딧

- `plugins/clarify`, `plugins/session-wrap` — 번들 플러그인, `plugins/THIRD_PARTY_LICENSES.md` 참고
- `docs/조민-하네스.md` — 핵심 멘탈모델 10원칙 (조민 정리)
- `rules/follow-up-questions.md` — 꼬리질문 원칙

---

## 라이선스

MIT. 포크하고 본인 하네스로 발전시켜서 다시 공유해 주세요.

---

_2026-04-19_
