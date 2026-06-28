import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00897B), Color(0xFF004D40)],
        ),
        borderRadius: BorderRadius.circular(size * 0.26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00897B).withValues(alpha: isDark ? 0.45 : 0.30),
            blurRadius: size * 0.4,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative circle
          Positioned(
            top: -size * 0.12,
            right: -size * 0.12,
            child: Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Icon(
            Icons.bolt_rounded,
            color: Colors.white,
            size: size * 0.52,
          ),
        ],
      ),
    );
  }
}
