# Flutter Local Notifications - keep receivers so they work when app is killed
-keep class com.dexterous.** { *; }

# Keep Gson classes used by flutter_local_notifications
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*
-dontwarn com.google.gson.**

# Keep the notification models
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
