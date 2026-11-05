#!/usr/bin/env bash
# Claude 스킬 / md 파일 백업 스크립트
# 사용법: bash ~/claude-backup/backup.sh   (Git Bash)
# 원본 위치의 skills 폴더와 *.md 파일을 이 저장소로 복사한 뒤, 변경이 있으면 commit + push 합니다.
set -u
REPO="$HOME/claude-backup"
CLAUDE="$HOME/.claude"
# 백업할 작업 폴더 목록 (새 작업 폴더가 생기면 여기에 추가)
WORKDIRS=(
  "$HOME/Desktop/클로드코드 테스트"
)

cd "$REPO" || exit 1
git pull --quiet --rebase 2>/dev/null

# 미러링: 기존 백업본을 지우고 다시 복사 (삭제 이력은 git에 남음)
rm -rf global memory projects

copy_md_tree() { # $1=원본 폴더  $2=저장소 내 대상 폴더
  local src="$1" dst="$2"
  [ -d "$src" ] || return 0
  ( cd "$src" && find . \( -name node_modules -o -name .git \) -prune -o \
      \( -name '*.md' -o -path '*/skills/*' \) -type f -print ) |
  while IFS= read -r f; do
    mkdir -p "$dst/$(dirname "$f")"
    cp "$src/$f" "$dst/$f"
  done
}

# 1) 전역 스킬, 전역 CLAUDE.md, 에이전트, 커맨드
[ -d "$CLAUDE/skills" ]   && mkdir -p global && cp -r "$CLAUDE/skills" global/
[ -d "$CLAUDE/agents" ]   && mkdir -p global && cp -r "$CLAUDE/agents" global/
[ -d "$CLAUDE/commands" ] && mkdir -p global && cp -r "$CLAUDE/commands" global/
[ -f "$CLAUDE/CLAUDE.md" ] && mkdir -p global && cp "$CLAUDE/CLAUDE.md" global/

# 2) 메모리 파일
for m in "$CLAUDE"/projects/*/memory; do
  [ -d "$m" ] || continue
  name="$(basename "$(dirname "$m")")"
  mkdir -p "memory/$name" && cp -r "$m"/. "memory/$name/"
done

# 3) 작업 폴더의 *.md 와 .claude/skills
for w in "${WORKDIRS[@]}"; do
  copy_md_tree "$w" "projects/$(basename "$w")"
done

git add -A
if git diff --cached --quiet; then
  echo "변경 없음 - 백업할 내용이 없습니다."
  exit 0
fi
git commit --quiet -m "백업: $(date '+%Y-%m-%d %H:%M')

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push --quiet -u origin HEAD:main && echo "백업 완료 및 push 성공"
