import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import '../hooks/use_l10n.dart';
import '../providers/auth_provider.dart';
import 'main_screen.dart';

/// صفحة اختيار طريقة الدخول: جوجل أو ضيف، مع زر تخطي.
class AuthChoiceScreen extends HookWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradient = AppGradients.gradientFor(theme.brightness);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Image.asset(
                      'assets/newesteanalogo.png',
                      fit: BoxFit.contain,
                      height: 80,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.menu_book_rounded,
                        size: 64,
                        color: colorScheme.onSurface.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.welcomeToJourney,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.95),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () => _onGoogleLogin(context),
                            icon: Icon(Icons.g_mobiledata_rounded, size: 24, color: colorScheme.onPrimary),
                            label: Text(l10n.loginGoogle),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(kShapeRadius),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () => _onGuest(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.onSurface,
                              side: BorderSide(color: colorScheme.outline),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(kShapeRadius),
                              ),
                            ),
                            child: Text(l10n.continueGuest),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              Positioned(
                top: 8,
                right: 16,
                child: TextButton(
                  onPressed: () => _onGuest(context),
                  child: Text(
                    l10n.skip,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onGoogleLogin(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.signInWithGoogle();
    if (!context.mounted) return;
    if (ok) {
      await _markJourneyStarted();
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  void _onGuest(BuildContext context) async {
    context.read<AuthProvider>().setGuest();
    await _markJourneyStarted();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  static Future<void> _markJourneyStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_started_journey', true);
  }
}
