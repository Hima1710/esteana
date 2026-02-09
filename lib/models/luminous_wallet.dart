import 'package:isar/isar.dart';

part 'luminous_wallet.g.dart';

/// محفظة القطع النورانية — سجل واحد محلي في Isar للسرعة والعمل دون إنترنت.
@collection
class LuminousWallet {
  Id id = Isar.autoIncrement;

  /// إجمالي القطع المحصّلة
  late int totalPieces;

  /// آخر تحديث
  late DateTime updatedAt;

  LuminousWallet();
}
