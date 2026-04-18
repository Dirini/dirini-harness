# dirini-harness

> 조민의 Claude Code 하네스(harness) — **사고 방식**과 **글쓰기 스킬**을 공유용으로 정리한 세트.

> "대화를 통해 발전하고, 자동화를 통해 시간을 벌고, 그 시간으로 더 큰 가치를 만든다."

Claude Code를 쓰면서 쌓아온 개인 워크플로우 중, 다른 사람에게 도움 될 법한 **공통 원칙 + 사고·글쓰기 스킬**만 뽑아낸 레포예요. API 키, 세션 로그, 특정 회사/프로젝트 맥락은 전부 제외했습니다.

---

## 📦 뭐가 들었나

### 1. 전역 지침 — `CLAUDE.md`
`~/.claude/CLAUDE.md`에 배치하는 글로벌 지침. 세션마다 Claude가 참고할 원칙.

- **Guardrails** (분석/실행 분리, 스킬 파일 보호, 진단 후 멈춤)
- **Workflow Conventions** (순차 처리, Context → Plan → Execute → Verify, 감을 숫자로 분해)
- **Verification 4단계** (구문 검증 → diff 확인 → 테스트 → 자기 리뷰)
- **소통 규칙**

### 2. 사고 스킬 — `skills/`

| 스킬 | 용도 |
|------|------|
| `clarify` | 모호한 요구사항을 객관식 꼬리질문으로 명확화 (3가지 모드) |
| `interview` | 5-7라운드 깊이 인터뷰로 스펙 문서 도출 |
| `checkinbox` | 인박스 콘텐츠 스코어링 → learning-log → 하네스 반영까지 닫힌 루프 |
| `checkpoint` / `resume` | 세션 연속성. 긴 세션 중 진행상황 저장 & 다음 세션에서 바로 이어가기 |
| `summarize-interview` | 인터뷰 답변을 구조화된 요약으로 정리 |
| `common` | 위 스킬들이 공유하는 원칙/템플릿 |

### 3. 글쓰기 스킬 — `skills/`

| 스킬 | 용도 |
|------|------|
| `copywriting` | 카피 기획·작성 |
| `copy-editing` | 문장 다듬기·편집 |
| `cover-letter` | 자기소개서 작성(7항목 100점 루브릭) |
| `resume` | 이력서 작성·최적화 |
| `ux-writing` | UX 라이팅 |
| `korean-spell-check` | 국립국어원 기준 맞춤법 교정 |
| `interview-script` | 사용자 인터뷰 스크립트 설계 |

### 4. 규칙 — `rules/follow-up-questions.md`
꼬리질문 원칙. "모호한 요청 감지 → clarify 3종 모드 자동 선택" 로직.

### 5. 훅 — `hooks/`

| 훅 | 동작 |
|------|------|
| `guard-protected-files.sh` (PreToolUse) | skills/rules/settings.json/CLAUDE.md 수정 시 자동 차단 |
| `post-tool-format.sh` (PostToolUse) | Write/Edit 후 자동 포매팅 + git diff 피드백 |
| `session-start-guide.sh` (SessionStart) | 이전 세션 미완료 확인 + 도메인별 스킬 가이드 주입 |

> ⚠️ `session-start-guide.sh`는 본인 프로젝트 구조에 맞게 **DOMAIN 매핑을 수정**하세요. `CLAUDE_PROJECT_ROOT` 환경변수로 메인 프로젝트 경로를 지정할 수 있습니다.

### 6. 서브에이전트 — `agents/`

| 에이전트 | 역할 |
|------|------|
| `verification` | 코드 변경 후 자동 검증 (git diff, 구문 체크, 보안 스캔, 테스트) |
| `output-evaluator` | 분석/요약 결과물 품질 평가 (Generator-Evaluator 분리 원칙) |

### 7. 템플릿 — `templates/handoff-template.md`
세션 간 인수인계 문서 템플릿.

### 8. 사고방식 문서 — `docs/조민-하네스.md`
핵심 멘탈모델 10가지(주체성, 암묵지→명시지, Unknown Unknowns, 복리 성장, 판단의 해상도, 시스템 사고 등).

---

## 🚀 설치

### 방법 A — 자동 설치 스크립트 (권장)

```bash
git clone https://github.com/<your-github>/dirini-harness.git
cd dirini-harness
./install.sh
```

설치 스크립트는 `~/.claude/` 아래에 **심볼릭 링크**를 만들어요. 레포 업데이트(`git pull`)만으로 바로 반영됩니다.

### 방법 B — 수동 복사

```bash
# 전역 지침
cp CLAUDE.md ~/.claude/CLAUDE.md

# 스킬
cp -R skills/* ~/.claude/skills/

# 훅
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# 규칙 · 템플릿 · 에이전트
mkdir -p ~/.claude/rules ~/.claude/templates ~/.claude/agents
cp rules/* ~/.claude/rules/
cp templates/* ~/.claude/templates/
cp agents/* ~/.claude/agents/
```

### 설치 후 해야 할 것

1. `~/.claude/settings.json`에 훅 연결 — 레포의 [`settings.example.json`](./settings.example.json) 참고
2. 본인 상황에 맞게 `~/.claude/CLAUDE.md` 상단에 "나는 누구인가" 섹션 추가 (템플릿은 CLAUDE.md 하단에 있음)
3. `hooks/session-start-guide.sh`의 DOMAIN 매핑을 본인 프로젝트 구조로 수정 (또는 `export CLAUDE_PROJECT_ROOT=...` 환경변수로 메인 프로젝트 경로 지정)

---

## 🔐 포함되지 않은 것

아래는 개인 정보라 **일부러 뺐습니다**:

- API 키, OAuth 토큰, MCP 인증 캐시
- 세션 히스토리 (`sessions/`, `projects/`, `history.jsonl`, `telemetry/`)
- 개인 퍼소나 (`personas/dirini/`)
- 개인 프로젝트 맥락 (진행 중인 자소서, 인박스 백로그 등)
- 개인용 스킬 (독후감, 지역 검색, 커리어 전용 등 180개 중 공개 가치 있는 13개만 선별)

원한다면 본인 버전에 맞춰 확장하고 다시 공유하세요.

---

## ⚠️ 크레딧 확인 필요

아래 스킬들은 원본이 `~/.agents/skills/`를 가리키는 심볼릭 링크였습니다. 외부 스킬 팩에서 설치된 것일 가능성이 있으므로, 공개 전 원저자/라이선스를 확인하고 크레딧을 추가하세요:

- `skills/clarify`
- `skills/copywriting`
- `skills/interview-script`
- `skills/korean-spell-check`
- `skills/summarize-interview`
- `skills/ux-writing`

본인이 직접 작성한 스킬이면 무시해도 됩니다. 외부 출처가 확인되면 이 섹션을 해당 출처 링크로 바꿔주세요.

참고: `clarify`, `session-wrap`, `superpowers` 같은 플러그인은 이 repo에 포함하지 않았습니다. 각 마켓플레이스에서 별도 설치하세요(Claude Code `/plugins install`).

## 📄 License

MIT. 자유롭게 포크하고 본인 하네스에 맞게 수정하세요.

---

_마지막 업데이트: 2026-04-18_
