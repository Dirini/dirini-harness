#!/bin/bash
# PreToolUse Hook: Write|Edit 대상 파일이 보호 대상인지 검사
# 보호 대상: SKILL.md, rules/*.md, settings.json, CLAUDE.md

FILE_PATH="$CLAUDE_FILE_PATH"

# 파일 경로가 없으면 승인 (Write 시 새 파일일 수 있음)
if [ -z "$FILE_PATH" ]; then
  echo '{"decision": "approve"}'
  exit 0
fi

# ~ 를 홈 디렉토리로 확장
CLAUDE_DIR="$HOME/.claude"

# 보호 패턴 검사
BLOCKED=false
MATCHED_PATH=""

# 1. ~/.claude/skills/*/SKILL.md
if [[ "$FILE_PATH" =~ ^"$CLAUDE_DIR"/skills/[^/]+/SKILL\.md$ ]]; then
  BLOCKED=true
  MATCHED_PATH="$FILE_PATH"
fi

# 2. ~/.claude/rules/*.md
if [[ "$FILE_PATH" =~ ^"$CLAUDE_DIR"/rules/[^/]+\.md$ ]]; then
  BLOCKED=true
  MATCHED_PATH="$FILE_PATH"
fi

# 3. ~/.claude/settings.json
if [[ "$FILE_PATH" == "$CLAUDE_DIR/settings.json" ]]; then
  BLOCKED=true
  MATCHED_PATH="$FILE_PATH"
fi

# 4. ~/.claude/CLAUDE.md
if [[ "$FILE_PATH" == "$CLAUDE_DIR/CLAUDE.md" ]]; then
  BLOCKED=true
  MATCHED_PATH="$FILE_PATH"
fi

if [ "$BLOCKED" = true ]; then
  echo "{\"decision\": \"block\", \"reason\": \"Protected file: $MATCHED_PATH. Explicit user approval required.\"}"
else
  echo '{"decision": "approve"}'
fi

exit 0
