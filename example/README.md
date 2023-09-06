## weklem_web_youtube_player

이 패키지는 Flutter 웹 앱에서 YouTube 비디오를 재생하기 위한 위젯을 제공합니다.

### 사용법

1. **패키지 설치**:

   `pubspec.yaml` 파일에 다음을 추가합니다.

    ```yaml
    dependencies:
      weklem_web_youtube_player: ^0.0.1
    ```

2. **위젯 사용**:

    ```dart
    import 'package:weklem_web_youtube_player/weklem_web_youtube_player.dart';
    ```

3. **YouTubePlayerWidget 사용**:

    ```dart
    YouTubePlayerWidget(
      youtubeLink: 'https://youtu.be/PecI6paDQxI?si=ek86w2Nuo1OTJAfM', 
      width: 480, 
      height: 259, 
      eScrollMode: EScrollMode.SCROLL, 
      scrollController: yourScrollController,
    )
    ```

#### 파라미터 설명:

- `youtubeLink`: 공유하기 링크로만 가능합니다. (`si` 파라미터가 필요합니다.)
- `width` & `height`: YouTube 동영상의 크기를 정의합니다.
- `eScrollMode`: 스크롤 관련 모드를 정의합니다. (SCROLL, PAGE_VIEW, STATIC 중 하나를 선택할 수 있습니다.)
- `scrollController` & `pageController`: 스크롤이나 페이지 뷰의 동작을 제어하기 위한 컨트롤러입니다. (eScrollMode에 따라 선택적으로 사용됩니다.)

