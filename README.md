# Claude 백업 저장소

Claude Code에서 만든 스킬과 md 파일을 백업하는 저장소입니다.

| 폴더 | 내용 |
|---|---|
| `global/` | `~/.claude/` 의 skills, agents, commands, CLAUDE.md |
| `memory/` | Claude 메모리 파일 (프로젝트별) |
| `projects/<작업폴더>/` | 작업 폴더 안의 `*.md` 파일과 `.claude/skills` |

백업 실행 (Git Bash):

```bash
bash ~/claude-backup/backup.sh
```

새 작업 폴더를 백업 대상에 넣으려면 `backup.sh` 의 `WORKDIRS` 목록에 경로를 추가하세요.
