import 'package:isar/isar.dart';

part 'last_read_entry.g.dart';

/// آخر موضع قراءة في المصحف — يُحدَّث عند فتح شاشة القراءة أو عند الخروج منها.
@collection
class LastReadEntry {
  Id id = Isar.autoIncrement;

  late int sura;
  late int aya;
  late DateTime updatedAt;

  LastReadEntry();
}
