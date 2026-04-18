#!/bin/bash
# dirini-harness installer
# ~/.claude/ 아래에 심볼릭 링크를 생성합니다. git pull만으로 업데이트 반영 가능.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="$HOME/.claude"

echo "📦 dirini-harness installer"
echo "  repo: $REPO_ROOT"
echo "  target: $CLAUDE_HOME"
echo ""

# 디렉토리 보장
mkdir -p "$CLAUDE_HOME"/{skills,hooks,rules,templates,agents}

# 기존 CLAUDE.md 백업
if [ -f "$CLAUDE_HOME/CLAUDE.md" ] && [ ! -L "$CLAUDE_HOME/CLAUDE.md" ]; then
  BACKUP="$CLAUDE_HOME/CLAUDE.md.backup.$(date +%Y%m%d%H%M%S)"
  echo "⚠️  기존 CLAUDE.md를 $BACKUP 로 백업합니다."
  mv "$CLAUDE_HOME/CLAUDE.md" "$BACKUP"
fi

link_file() {
  local src="$1"
  local dst="$2"
  if [ -L "$dst" ]; then rm "$dst"; fi
  ln -s "$src" "$dst"
  echo "  ✓ $dst → $src"
}

link_dir_contents() {
  local src_dir="$1"
  local dst_dir="$2"
  for item in "$src_dir"/*; do
    [ -e "$item" ] || continue
    local name
    name="$(basename "$item")"
    link_file "$item" "$dst_dir/$name"
  done
}

echo "→ CLAUDE.md 링크 생성"
link_file "$REPO_ROOT/CLAUDE.md" "$CLAUDE_HOME/CLAUDE.md"

echo "→ skills/ 링크 생성"
link_dir_contents "$REPO_ROOT/skills" "$CLAUDE_HOME/skills"

echo "→ hooks/ 링크 생성"
link_dir_contents "$REPO_ROOT/hooks" "$CLAUDE_HOME/hooks"
chmod +x "$REPO_ROOT"/hooks/*.sh 2>/dev/null || true

echo "→ rules/ 링크 생성"
link_dir_contents "$REPO_ROOT/rules" "$CLAUDE_HOME/rules"

echo "→ templates/ 링크 생성"
link_dir_contents "$REPO_ROOT/templates" "$CLAUDE_HOME/templates"

echo "→ agents/ 링크 생성"
link_dir_contents "$REPO_ROOT/agents" "$CLAUDE_HOME/agents"

echo ""
echo "✅ 설치 완료"
echo ""
echo "다음으로 할 것:"
echo "  1. ~/.claude/settings.json 에 훅을 연결하세요 (settings.example.json 참고)"
echo "  2. CLAUDE.md 하단 템플릿을 참고해 '나는 누구인가' 섹션을 본인에 맞게 추가"
echo "  3. hooks/session-start-guide.sh 의 DOMAIN 매핑을 본인 프로젝트에 맞게 수정"
echo "     또는 export CLAUDE_PROJECT_ROOT=\"\$HOME/path/to/main\" 환경변수 설정"
