import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../models/luminous_wallet.dart';
import 'isar_service.dart';

/// خدمة القطع النورانية — تخزين محلي في Isar للسرعة والعمل دون إنترنت.
class LuminousService {
  LuminousService._();

  /// يُحدَّث عند كل إضافة قطع لتفعيل تأثير النبض في الصندوق الطافي.
  static final ValueNotifier<int> pulseTrigger = ValueNotifier<int>(0);

  static Future<int> getTotal() async {
    if (!IsarService.isInitialized) return 0;
    final isar = IsarService.isar;
    final w = await isar.luminousWallets.where().findFirst();
    return w?.totalPieces ?? 0;
  }

  static Stream<int> watchTotal() {
    if (!IsarService.isInitialized) return Stream.value(0);
    final isar = IsarService.isar;
    return isar.luminousWallets.where().watch(fireImmediately: true).map((list) {
      if (list.isEmpty) return 0;
      return list.map((e) => e.totalPieces).reduce((a, b) => a + b);
    });
  }

  /// إضافة قطع نورانية (يُستدعى عند كل ضغطة على العداد في الأذكار).
  static Future<void> addPieces(int count) async {
    if (!IsarService.isInitialized || count <= 0) return;
    final isar = IsarService.isar;
    final now = DateTime.now();
    await isar.writeTxn(() async {
      final w = await isar.luminousWallets.where().findFirst();
      if (w == null) {
        await isar.luminousWallets.put(LuminousWallet()
          ..totalPieces = count
          ..updatedAt = now);
      } else {
        w.totalPieces += count;
        w.updatedAt = now;
        await isar.luminousWallets.put(w);
      }
    });
    pulseTrigger.value++;
  }
}
