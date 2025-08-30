# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# FFmpeg Kit 관련 ProGuard 규칙
-keep class com.arthenica.ffmpegkit.** { *; }
-keep class com.arthenica.ffmpegkit.ffmpeg.** { *; }
-keep class com.arthenica.ffmpegkit.ffprobe.** { *; }
-keep class com.arthenica.ffmpegkit.session.** { *; }
-keep class com.arthenica.ffmpegkit.config.** { *; }

# 네이티브 라이브러리 관련
-keep class com.arthenica.ffmpegkit.ffmpeg.** { *; }
-keep class com.arthenica.ffmpegkit.ffprobe.** { *; }

# JNI 관련
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep class com.arthenica.** { *; }
