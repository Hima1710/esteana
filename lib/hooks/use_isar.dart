import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:isar/isar.dart';

/// استخدم داخل [HookWidget] للحصول على نسخة Isar.
Isar useIsar() {
  return useContext().watch<Isar>();
}
