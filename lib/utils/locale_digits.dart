import 'package:flutter/material.dart';

/// أرقام حسب لغة العرض: عربي → ٠١٢٣٤٥٦٧٨٩، غير ذلك → 0123456789.
class LocaleDigits {
  LocaleDigits._();

  static const String _arabicDigits = '٠١٢٣٤٥٦٧٨٩';

  /// تحويل أي أرقام في النص إلى شكل مناسب للغة (عربي = أرقام هندية عربية).
  static String format(String text, Locale locale) {
    if (text.isEmpty) return text;
    if (locale.languageCode != 'ar') return text;
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final c = text.codeUnitAt(i);
      if (c >= 0x30 && c <= 0x39) {
        buffer.write(_arabicDigits[c - 0x30]);
      } else {
        buffer.writeCharCode(c);
      }
    }
    return buffer.toString();
  }
}

extension LocaleDigitsExtension on String {
  /// عرض النص بأرقام مناسبة للغة [locale].
  String toLocaleDigits(Locale locale) => LocaleDigits.format(this, locale);
}
