# Resume — 이전 세션 이어가기

이전 세션에서 중단된 작업을 빠르게 파악하고 이어서 진행한다.

## Triggers

- `/resume`
- "이어서", "지난번", "어디까지 했지", "resume"

## Steps

1. **진행상황 파일 탐색** — 아래 파일들을 순서대로 확인 (`<home-slug>`은 홈 경로의 `/`를 `-`로 치환한 값, 예: `/Users/alice` → `-Users-alice`):
   - `~/.claude/projects/<home-slug>/memory/MEMORY.md` (세션 간 메모리)
   - `~/.claude/projects/<home-slug>/memory/session-progress.md` (자동 저장된 진행상황)
   - 현재 프로젝트의 `TODO.md` 또는 `*-progress.md`

2. **요약 제공** — 발견된 정보를 바탕으로:
   - 마지막 세션에서 완료한 것
   - 미완료 / 진행 중이던 것
   - 다음으로 해야 할 것

3. **사용자 확인** — AskUserQuestion으로 질문:
   - "어떤 항목부터 이어서 할까요?" (선택지 제공)
   - 사용자가 선택할 때까지 작업 시작하지 않음

4. **작업 시작** — 사용자가 선택한 항목부터 진행

## Important

- 진행상황 파일이 없으면 "저장된 진행상황이 없습니다"라고 알리고, 사용자에게 무엇을 하고 싶은지 물어본다
- 절대로 추측으로 이전 작업을 시작하지 않는다
