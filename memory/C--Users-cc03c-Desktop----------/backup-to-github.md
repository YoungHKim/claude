---
name: backup-to-github
description: 새로 만든 스킬·md 파일은 GitHub 저장소 YoungHKim/claude 로 주기적으로 백업해야 함
metadata:
  node_type: memory
  type: feedback
  originSessionId: 04c348ed-3986-4107-90be-84531edda0f0
  modified: 2026-11-05T06:06:57.142Z
---

사용자는 앞으로 생성되는 스킬과 md 파일을 https://github.com/YoungHKim/claude 에 백업하길 원함 (2026-11-05 지시).

**Why:** 사용자가 직접 요청한 백업 정책. 스킬/문서를 잃지 않으려는 목적.

**How to apply:** 스킬이나 md 파일을 만들거나 수정하는 작업을 마치면 `bash ~/claude-backup/backup.sh` 를 실행해 commit+push 한다. 로컬 클론은 `C:\Users\cc03c\claude-backup`. 새 작업 폴더에서 작업하면 스크립트의 `WORKDIRS` 배열에 그 경로를 추가한다. SessionEnd 훅도 이 스크립트를 자동 실행하도록 설정돼 있다(`~/.claude/settings.json`).
