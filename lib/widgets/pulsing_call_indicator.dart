import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/call_state_provider.dart';

/// أيقونة صغيرة نابضة في أعلى الشاشة عندما المكالمة تعمل في الخلفية والمستخدم خارج صفحة المقرأة.
class PulsingCallIndicator extends StatelessWidget {
  const PulsingCallIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CallState>(
      builder: (context, call, _) {
        if (!call.isInCall || call.isOnMajlisPage) return const SizedBox.shrink();
        return Positioned(
          top: MediaQuery.paddingOf(context).top + 8,
          left: 0,
          right: 0,
          child: Center(
            child: _PulsingCallChip(),
          ),
        );
      },
    );
  }
}

class _PulsingCallChip extends StatefulWidget {
  @override
  State<_PulsingCallChip> createState() => _PulsingCallChipState();
}

class _PulsingCallChipState extends State<_PulsingCallChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.mic_rounded,
                      size: 18,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
