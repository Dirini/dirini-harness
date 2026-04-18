#!/bin/bash
# PostToolUse Hook: Write|Edit 후 자동 포매팅
# Boris Best Practice — 코드 작성과 포매팅을 분리

FILE_PATH="$CLAUDE_FILE_PATH"

# 파일이 없으면 종료
[ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ] && exit 0

EXT="${FILE_PATH##*.}"

case "$EXT" in
  js|ts|jsx|tsx|json|md|markdown)
    # deno fmt이 설치되어 있으면 사용
    if command -v deno &>/dev/null; then
      deno fmt --quiet "$FILE_PATH" 2>/dev/null
    fi
    ;;
  sh|bash|zsh)
    # Shell 파일: trailing newline 보장
    if [ -s "$FILE_PATH" ] && [ "$(tail -c 1 "$FILE_PATH" | wc -l)" -eq 0 ]; then
      echo "" >> "$FILE_PATH"
    fi
    ;;
esac

# Git diff 피드백 — git repo 안의 파일이면 변경 요약 출력
if git -C "$(dirname "$FILE_PATH")" rev-parse --is-inside-work-tree &>/dev/null; then
  DIFF_STAT=$(git -C "$(dirname "$FILE_PATH")" diff --stat -- "$FILE_PATH" 2>/dev/null)
  if [ -n "$DIFF_STAT" ]; then
    echo "[diff] $DIFF_STAT"
  fi
fi

exit 0
