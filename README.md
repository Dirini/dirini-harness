# dirini-harness

> Claude Code를 **사고 도구**로 쓰기 위한 스킬, 훅, 지침 세트

"대화를 통해 발전하고, 자동화를 통해 시간을 벌고, 그 시간으로 더 큰 가치를 만든다."

`dirini-harness`는 제가 실제로 쓰던 Claude Code 환경에서,
공유해도 되는 부분만 떼어낸 공개용 하네스입니다.

- 세션이 끊겨도 다음 대화에서 바로 이어가기
- 인터뷰 기반으로 생각을 구조화하기
- 과제, 독후감, 에세이, 보고서를 내 방식으로 쓰기
- 중요 파일을 실수로 건드리지 않도록 훅으로 보호하기

API 키, 세션 로그, 개인 계정 정보, 프로젝트별 비밀 문맥은 제외했습니다.

---

## 누구에게 맞나?

이 레포는 특히 이런 분들에게 맞습니다.

- Claude Code를 단순 코딩 도구가 아니라 **사고 파트너**로 쓰고 싶은 사람
- 글쓰기 전에 질문, 인터뷰, 요약 과정을 먼저 거치고 싶은 사람
- 한국어 독후감, 에세이, 보고서, 자기소개 글 흐름을 Claude 안에 묶고 싶은 사람
- 매번 같은 작업 방식을 설명하지 않고 **하네스로 재사용**하고 싶은 사람

---

## 이 레포로 바로 얻는 것

| 얻는 것 | 어떻게 해결하나 |
|---------|----------------|
| 세션 연속성 | `checkpoint`, `resume`, `session-start-guide.sh` |
| 요구사항 명확화 | `clarify`, `interview`, `follow-up-questions.md` |
| 글쓰기 워크플로우 | `assignment-brainstorming`, `assignment-planning`, `style-learning`, `copywriting`, `korean-spell-check` |
| 작업 안전장치 | `guard-protected-files.sh`, `post-tool-format.sh` |
| 생각의 기준점 | `CLAUDE.md`, `docs/조민-하네스.md` |

---

## 한 번에 이해하기

| 컴포넌트 | 역할 | 호출 방식 |
|----------|------|-----------|
| `CLAUDE.md` | 전역 지침. Guardrails, 워크플로우, 소통 규칙 | 자동 로딩 |
| `skills/assignment-brainstorming` | 과제형 글쓰기 브리프 정리 | `/assignment-brainstorming` |
| `skills/assignment-planning` | 과제형 글쓰기 개요 설계 | `/assignment-planning` |
| `skills/clarify` | 모호한 요청을 꼬리질문으로 명확화 | `/clarify` |
| `skills/interview` | 5-7라운드 깊이 인터뷰로 생각 정리 | `/interview` |
| `skills/checkinbox` | 인박스 자료를 점수화하고 학습 로그로 반영 | `/checkinbox` |
| `skills/checkpoint` | 긴 세션의 진행상황 저장 | `/checkpoint` |
| `skills/resume` | 다음 세션에서 중단 지점부터 재개 | `/resume` |
| `skills/copywriting` | 마케팅 카피 작성 | `/copywriting` |
| `skills/copy-editing` | 문장 편집과 다듬기 | `/copy-editing` |
| `skills/cover-letter` | 자기소개서 작성과 점수화 | `/cover-letter` |
| `skills/ux-writing` | UX 라이팅 | `/ux-writing` |
| `skills/korean-spell-check` | 맞춤법 교정 | `/korean-spell-check` |
| `skills/style-learning` | 기존 샘플 기반 말투 학습 | `/style-learning` |
| `skills/interview-script` | 인터뷰 스크립트 설계 | `/interview-script` |
| `skills/summarize-interview` | 인터뷰 내용을 구조화 요약 | `/summarize-interview` |
| `plugins/clarify` | 번들된 clarify 플러그인 | `/clarify` |
| `plugins/session-wrap` | 번들된 세션 마무리 플러그인 | `/wrap` |
| `hooks/guard-protected-files.sh` | 중요 파일 수정 차단 | PreToolUse |
| `hooks/post-tool-format.sh` | 포매팅과 diff 피드백 | PostToolUse |
| `hooks/session-start-guide.sh` | 세션 시작 시 미완료 작업 안내 | SessionStart |
| `agents/writing-intake.md` | 글쓰기 전 요구사항과 맥락 수집 | 필요 시 호출 |
| `agents/writing-orchestrator.md` | 전체 글쓰기 순서와 게이트 조율 | 필요 시 호출 |
| `agents/voice-profiler.md` | 기존 글 샘플에서 말투 규칙 추출 | 필요 시 호출 |
| `agents/background-researcher.md` | 자료와 배경정보 조사 | 필요 시 호출 |
| `agents/argument-architect.md` | 주장, 문단 구조, 근거 배치 설계 | 필요 시 호출 |
| `agents/draft-writer.md` | 조사된 근거 기반 초안 작성 | 필요 시 호출 |
| `agents/verification.md` | 코드 변경 후 검증 서브에이전트 | 필요 시 호출 |
| `agents/output-evaluator.md` | 결과물 품질 평가 서브에이전트 | 필요 시 호출 |
| `docs/조민-하네스.md` | 사고방식 10원칙 | 참고 문서 |

---

## 추천 워크플로우

### 1. 모호한 요청을 구조화할 때

`clarify` → `interview`

- 먼저 요청을 명확하게 쪼개고
- 필요한 경우 인터뷰로 더 깊게 파고들어
- 나중에 글쓰기나 실행 단계에서 흔들리지 않게 만듭니다

### 2. 과제형 글쓰기 품질을 끌어올릴 때

`assignment-brainstorming` → `style-learning` → `background-researcher` → `argument-architect` → `draft-writer` → `output-evaluator` → `korean-spell-check`

- 먼저 과제가 실제로 요구하는 것을 분명히 하고
- 내가 쓴 샘플에서 말투 규칙을 뽑고
- 배경지식과 암묵지를 늘릴 자료를 조사한 뒤
- 주장과 문단 구조를 설계하고
- 초안을 쓰고
- 독립적인 평가를 거쳐
- 마지막에 문장과 맞춤법을 정리합니다

### 2-1. 글쓰기 서브에이전트를 같이 쓸 때

`writing-orchestrator` → `writing-intake` → `voice-profiler` → `background-researcher` → `argument-architect` → `draft-writer` → `output-evaluator`

- 먼저 원하는 결과물, 독자, 톤, 제약을 확인하고
- 상위 orchestrator가 순서를 고정한 뒤
- 기존 샘플에서 말투를 명시적 기준으로 바꾼 다음
- 필요한 배경자료와 근거를 따로 모은 뒤
- 주장과 문단 순서를 먼저 설계하고
- 초안을 작성하고
- 마지막에 독립적인 평가 에이전트로 품질을 점검합니다

### 3. 긴 세션을 이어갈 때

`checkpoint` → 다음 날 `resume`

- 오늘 어디까지 했는지 남기고
- 다음 세션에서 다시 설명하지 않고 바로 이어갑니다

---

## 빠른 시작

### 1. 클론

```bash
git clone https://github.com/Dirini/dirini-harness.git
cd dirini-harness
```

### 2. 설치

```bash
./install.sh
```

`~/.claude/` 아래에 심볼릭 링크를 생성합니다. `git pull` 한 번으로 업데이트 반영.

> 기존에 `~/.claude/CLAUDE.md`가 있으면 자동으로 `.backup.날짜시간` 파일로 저장됩니다.

### 3. 훅 연결

`~/.claude/settings.json`에 아래를 추가하세요 (`settings.example.json` 참고):

```json
{
  "hooks": {
    "PreToolUse": [{"matcher": "Write|Edit", "hooks": [{"type": "command", "command": "~/.claude/hooks/guard-protected-files.sh"}]}],
    "PostToolUse": [{"matcher": "Write|Edit", "hooks": [{"type": "command", "command": "~/.claude/hooks/post-tool-format.sh"}]}],
    "SessionStart": [{"matcher": "*", "hooks": [{"type": "command", "command": "~/.claude/hooks/session-start-guide.sh"}]}]
  }
}
```

Claude Code 설정 파일을 직접 수정하거나, 기존 `settings.json`에 `hooks` 블록을 병합하면 됩니다.

---

## 번들된 플러그인과 워크플로우

이 레포에는 아래 구성이 이미 포함되어 있습니다.

### 1. 번들 플러그인

- `plugins/clarify`
- `plugins/session-wrap`

`./install.sh`를 실행하면 `~/.claude/plugins/` 아래에도 같이 연결됩니다.

바로 써볼 것:

- `/clarify`
- `/wrap`

### 2. superpowers 흡수 워크플로우

전체 superpowers 플러그인을 그대로 싣기보다,
과제형 글쓰기와 문서 작업에 실제로 필요한 핵심 흐름을 이 레포 안에 흡수했습니다.

- `assignment-brainstorming`: 글쓰기 전 브리프 설계
- `assignment-planning`: 개요와 논리 흐름 설계
- `style-learning`: 기존 샘플에서 말투를 학습해 명시적 기준으로 변환

추천 조합:

- 작업 시작 전: `clarify` 또는 `assignment-brainstorming`
- 말투 맞출 때: `style-learning` + `voice-profiler`
- 자료가 부족할 때: `background-researcher`
- 세션 끝날 때: `session-wrap`

---

## 설치 후 해야 할 3가지

### ① 본인 CLAUDE.md 완성

`~/.claude/CLAUDE.md` 상단에 "나는 누구인가" 섹션을 추가하세요. 이 파일이 Claude의 **전역 기억**입니다.

```markdown
## 나는 누구인가

| 항목 | 내용 |
|------|------|
| 직업 | 학생 / PM / 개발자 / 디자이너 |
| 관심 분야 | 기획, 개발, 글쓰기 ... |
| 목표 | ... |

## 현재 진행 중

- (지금 작업 중인 것)
```

### ② 도메인 매핑 튜닝 (선택)

`hooks/session-start-guide.sh` 안의 DOMAIN 매핑은 현재 예시 상태입니다.
본인 프로젝트 폴더 구조에 맞게 수정하거나, 환경변수로 지정:

```bash
export CLAUDE_PROJECT_ROOT="$HOME/projects/my-main-repo"
```

### ③ 조민 하네스 읽기

`docs/조민-하네스.md`에 10가지 멘탈모델이 있습니다.
특히 **"암묵지 → 명시지"** 와 **"판단의 해상도"** 개념은 CLAUDE.md를 어떻게 채울지 방향을 잡아줄 겁니다.

---

## 폴더 구조

```
dirini-harness/
├── CLAUDE.md                  ← ~/.claude/CLAUDE.md에 배치
├── install.sh                 ← 심볼릭 링크 설치 스크립트
├── settings.example.json      ← 훅 연결 예시
├── LICENSE
│
├── skills/
│   ├── assignment-brainstorming/ ← 과제형 글쓰기 브리프 설계
│   ├── assignment-planning/   ← 과제형 글쓰기 개요 설계
│   ├── checkinbox/            ← 인박스 트리아지 + 학습 로그
│   ├── checkpoint/            ← 세션 진행상황 저장
│   ├── clarify/               ← 꼬리질문으로 요구사항 명확화
│   ├── common/                ← 스킬 간 공유 원칙/템플릿
│   ├── copy-editing/          ← 문장 편집
│   ├── copywriting/           ← 마케팅 카피
│   ├── cover-letter/          ← 자기소개서
│   ├── interview/             ← 깊이 인터뷰
│   ├── interview-script/      ← 인터뷰 스크립트 설계
│   ├── korean-spell-check/    ← 맞춤법 교정
│   ├── resume/                ← 이전 세션 이어가기
│   ├── style-learning/        ← 샘플 기반 말투 학습
│   ├── summarize-interview/   ← 인터뷰 요약
│   └── ux-writing/            ← UX 라이팅
│
├── hooks/
│   ├── guard-protected-files.sh   ← 중요 파일 실수 수정 차단
│   ├── post-tool-format.sh        ← 포매팅 + diff 피드백
│   └── session-start-guide.sh     ← 세션 시작 안내
│
├── rules/
│   └── follow-up-questions.md     ← 꼬리질문 원칙
│
├── agents/
│   ├── background-researcher.md   ← 배경자료 조사
│   ├── argument-architect.md      ← 주장과 문단 구조 설계
│   ├── draft-writer.md            ← 초안 작성
│   ├── output-evaluator.md        ← 결과물 품질 평가 서브에이전트
│   ├── verification.md            ← 코드 검증 서브에이전트
│   ├── voice-profiler.md          ← 샘플 기반 말투 추출
│   ├── writing-orchestrator.md    ← 전체 글쓰기 순서 조율
│   └── writing-intake.md          ← 글쓰기 요구사항 정리
│
├── plugins/
│   ├── clarify/                   ← 번들된 clarify 플러그인
│   ├── session-wrap/              ← 번들된 session-wrap 플러그인
│   └── THIRD_PARTY_LICENSES.md    ← 서드파티 라이선스
│
├── templates/
│   └── handoff-template.md        ← 세션 인수인계 템플릿
│
└── docs/
    └── 조민-하네스.md              ← 핵심 멘탈모델 10원칙
```

---

## 포함 안 된 것

의도적으로 제외했습니다.

| 제외 항목 | 이유 |
|-----------|------|
| API 키·토큰·MCP 인증 | 개인 보안 정보 |
| 세션 히스토리 (`history.jsonl`, `sessions/`) | 개인 대화 내용 |
| 개인 퍼소나 (`personas/`) | 계정 정보 포함 |
| 개인 맥락 스킬 (지역 검색, 특정 서비스) | 범용성 없음 |
| full `superpowers` 플러그인 전체본 | 저장소를 과도하게 무겁게 만들 수 있음 |

---

## 함께 쓰면 좋은 것

이 레포는 단독으로도 쓸 수 있지만, 아래와 함께 쓰면 더 좋습니다.

- full `superpowers`: upstream 전체 워크플로우가 더 필요할 때
- 본인 프로젝트 전용 스킬: 회사 리서치, 도메인 분석, 내부 문서 요약 등

이 저장소에는 공개 가능한 공통 기반과 자주 쓰는 글쓰기 흐름만 담았습니다.

---

## 라이선스

MIT. 포크하고 본인 하네스로 발전시켜서 다시 공유해 주세요.

---

_마지막 업데이트: 2026-04-18_
