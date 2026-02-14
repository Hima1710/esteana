import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// أذونات التطبيق: الموقع (القبلة ومواقيت الصلاة)، الكاميرا والميكروفون (المقرأة الجماعية Jitsi).
/// يُستدعى عند فتح الشاشة الرئيسية — نطلب كل واحدة على حدة بالترتيب كي تظهر كل النوافذ في نفس الجلسة دون الحاجة لإغلاق التطبيق.
Future<void> requestAppPermissionsAtStartup() async {
  try {
    final permissions = [
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.microphone,
    ];
    for (final p in permissions) {
      final status = await p.status;
      if (status.isGranted) continue;
      await p.request();
    }
  } catch (e) {
    if (kDebugMode) debugPrint('AppPermissions: $e');
  }
}
