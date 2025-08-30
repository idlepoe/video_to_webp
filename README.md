# 🎥 VideoToWebp

> 비디오를 WebP로 변환, 더 작은 용량으로 더 나은 품질로로

**VideoToWebp**은 비디오 파일을 WebP 애니메이션으로 변환

Flutter + Firebase 기반으로 제작되었으며, 상태관리는 GetX, OTA 업데이트는 Shorebird로 처리됩니다.

---

## 🌐 공식 서비스

- 📱 Google Play: [VideoToWebp 앱 설치하기](https://play.google.com/store/apps/details?id=com.jylee.video_to_webp)

---

## 🚀 주요 기능

- 🎬 **비디오 변환**: MP4, MOV 등 다양한 비디오 포맷 지원
- 🔄 **비디오 회전**: 90°, 180°, 270° 회전 지원 (FFmpeg Kit 사용)
- 🖼️ **썸네일 미리보기**: 비디오 첫 화면을 썸네일로 표시하여 회전 효과 미리보기

---

## 🛠️ 기술 스택

- **Flutter** (Dart)
- **Firebase**
    - Authentication
    - Firestore
    - Storage
    - 🔧 Cloud Functions
- [GetX](https://pub.dev/packages/get) – 상태관리 및 라우팅
- [Shorebird](https://pub.dev/packages/shorebird_code_push) – 코드 푸시 배포
- [FFmpeg Kit Flutter New](https://pub.dev/packages/ffmpeg_kit_flutter_new) – 비디오 처리 및 회전
- [Video Thumbnail](https://pub.dev/packages/video_thumbnail) – 비디오 썸네일 생성

---

## 📱 FFmpeg Kit 사용법

### 비디오 회전

```dart
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

// 90도 회전
String ffmpegCommand = '-i "input.mp4" -vf "transpose=1" -c:a copy "output.mp4"';

// 180도 회전
String ffmpegCommand = '-i "input.mp4" -vf "transpose=1,transpose=1" -c:a copy "output.mp4"';

// 270도 회전
String ffmpegCommand = '-i "input.mp4" -vf "transpose=2" -c:a copy "output.mp4"';

// FFmpeg 실행
final session = await FFmpegKit.execute(ffmpegCommand);
final returnCode = await session.getReturnCode();

if (ReturnCode.isSuccess(returnCode)) {
  print('비디오 회전 완료!');
} else {
  print('회전 실패');
}
```

### 지원하는 플랫폼

- ✅ Android (API Level 24+)
- ✅ iOS (14.0+)
- ✅ macOS (10.15+)

---

## 🚀 설치 및 설정

### 1. 의존성 추가

```yaml
dependencies:
  ffmpeg_kit_flutter_new: ^3.2.0
```

### 2. 패키지 설치

```bash
flutter pub get
```

### 3. Android 설정

`android/app/build.gradle.kts`에 ABI 필터 추가:

```kotlin
android {
    defaultConfig {
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86", "x86_64")
        }
    }
}
```

### 4. 권한 설정

`android/app/src/main/AndroidManifest.xml`에 필요한 권한 추가:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
```
