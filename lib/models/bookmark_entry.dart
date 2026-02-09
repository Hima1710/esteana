import 'package:isar/isar.dart';

part 'bookmark_entry.g.dart';

/// علامة مرجعية لآية — يُستخدم في تابة العلامات.
@collection
class BookmarkEntry {
  Id id = Isar.autoIncrement;

  late int sura;
  late int aya;
  late DateTime createdAt;

  BookmarkEntry();
}
