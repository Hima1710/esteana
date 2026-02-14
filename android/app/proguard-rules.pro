# Suppress R8 error: Giphy SDK (transitive via Jitsi) references kotlinx.parcelize.Parcelize
-dontwarn kotlinx.parcelize.Parcelize

# React Native (مضمّن في Jitsi Meet SDK)
-keep,allowobfuscation @interface com.facebook.proguard.annotations.DoNotStrip
-keep,allowobfuscation @interface com.facebook.proguard.annotations.KeepGettersAndSetters
-keep @com.facebook.proguard.annotations.DoNotStrip class *
-keepclassmembers class * {
    @com.facebook.proguard.annotations.DoNotStrip *;
}
-keep @com.facebook.proguard.annotations.DoNotStripAny class * { *; }
-keepclassmembers @com.facebook.proguard.annotations.KeepGettersAndSetters class * {
  void set*(***);
  *** get*();
}
-keep class * implements com.facebook.react.bridge.JavaScriptModule { *; }
-keep class * implements com.facebook.react.bridge.NativeModule { *; }
-keepclassmembers,includedescriptorclasses class * { native <methods>; }
-keepclassmembers class *  { @com.facebook.react.uimanager.annotations.ReactProp <methods>; }
-keepclassmembers class *  { @com.facebook.react.uimanager.annotations.ReactPropGroup <methods>; }
-dontwarn com.facebook.react.**
-keep,includedescriptorclasses class com.facebook.react.bridge.** { *; }
-keep,includedescriptorclasses class com.facebook.react.turbomodule.core.** { *; }
-keep class com.facebook.jni.** { *; }
-keep,allowobfuscation @interface com.facebook.yoga.annotations.DoNotStrip
-keep @com.facebook.yoga.annotations.DoNotStrip class *
-keepclassmembers class * { @com.facebook.yoga.annotations.DoNotStrip *; }
-keep class com.facebook.react.bridge.CatalystInstanceImpl { *; }
-keep class com.facebook.react.bridge.ExecutorToken { *; }
-keep class com.facebook.react.bridge.JavaScriptExecutor { *; }
-keep class com.facebook.react.bridge.ModuleRegistryHolder { *; }
-keep class com.facebook.react.bridge.ReadableType { *; }
-keep class com.facebook.react.bridge.queue.NativeRunnable { *; }
-keep class com.facebook.react.devsupport.** { *; }
-dontwarn com.facebook.react.devsupport.**
-dontwarn com.google.appengine.**
-dontwarn com.squareup.okhttp.**
-dontwarn javax.servlet.**

# WebRTC (مستخدم من Jitsi) — ضروري لبث الصوت/الفيديو على Android 16 Release
-keep class org.webrtc.** { *; }
-keepclassmembers class org.webrtc.** { *; }
# EGL/Surface (تجنّب crash صامت لـ SurfaceViewRenderer على أندرويد 16)
-keep class org.webrtc.EglBase { *; }
-keep class org.webrtc.EglBase14Impl { *; }
-keep class org.webrtc.EglRenderer { *; }
-keep class org.webrtc.SurfaceViewRenderer { *; }
-keep class org.webrtc.SurfaceEglRenderer { *; }
# VideoTrack / AudioTrack publish
-keep class org.webrtc.VideoTrack { *; }
-keep class org.webrtc.AudioTrack { *; }
-keep class org.webrtc.VideoSource { *; }
-keep class org.webrtc.AudioSource { *; }
-dontwarn org.chromium.build.BuildHooksAndroid
# react-native-webrtc (Jitsi SDK يعتمد عليه)
-keep class com.oney.WebRTCModule.** { *; }
-keep class com.oney.WebRTCModule.VideoTrackAdapter { *; }

# Jitsi Meet SDK
-keep class org.jitsi.meet.** { *; }
-keep class org.jitsi.meet.sdk.** { *; }

# okio (تبعية)
-keep class sun.misc.Unsafe { *; }
-dontwarn java.nio.file.*
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
-dontwarn okio.**

# SVG (إن وُجد في Jitsi)
-keep public class com.horcrux.svg.** {*;}
