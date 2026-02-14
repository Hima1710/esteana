import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../generated/l10n/app_localizations.dart';

/// شاشة سياسة الخصوصية داخل التطبيق — نفس مضمون PRIVACY_POLICY.md.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradient = AppGradients.gradientFor(theme.brightness);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final sections = isArabic ? _sectionsAr : _sectionsEn;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                isArabic ? 'استعانة (Esteana)' : 'Esteana (استعانة)',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic ? 'آخر تحديث: 2025' : 'Last updated: 2025',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              ...sections.expand((s) => [
                    Text(
                      s.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section {
  const _Section({required this.title, required this.body});
  final String title;
  final String body;
}

final List<_Section> _sectionsAr = [
  _Section(
    title: '1. مقدمة',
    body: 'تطبيق استعانة (Esteana) يحترم خصوصيتك. توضح هذه الصفحة ما البيانات التي قد تُجمَع وكيف نستخدمها.',
  ),
  _Section(
    title: '2. البيانات التي نجمعها',
    body: '• الاستخدام دون تسجيل الدخول: يمكنك استخدام التطبيق كضيف. تُخزَّن بياناتك محلياً على جهازك فقط (تقدم الأذكار، المهام اليومية، إعدادات اللغة والمظهر).\n\n'
        '• تسجيل الدخول (اختياري): عند الدخول عبر Google نستخدم معلومات الحساب فقط لتحديد هويتك ومزامنة إنجازك (مثل طلبات الدعاء في المجلس). لا نبيع ولا نشارك بياناتك لأغراض إعلانية.\n\n'
        '• الموقع: نطلب صلاحية الموقع فقط عند استخدام ميزة اتجاه القبلة. تُستخدم الإحداثيات لحساب الاتجاه ولا تُرسَل إلى خوادمنا بشكل مستمر.\n\n'
        '• مواعيد الصلاة: تُحسب محلياً أو حسب المدينة دون إرسال موقعك لطرف ثالث.',
  ),
  _Section(
    title: '3. التخزين المحلي والخدمات السحابية',
    body: '• على الجهاز: قاعدة بيانات محلية (Isar) للأذكار، المهام، تقدم المصحف، والإعدادات.\n\n'
        '• السحابة (Supabase): عند تسجيل الدخول تُرسَل بيانات محدودة (مثل طلبات الدعاء في المجلس) لتوفير الميزات الاجتماعية. نلتزم بمعايير أمان مناسبة.',
  ),
  _Section(
    title: '4. ما لا نفعله',
    body: '• لا نبيع بياناتك الشخصية.\n'
        '• لا نشارك بياناتك مع أطراف ثالثة لأغراض تسويقية.\n'
        '• لا نستخدم بيانات الموقع إلا لميزة القبلة عند طلبك.',
  ),
  _Section(
    title: '5. حقوقك',
    body: 'يمكنك في أي وقت حذف بيانات التطبيق من إعدادات جهازك (مسح بيانات التطبيق) أو إلغاء ربط حساب Google من إعدادات حسابك.',
  ),
  _Section(
    title: '6. التعديلات والتواصل',
    body: 'قد نحدّث سياسة الخصوصية من وقت لآخر. لأي استفسار حول الخصوصية يمكنك فتح Issue في مستودع التطبيق على GitHub أو التواصل عبر القنوات المذكورة في وصف التطبيق.',
  ),
];

final List<_Section> _sectionsEn = [
  _Section(
    title: '1. Introduction',
    body: 'Esteana (استعانة) respects your privacy. This page explains what data we may collect and how we use it.',
  ),
  _Section(
    title: '2. Data We Collect',
    body: '• Use without signing in: You can use the app as a guest. Your data is stored only on your device (adhkar progress, daily tasks, language and theme settings).\n\n'
        '• Sign-in (optional): When you sign in with Google we use your account information only to identify you and sync your progress (e.g. prayer requests in Al-Majlis). We do not sell or share your data for advertising.\n\n'
        '• Location: We request location permission only when you use the Qibla direction feature. Coordinates are used to compute the direction and are not sent to our servers continuously.\n\n'
        '• Prayer times: Computed locally or by city without sending your location to third parties.',
  ),
  _Section(
    title: '3. Local Storage and Cloud Services',
    body: '• On device: A local database (Isar) stores adhkar progress, tasks, mushaf progress, and settings.\n\n'
        '• Cloud (Supabase): When signed in, limited data (e.g. prayer requests in Al-Majlis) is sent to provide social features. We apply appropriate security practices.',
  ),
  _Section(
    title: '4. What We Do Not Do',
    body: '• We do not sell your personal data.\n'
        '• We do not share your data with third parties for marketing.\n'
        '• We use location data only for the Qibla feature when you request it.',
  ),
  _Section(
    title: '5. Your Rights',
    body: 'You can at any time clear app data from your device settings or revoke Google account access from your account settings.',
  ),
  _Section(
    title: '6. Changes and Contact',
    body: 'We may update this privacy policy from time to time. For privacy-related questions you can open an Issue in the app\'s GitHub repository or contact us through the channels listed in the app description.',
  ),
];
