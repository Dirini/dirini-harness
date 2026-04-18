---
name: wrap
description: 세션 마무리 + CONTEXT.md 업데이트 + 세션 파일 저장
argument-hint: (인자 없음)
allowed-tools: Read, Write, Bash, AskUserQuestion
disable-model-invocation: true
---

# Wrap Skill - 세션 마무리 및 구조화

세션을 체계적으로 마무리하고 다음 세션에서 바로 이어갈 수 있도록 준비합니다.

## 리소스 (Progressive Loading)

- **워크플로우**: `.agent/workflows/wrap.md` (상세 6단계 프로세스)

## Quick Reference

### 도메인별 저장 위치

| 도메인 | 피드백 저장 | 학습 저장 |
|--------|-----------|----------|
| Marketing | `.agent/skills/marketing/knowledge/improvement_log.md` | `marketing_patterns.md` |
| Education | `education/knowledge-base/` | `education/learning-log.md` |
| Career | `career/CONTEXT.md` | - |

### 출력 항목
- 완료한 작업 / 수정된 파일 / 피드백 내역 / 미완료 작업 / 인사이트

### 핵심 동작
1. CONTEXT.md 업데이트 (다음 세션 브리핑 포함)
2. sessions/session_YYYYMMDD_HHMM.md 저장
3. 후속 작업 우선순위 제안

## Gotchas (자주 발생하는 실수)

- ❌ **세션 파일만 저장하고 handoff를 안 남김** — 세션 파일은 아카이브용. 다음 세션에서 바로 쓸 수 있는 `handoff.md`를 프로젝트 루트에 별도 생성해야 함
- ❌ **과도한 분석으로 시간 낭비** — wrap은 5분 내로 끝내야 함. 깊은 분석보다 "무엇을 했고, 다음에 뭘 해야 하는지"에 집중
- ❌ **"정리"와 혼동** — 사용자가 "정리해줘"라고 하면 wrap이 아닐 수 있음. 코드 정리인지, 파일 정리인지, 세션 마무리인지 확인
- ❌ **미완료 작업을 빠뜨림** — git status, 열린 TODO, 진행 중 plan을 반드시 체크해서 누락 없이 기록
- ❌ **CONTEXT.md 덮어쓰기** — 기존 내용을 지우지 말고 업데이트. 이전 세션의 맥락이 사라지면 연속성이 깨짐

<instructions>
When invoked:
1. Read `.agent/workflows/wrap.md` for the complete 6-step process
2. Detect current domain (marketing/education/career)
3. Execute all steps: 세션 분석 → 피드백 로깅 → 학습 기록 → CONTEXT.md 업데이트 → 세션 파일 저장 → 후속 작업 제안
4. Save session file to `.agent/sessions/session_YYYYMMDD_HHMM.md`
$ARGUMENTS
</instructions>
