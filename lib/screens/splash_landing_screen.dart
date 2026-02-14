import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../theme/app_theme.dart';
import '../hooks/use_l10n.dart';
import 'auth_choice_screen.dart';

/// الشاشة الافتتاحية — تدرج لوني، لوجو، وزر "Start My Journey" / "ابدأ رحلتي".
class SplashLandingScreen extends HookWidget {
  const SplashLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradient = AppGradients.gradientFor(theme.brightness);
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Image.asset(
                  'assets/newesteanalogo.png',
                  fit: BoxFit.contain,
                  height: 180,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.menu_book_rounded,
                    size: 120,
                    color: colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.appTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.95),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _onStartJourney(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSurface,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kShapeRadius),
                      ),
                    ),
                    child: Text(
                      l10n.startJourney,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
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

  void _onStartJourney(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AuthChoiceScreen(),
      ),
    );
  }
}
