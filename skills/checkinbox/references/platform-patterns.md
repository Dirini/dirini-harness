# Platform-specific Extraction Patterns

## Threads (threads.net)
- **문제**: JS 렌더링 → WebFetch로 텍스트 추출 불가
- **해결**: Playwright `browser_navigate` → `browser_snapshot`으로 렌더링된 DOM 추출
- **핵심**: og:description에는 앞부분만 있음. 실제 포스트 전문은 snapshot에서 추출
- **댓글**: snapshot에 답글도 포함됨. 상위 댓글 15-20개 확인
- **외부 링크**: 포스트 본문의 링크가 실제 콘텐츠인 경우 많음 (Google Drive PDF, 블로그 등)

## Reddit (reddit.com)
- **추출**: exa.ai `web_search_exa`가 가장 효과적 (Reddit 콘텐츠 잘 크롤링)
- **댓글**: 상위 30개 + 대댓글. 합의/반론/실전팁 분류
- **주의**: old.reddit.com URL로 변환하면 WebFetch 성공률 높아짐

## LinkedIn (linkedin.com)
- **문제**: 로그인 필요한 콘텐츠 많음
- **해결**: exa.ai로 검색하면 public 콘텐츠 추출 가능
- **대안**: Playwright로 비로그인 상태에서 볼 수 있는 내용 추출

## YouTube (youtube.com, youtu.be)
- **추출**: youtube-digest 스킬 사용 또는 /tmp/youtube_transcripts/에서 자막 읽기
- **주의**: 자막이 없는 영상은 exa.ai로 관련 요약 검색

## Google Drive PDF
- **문제**: WebFetch로 PDF 내용 추출 불가 (뷰어 HTML만 반환)
- **해결**: `curl -L "https://drive.google.com/uc?export=download&id=FILE_ID" -o /tmp/filename.pdf`
- **읽기**: Read 도구로 pages 파라미터 사용 (대용량 PDF는 반드시 페이지 지정)

## 일반 웹 아티클
- **1차**: WebFetch (Jina Reader 자동 변환)
- **2차**: exa.ai `web_search_exa` (캐시된 크롤링 결과)
- **3차**: Playwright (동적 콘텐츠)
