#!/bin/bash
# Session Start Guide Hook
# 세션 시작 시 도메인별 스킬 가이드 + 이전 세션 resume 힌트를 additionalContext로 주입
#
# ┌──── 사용자 튜닝 포인트 ────────────────────────────────────────┐
# │ CLAUDE_PROJECT_ROOT 환경변수로 메인 프로젝트 경로를 넘겨주세요.  │
# │ 예: export CLAUDE_PROJECT_ROOT="$HOME/projects/my-main-repo"    │
# │ 이 아래 DOMAIN 매핑(marketing/education/career)은 예시입니다.    │
# │ 본인 프로젝트 구조에 맞게 수정하세요.                            │
# └─────────────────────────────────────────────────────────────────┘

PROJECT_ROOT="${CLAUDE_PROJECT_ROOT:-$HOME/projects/my-project}"

# Claude Code는 프로젝트별 메모리를 ~/.claude/projects/<slug>/ 아래에 저장합니다.
# slug는 홈 경로의 '/'를 '-'로 치환한 값 (예: /Users/alice → -Users-alice).
HOME_SLUG=$(echo "$HOME" | sed 's|/|-|g')
PROGRESS_FILE="$HOME/.claude/projects/${HOME_SLUG}/memory/session-progress.md"
CWD=$(pwd)

# --- 이전 세션 미완료 작업 체크 ---
RESUME_HINT=""
if [ -f "$PROGRESS_FILE" ]; then
  # 마지막 세션 블록에서 미완료 plan이 있는지 확인
  LAST_SESSION=$(tail -20 "$PROGRESS_FILE")
  if echo "$LAST_SESSION" | grep -q "incomplete_plans:"; then
    PLANS=$(echo "$LAST_SESSION" | grep "incomplete_plans:" | head -1 | sed 's/.*incomplete_plans: //')
    if [ -n "$PLANS" ] && [ "$PLANS" != "none" ]; then
      RESUME_HINT="이전 세션에 미완료 작업이 있습니다: $PLANS → \`/continue\`로 이어서 진행할 수 있습니다."
    fi
  fi
  # 마지막 작업 도메인 확인
  LAST_DOMAIN=$(echo "$LAST_SESSION" | grep "domain:" | tail -1 | sed 's/.*domain: //')
fi

# --- HANDOFF.md 체크 (CWD 우선, PROJECT_ROOT fallback) ---
HANDOFF_BLOCK=""
HANDOFF_PATH=""
if [ -f "$CWD/HANDOFF.md" ]; then
  HANDOFF_PATH="$CWD/HANDOFF.md"
elif [ -f "$PROJECT_ROOT/HANDOFF.md" ]; then
  HANDOFF_PATH="$PROJECT_ROOT/HANDOFF.md"
fi

if [ -n "$HANDOFF_PATH" ]; then
  SIZE=$(wc -c < "$HANDOFF_PATH")
  if [ "$SIZE" -le 10000 ]; then
    HANDOFF_BODY=$(cat "$HANDOFF_PATH")
    HANDOFF_BLOCK=$'\n\n[HANDOFF from '"$HANDOFF_PATH"$']\n'"$HANDOFF_BODY"
  else
    HANDOFF_BODY=$(head -80 "$HANDOFF_PATH")
    HANDOFF_BLOCK=$'\n\n[HANDOFF from '"$HANDOFF_PATH"' — head 80줄만 표시, 전체는 직접 Read]\n'"$HANDOFF_BODY"
  fi
fi

# --- 도메인 감지 ---
DOMAIN="general"
if [[ "$CWD" == *"$PROJECT_ROOT/marketing"* ]]; then
  DOMAIN="marketing"
elif [[ "$CWD" == *"$PROJECT_ROOT/education"* ]]; then
  DOMAIN="education"
elif [[ "$CWD" == *"$PROJECT_ROOT/career"* ]]; then
  DOMAIN="career"
elif [[ "$CWD" == "$PROJECT_ROOT"* ]]; then
  DOMAIN="project-root"
fi

# --- 도메인별 스킬 가이드 ---
case "$DOMAIN" in
  marketing)
    SKILLS="/write-blog /repurpose /context-headline /marketing-review"
    ;;
  education)
    SKILLS="/check-inbox /learn /apply"
    ;;
  career)
    SKILLS="/resume-optimize /mock-interview /portfolio-review"
    ;;
  project-root)
    SKILLS="/check-inbox /learn /write-blog /clarify"
    ;;
  *)
    SKILLS=""
    ;;
esac

COMMON="/wrap /clarify /interview"

# --- 출력 (additionalContext) ---
OUTPUT=""

if [ -n "$RESUME_HINT" ]; then
  OUTPUT="[Session Guide] $RESUME_HINT"
fi

if [ -n "$SKILLS" ]; then
  if [ -n "$OUTPUT" ]; then
    OUTPUT="$OUTPUT | "
  fi
  OUTPUT="${OUTPUT}[${DOMAIN} domain] 추천 스킬: ${SKILLS} | 공통: ${COMMON}"
elif [ -n "$RESUME_HINT" ]; then
  OUTPUT="${OUTPUT} | 공통 스킬: ${COMMON}"
fi

if [ -n "$OUTPUT" ] || [ -n "$HANDOFF_BLOCK" ]; then
  echo "${OUTPUT}${HANDOFF_BLOCK}"
fi
