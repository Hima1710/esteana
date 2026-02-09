import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

import '../theme/app_theme.dart';
import '../hooks/use_l10n.dart';

/// عتبة المحاذاة بالدرجات — عندها نُظهر "متجه نحو القبلة".
const double _kAlignmentThresholdDeg = 8;

/// شاشة القبلة — بوصلة حقيقية مع حساسات الجهاز.
class QiblaScreen extends HookWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();
    final theme = Theme.of(context);
    final gradient = AppGradients.gradientFor(theme.brightness);
    final colorScheme = theme.colorScheme;

    final locationStatus = useState<LocationStatus?>(null);
    final permissionRequested = useState(false);
    final qiblahDirection = useState<QiblahDirection?>(null);
    final streamError = useState<String?>(null);

    useEffect(() {
      Future<void> init() async {
        final status = await FlutterQiblah.checkLocationStatus();
        locationStatus.value = status;
        if (status.status != LocationPermission.whileInUse &&
            status.status != LocationPermission.always) {
          if (!permissionRequested.value) {
            permissionRequested.value = true;
            final result = await FlutterQiblah.requestPermissions();
            locationStatus.value = LocationStatus(
              await Geolocator.isLocationServiceEnabled(),
              result,
            );
          }
        }
      }

      init();
      return null;
    }, []);

    useEffect(() {
      final status = locationStatus.value;
      if (status == null) return null;
      if (status.status != LocationPermission.whileInUse &&
          status.status != LocationPermission.always) {
        return null;
      }

      StreamSubscription<QiblahDirection>? sub;
      sub = FlutterQiblah.qiblahStream.listen(
        (QiblahDirection d) {
          qiblahDirection.value = d;
          streamError.value = null;
        },
        onError: (Object e, StackTrace _) {
          streamError.value = e.toString();
        },
      );

      return () {
        sub?.cancel();
        FlutterQiblah().dispose();
      };
    }, [locationStatus.value?.status]);

    final isAligned = useMemoized(() {
      final d = qiblahDirection.value;
      if (d == null) return false;
      final diff = _angleDiff(d.direction, d.offset);
      return diff <= _kAlignmentThresholdDeg;
    }, [qiblahDirection.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.qiblaDirection),
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: _buildBody(
            context: context,
            l10n: l10n,
            theme: theme,
            colorScheme: colorScheme,
            locationStatus: locationStatus.value,
            qiblahDirection: qiblahDirection.value,
            streamError: streamError.value,
            isAligned: isAligned,
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required dynamic l10n,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required LocationStatus? locationStatus,
    required QiblahDirection? qiblahDirection,
    required String? streamError,
    required bool isAligned,
  }) {
    if (locationStatus == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              l10n.locationRequired,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.85),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (locationStatus.status != LocationPermission.whileInUse &&
        locationStatus.status != LocationPermission.always) {
      return _PermissionMessage(
        l10n: l10n,
        colorScheme: colorScheme,
        theme: theme,
        locationStatus: locationStatus,
      );
    }

    if (streamError != null && streamError.isNotEmpty) {
      return _ErrorMessage(
        message: l10n.sensorsError,
        colorScheme: colorScheme,
        theme: theme,
      );
    }

    if (qiblahDirection == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              l10n.pleaseCalibrate,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.85),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return _CompassContent(
      qiblahDirection: qiblahDirection,
      colorScheme: colorScheme,
      theme: theme,
      l10n: l10n,
      isAligned: isAligned,
    );
  }
}

double _angleDiff(double a, double b) {
  double d = (a - b).abs();
  if (d > 180) d = 360 - d;
  return d;
}

class _PermissionMessage extends StatelessWidget {
  const _PermissionMessage({
    required this.l10n,
    required this.colorScheme,
    required this.theme,
    required this.locationStatus,
  });

  final dynamic l10n;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final LocationStatus locationStatus;

  @override
  Widget build(BuildContext context) {
    final denied = locationStatus.status == LocationPermission.denied ||
        locationStatus.status == LocationPermission.deniedForever;
    final message = denied ? l10n.locationDenied : l10n.locationRequired;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({
    required this.message,
    required this.colorScheme,
    required this.theme,
  });

  final String message;
  final ColorScheme colorScheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sensors_rounded, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassContent extends HookWidget {
  const _CompassContent({
    required this.qiblahDirection,
    required this.colorScheme,
    required this.theme,
    required this.l10n,
    required this.isAligned,
  });

  final QiblahDirection qiblahDirection;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final dynamic l10n;
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
      initialValue: 0,
    );
    final pulseScale = useAnimation(
      Tween<double>(begin: 1, end: 1.08).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    useEffect(() {
      if (isAligned) {
        animationController.repeat(reverse: true);
      } else {
        animationController.stop();
        animationController.reset();
      }
      return null;
    }, [isAligned]);

    final size = MediaQuery.sizeOf(context).shortestSide * 0.75;
    final direction = qiblahDirection.direction;
    final offset = qiblahDirection.offset;
    final qiblaAngleOnScreen = (offset - direction) * math.pi / 180;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.qiblaDirection,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedBuilder(
          animation: Listenable.merge([animationController]),
          builder: (context, child) {
            return Transform.scale(
              scale: isAligned ? pulseScale : 1,
              child: child,
            );
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
              border: Border.all(
                color: isAligned
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.5),
                width: isAligned ? 3 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: -direction * math.pi / 180,
                  child: _CompassRose(colorScheme: colorScheme, size: size),
                ),
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 4,
                      height: size * 0.25,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    math.sin(qiblaAngleOnScreen) * (size * 0.38),
                    -math.cos(qiblaAngleOnScreen) * (size * 0.38),
                  ),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAligned
                          ? colorScheme.primary
                          : colorScheme.tertiary.withValues(alpha: 0.9),
                      border: Border.all(
                        color: colorScheme.onPrimary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.mosque_rounded,
                      size: 18,
                      color: isAligned
                          ? colorScheme.onPrimary
                          : colorScheme.onTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isAligned
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(kShapeRadius),
          ),
          child: Text(
            isAligned ? l10n.qiblaAligned : l10n.pleaseCalibrate,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isAligned
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface.withValues(alpha: 0.85),
              fontWeight: isAligned ? FontWeight.w600 : null,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _CompassRose extends StatelessWidget {
  const _CompassRose({required this.colorScheme, required this.size});

  final ColorScheme colorScheme;
  final double size;

  @override
  Widget build(BuildContext context) {
    const labels = ['N', 'E', 'S', 'W'];
    final r = size * 0.42;
    final positions = [
      Offset(0, -r),
      Offset(r, 0),
      Offset(0, r),
      Offset(-r, 0),
    ];

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < 4; i++)
            Positioned(
              left: size / 2 + positions[i].dx - 10,
              top: size / 2 + positions[i].dy - 10,
              width: 20,
              height: 20,
              child: Center(
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        labels[i] == 'N' ? FontWeight.bold : FontWeight.w500,
                    color: colorScheme.onSurface
                        .withValues(alpha: labels[i] == 'N' ? 1 : 0.65),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
