---
name: checkinbox
description: Check and process learning materials from iCloud ai-inbox folder. MUST use this skill whenever the user says anything about inbox, checking inbox, inbox 확인, inbox 정리, 새 자료, new materials, learning materials, 자료 처리, 오늘 inbox, or wants to review recently saved articles/links/content. Also trigger when user mentions iCloud inbox, ai-inbox folder, or asks what new content has arrived. This is the primary skill for inbox triage and learning material processing.
---

# Check Inbox — Inbox 확인 및 학습 자료 처리

iCloud ai-inbox 폴더의 새 자료를 깊이 이해하고, 학습 자료로 정리합니다.

## Triggers

- `/checkinbox`
- "inbox 확인", "inbox 정리", "새 자료 확인", "오늘 inbox"

## 핵심 원칙

- **이해 우선**: "뭘 해야 해?"보다 **"이게 무슨 내용이야?"**가 먼저
- **커뮤니티 맥락**: Reddit/Threads는 **댓글이 본문만큼 중요** (합의, 반론, 실전 팁)
- **플랫폼 현실주의**: X(Twitter)는 **로그인 없이 본문까지만** 수집한다. 답글/대화는 인증이 있을 때만 시도한다
- **품질 기준**: `learning-log.md`의 2026-02-05 엔트리 수준을 최소 기준으로
- **순차 처리**: 항목을 한 번에 하나씩 처리 (Guardrails 준수)

## Steps

### 0. 이전 액션 리뷰 (닫힌 루프)

`learning-log.md`의 마지막 엔트리에서 **"바로 실행할 액션"** 체크박스를 확인한다.
- `[ ]` 미실행 항목이 있으면 목록을 보여주고 "실행/스킵/연기" 선택을 요청
- 전부 `[x]`이면 건너뛴다
- 이 단계는 30초 내에 끝낸다 — 길게 끌지 않는다

### 1. Inbox 파일 수집 + 우선순위 스코어링

iCloud inbox 폴더에서 새 파일 확인 (양쪽 폴더 모두):
```bash
ls -lt ~/Library/Mobile\ Documents/com~apple~CloudDocs/ai-inbox/com~apple~CloudDocs/
ls ~/Library/Mobile\ Documents/com~apple~CloudDocs/ai-inbox/
```

파일 날짜는 `stat -f "%Sm" -t "%Y-%m-%d"` 로 추출, 설명은 og:description 우선 추출.

새 파일이 있으면 제목/URL을 추출하고, 각 항목에 **우선순위 점수(10점 만점)**를 매긴다:

| 기준 | 배점 | 설명 |
|------|------|------|
| 도메인 연관성 | 4점 | 현재 진행 중인 과제/프로젝트와 직접 관련 |
| 실행 가능성 | 3점 | 읽고 나서 바로 뭔가 만들거나 바꿀 수 있는가 |
| 시의성 | 2점 | 지금 안 보면 가치가 떨어지는가 (신규 도구 출시 등) |
| 출처 신뢰도 | 1점 | 검증된 저자/공식 채널인가 |

**결과 표 형식** (조민 판단해상도 — 암묵적 판단을 숫자+이유로 명시화):

| # | 날짜 | 항목 | 플랫폼 | 설명(70자) | 점수 | 추천 | 반영 이유 |
|---|------|------|--------|-----------|------|------|----------|
| 1 | YYYY-MM-DD | 항목명 | YouTube | 설명... | 10 | ★★★ 즉시 | [원칙]: 한 문장 근거 |

**추천 등급**:
- ★★★ 즉시 (8-10점): 지금 반영 안 하면 복리 효과 놓침
- ★★ 일반 (4-7점): 다음 세션 처리 가능
- ★ 스킵 (0-3점): 사용자 확인 후 결정

**반영 이유 원칙 레이블** (조민 10원칙에서):
- `복리`: 하네스/스킬에 통합 시 매 세션 자동 적용 → 지수 효과
- `명시지`: 암묵적 판단 기준을 수치/구조로 꺼낼 수 있음
- `판단해상도`: 구체적 수치(성능, 비용, 정확도)로 선택 기준 확보
- `구조화`: 패턴을 스킬/훅/CLAUDE.md로 인코딩 → 재사용 구조 확보
- `시스템`: 정답 찾기가 아닌 학습하는 구조로 전환
- `Fogg`: 읽고 바로 실행 가능 (능력↑ + 트리거 명확)

점수 + 반영 이유와 함께 정렬된 목록을 사용자에게 보여주고, 처리 순서를 확인받는다.

### 1.5. ★★★ 항목 → 즉시 적용 제안 (닫힌 루프)

스코어링 후, **★★★(8-10점) 항목**에 대해 분석 완료 직후 구체적 적용 방안을 제안한다.
로그 기록에서 끝내지 않는다 — **학습이 하네스 변경으로 이어져야 복리가 돈다.**

**제안 형식**:
```
## 적용 제안 (★★★ 항목)

| 항목 | 적용 대상 | 변경 내용 | 반영 이유 |
|------|----------|----------|----------|
| agentmemory | ~/.claude/ 설치 | npx + plugin install | 복리: 12훅 자동 캡처 → 세션 기억 영속화 |
| 서브에이전트 패턴 | .claude/agents/ 신규 파일 | verification-evaluator.md 생성 | 구조화: Generator-Evaluator 분리 물리적 구현 |
```

- 파일 생성/수정은 **사용자 승인 후** 실행 (Guardrails 준수)
- 터미널 명령 실행이 필요한 항목은 정확한 커맨드를 제시하고 멈춘다
- 승인 받은 항목만 즉시 실행, 나머지는 learning-log 액션 체크박스로 이동

### 2. 자료 수집 스크립트 실행 (프로젝트 디렉토리에 있을 때)

```bash
# 프로젝트에 수집 스크립트가 있을 때 (경로는 본인 프로젝트에 맞게 수정)
./scripts/process-inbox-urls.sh
```

프로젝트 외부에서 실행 시: 수동으로 URL을 하나씩 WebFetch/브라우저로 처리한다.

**PDF 파일 감지 시** (`*.pdf` in inbox): `/pdf-to-obsidian` 스킬로 분기. markitdown 변환 → Obsidian Vault 라우팅 → learning-log 엔트리 초안까지 자동 연결.

### 3. 플랫폼별 딥 추출

| 플랫폼 | 감지 패턴 | 추출 방법 | 댓글 처리 |
|--------|----------|----------|----------|
| **YouTube** | `youtube.com`, `youtu.be` | `/tmp/youtube_transcripts/` 자막 읽기 | - |
| **X(Twitter)** | `x.com`, `twitter.com` | 저장 HTML에서 원본 URL 추출 → browser 본문-only | 기본 비활성화 (`auth 필요`) |
| **Reddit** | `reddit.com` | `/tmp/reddit_fetched/` 사전수집 결과 읽기 | 상위 30개 댓글 + 대댓글 |
| **Threads** | `threads.net` | `/tmp/threads_resolved/` 결과 읽기 → WebFetch → browser | 답글 15-20개 |
| **LinkedIn** | `linkedin.com` | WebFetch → browser | - |
| **웹 아티클** | 기타 URL | WebFetch (Jina Reader) | - |
| **PDF 파일** | `*.pdf` (inbox 내) | `/pdf-to-obsidian` 호출 → markitdown → Vault `4. AI 학습/03 원본/` | - |

### 4. 항목별 깊은 분석 (순차 처리)

각 콘텐츠에 대해 **하나씩** 분석:

#### 4.1 콘텐츠 이해
- 핵심 주장/아이디어는?
- 어떤 문제를 다루는가?
- 제시된 해결책/접근법은?

#### 4.2 핵심 개념 추출
- 3-5개 핵심 개념, 각각 2-4문장 설명
- "왜 중요한지" 포함

#### 4.3 커뮤니티 시그널 (Reddit/Threads만, X는 인증 있을 때만)
- **합의점** / **반론** / **실전 팁** / **논쟁 포인트**

#### 4.4 내 AI 생태계 연결
- 현재 AI 활용 방식과의 연결
- 기존 학습과의 관계 (`learning-log.md` 참조)
- 적용 가능한 프로젝트/워크플로우

#### 4.5 액션 도출
- **지금 바로 실행 가능한** 구체적 행동 2-3개
- 파일명/명령어/도구까지 특정하는 수준

### 5. 결과 기록

`education/learning-log.md`에 기록 (프로젝트 디렉토리 기준):

```markdown
### YYYY-MM-DD: [설명적 주제명]

**카테고리**: `#tag1` `#tag2` `#tag3`

#### 학습한 것

**1. [개념명] ([플랫폼] - [작성자/출처])**
- [핵심 내용 2-4문장. 왜 중요한지 포함]
- 출처: [URL]

#### 커뮤니티 인사이트 (Reddit/Threads만)
- **합의점**: [대다수 동의]
- **반론/주의점**: [반대 의견이나 경고]
- **실전 팁**: [유용한 팁]

#### 바로 실행할 액션
- [ ] **Action 1**: [구체적 작업 — 파일명/명령어 수준]
- [ ] **Action 2**: [구체적 작업]

#### 인사이트
- **[원칙명]**: [범용적으로 적용 가능한 원칙, 한 문장]

#### 참고 링크
- [제목](URL)
```

### 5.5. Obsidian 개념 노트 업데이트 (Karpathy Ingest)

learning-log 기록 후, 해당 엔트리의 `#tag`를 Obsidian 개념 사전과 매칭:

| learning-log 태그 | Obsidian 개념 노트 |
|-------------------|-------------------|
| `#harness-engineering` | `4. AI 학습/01 개념 사전/하네스 엔지니어링.md` |
| `#claude-code`, `#hooks`, `#mcp` | `4. AI 학습/01 개념 사전/Claude Code 생태계.md` |
| `#agent-architecture` | `4. AI 학습/01 개념 사전/에이전트 아키텍처.md` |
| `#skills`, `#plugins` | `4. AI 학습/01 개념 사전/스킬과 플러그인.md` |
| `#knowledge-management`, `#cmds` | `4. AI 학습/01 개념 사전/지식 관리.md` |
| `#marketing`, `#content`, `#aieo` | `4. AI 학습/01 개념 사전/마케팅과 콘텐츠.md` |
| `#career`, `#growth` | `4. AI 학습/01 개념 사전/커리어와 성장.md` |

**업데이트 절차** (매칭되는 노트가 있을 때만):
1. 해당 개념 노트의 `## 소스 엔트리`에 새 learning-log 엔트리 추가
2. `source_count` frontmatter +1
3. `last_compiled` 날짜 갱신
4. 새 내용이 기존 `## 상세 내용`에 추가할 만큼 중요하면 → 통합 (append 아님, merge)
5. 새 태그가 기존 7개 개념에 없으면 → "새 개념 노트 생성을 제안할까요?" (사용자 확인)

> Karpathy 원칙: "하나의 소스가 wiki 10-15페이지를 업데이트할 수 있다"

**이 단계는 자동 실행한다** — learning-log 기록이 승인되면 Obsidian 업데이트도 함께 진행.

### 6. 품질 자동 검증 (Autoresearch 패턴)

각 항목의 분석 결과를 기록하기 **전에** 아래 체크리스트로 자동 점수를 매긴다.
Y/N으로 판단하고, 통과 기준은 **5/6 이상**.

| # | 체크 항목 | 판단 기준 |
|---|----------|----------|
| 1 | 출처가 명시되어 있는가? | 플랫폼명 + 작성자/채널명 + URL 모두 포함 |
| 2 | "왜 중요한지"가 설명되어 있는가? | 각 핵심 개념에 중요성/임팩트가 1문장 이상 |
| 3 | 커뮤니티 반응이 포함되어 있는가? | Reddit/Threads면 합의/반론/실전팁 중 2개 이상 |
| 4 | 액션이 즉시 실행 가능한가? | 파일명/명령어/도구까지 특정된 수준 |
| 5 | 내 AI 생태계와 연결되어 있는가? | 현재 스킬/MCP/워크플로우와 구체적 연결점 1개 이상 |
| 6 | 학습한 것이 전체의 60% 이상인가? | 분석 결과에서 가장 긴 섹션이 학습 내용 |

**자동 개선 루프:**
1. 점수가 5/6 미만이면 실패한 항목만 보강하고 재점수
2. 최대 2라운드까지 반복 (3라운드째는 현재 상태로 확정)
3. 점수와 함께 결과를 사용자에게 보여준 후, 확인받고 기록 진행

## Gotchas (자주 발생하는 실수)

### 콘텐츠 추출 우선순위 (Fallback Chain)

모든 URL에 대해 아래 순서로 시도한다. 성공하면 다음 단계로 넘어가지 않는다:

```
1. HTML 파일 내 메타데이터 (title, og:description, JSON-LD)
2. WebFetch (Jina Reader) — LinkedIn, 블로그, 웹 아티클에 효과적
3. exa.ai 검색 (mcp__exa__web_search_exa) — URL이나 키워드로 원본 텍스트 검색
4. Playwright (browser_navigate → browser_snapshot) — JS 렌더링 필수 시
```

### 플랫폼별 주의사항

- ✅ **X(Twitter) 포스트는 로그인 없이 본문-only 수집** — 저장 HTML에서 원본 `x.com/.../status/...` URL을 먼저 추출하고, browser로 공개 본문만 읽는다. 답글/대화는 기본 시도하지 않는다
- ❌ **X(Twitter) 답글은 인증 없으면 불안정** — 공개 본문은 읽혀도 reply thread는 잘 안 열린다. 출력에 `수집 방식: body-only (no auth)` 와 `답글: auth 필요`를 명시할 것
- ❌ **Threads/Reddit HTML은 JS 렌더링** — WebFetch로 텍스트 추출 불가. 먼저 HTML 내 `<title>`과 og:description 추출 → 부족하면 exa.ai → 그래도 안 되면 Playwright
- ❌ **HTML 파일이 500KB+여도 실제 콘텐츠는 몇 줄** — Threads/LinkedIn 공유 페이지는 CSS/JS가 대부분. 메타태그만 먼저 추출
- ❌ **Threads 포스트에 링크된 외부 리소스가 진짜 콘텐츠** — 포스트 자체는 요약문일 뿐. Google Drive PDF, 블로그 링크 등을 반드시 추적해서 원본을 가져올 것
- ❌ **Google Drive PDF는 WebFetch로 내용 추출 불가** — `curl -L` 으로 다운로드 후 Read 도구로 페이지별 읽기
- ❌ **com~apple~CloudDocs 하위 폴더도 체크** — inbox 파일이 메인 폴더와 `com~apple~CloudDocs/` 서브폴더 두 곳에 나뉘어 저장됨
- ❌ **learning-log.md 마지막 처리 날짜를 반드시 확인** — 백로그가 몇 주치 쌓여있을 수 있음. 최신 것부터 역순으로 처리
- ❌ **Playwright MCP가 끊길 수 있음** — "Target page, context or browser has been closed" 에러 시 WebFetch/exa.ai로 즉시 전환. Playwright 재시작 시도하지 않음

### X(Twitter) 전용 처리 규칙

1. 저장 HTML에서 `x.com/.../status/...` 또는 `twitter.com/.../status/...` 원본 URL을 먼저 찾는다
2. 원본 URL이 있으면 browser로 열어 **본문만** 수집한다
3. 본문만 수집한 경우 결과에 `수집 방식: body-only (no auth)` 를 반드시 적는다
4. 답글/대화는 `auth 필요`로 표시하고 기본 스킵한다
5. 원본 URL이 없으면 저장 HTML 메타데이터 + 본문 일부만 활용하고, `원본 URL 복원 실패`를 명시한다

### 7. /compile 제안 (Karpathy Flywheel)

learning-log 기록이 완료된 후:
- 마지막 `/compile` 이후 **새 엔트리 5개 이상** 쌓였으면 → `/compile` 실행 제안
- `/compile`은 learning-log → Obsidian 개념 사전 전체 재컴파일 (Step 5.5보다 깊은 통합)
- **제안 형식**: "새 엔트리 N개가 쌓였습니다. `/compile`로 개념 사전을 업데이트할까요?"
- 이 단계는 **제안만** 한다 (Guardrails 준수)

## Important

- `학습한 것` 섹션이 **가장 길고 상세해야** 함 (전체의 60% 이상)
- Action은 2-3개로 **엄선** (많으면 실행 안 함)
- 인사이트는 해당 콘텐츠를 넘어서 **범용적으로 적용 가능한 원칙**
- 분석 결과를 먼저 보여주고, 사용자 확인 후 기록 진행 (Guardrails 준수)
