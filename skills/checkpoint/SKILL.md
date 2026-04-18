# Checkpoint — 진행상황 저장

세션 중간에 현재까지의 작업 진행상황을 파일로 저장한다.
rate limit이나 중단에 대비하여 다음 세션에서 `/resume`으로 이어갈 수 있게 한다.

## Triggers

- `/checkpoint`
- "저장해줘", "체크포인트", "진행상황 저장", "checkpoint"

## Steps

1. **현재 상태 파악** — 이번 세션에서:
   - 완료한 작업 목록
   - 진행 중인 작업과 현재 단계
   - 아직 시작하지 않은 남은 작업

2. **진행상황 파일 작성** — `~/.claude/projects/<home-slug>/memory/session-progress.md`에 저장 (home-slug는 홈 경로의 `/`를 `-`로 치환한 값, 예: `/Users/alice` → `-Users-alice`):
   ```markdown
   # Session Progress — {날짜 시간}
   ## Working Directory
   {현재 디렉토리}
   ## Completed
   - [x] 작업1
   - [x] 작업2
   ## In Progress
   - [ ] 작업3 — {현재 단계 설명}
   ## Remaining
   - [ ] 작업4
   - [ ] 작업5
   ## Context
   {이어서 작업하는 사람이 알아야 할 핵심 맥락 2-3줄}
   ```

3. **확인** — 저장 완료를 사용자에게 알리고, 이어서 작업할지 물어본다

## Important

- 기존 progress 파일이 있으면 **덮어쓰기** (최신 상태만 유지)
- 간결하게 — 다음 세션에서 빠르게 파악할 수 있도록 핵심만
- TaskList가 있으면 그 정보를 활용하여 정확한 상태 반영
