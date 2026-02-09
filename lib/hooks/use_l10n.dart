import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../generated/l10n/app_localizations.dart';

/// Hook لاستدعاء النصوص المترجمة داخل أي [HookWidget].
/// يضمن إعادة البناء عند تغيير اللغة.
AppLocalizations useL10n() {
  final context = useContext();
  final l10n = AppLocalizations.of(context);
  if (l10n == null) {
    throw FlutterError('useL10n() must be used within a context where AppLocalizations is available.');
  }
  return l10n;
}
