# Reglas R8 / ProGuard para WayraUV Cusco
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Conservacion de clases requeridas por flutter_local_notifications
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# Ignorar clases opcionales de Google Play Core Deferred Components
-dontwarn com.google.android.play.core.**
