import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary: Electric Teal — conveys power, trust, Pakistan's green palette
  static const _seedColor = Color(0xFF00897B); // teal-600
  static const _accentColor = Color(0xFFF59E0B); // amber for energy/urgency
  static const _darkSurface = Color(0xFF0D1117);
  static const _darkCard = Color(0xFF161B22);
  static const _darkCard2 = Color(0xFF1C2333);

  static ThemeData light() => _buildTheme(Brightness.light);
  static ThemeData dark() => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
      secondary: _accentColor,
    ).copyWith(
      surface: isDark ? _darkSurface : const Color(0xFFF4F6F8),
      surfaceContainerLowest: isDark ? _darkCard : Colors.white,
      surfaceContainer: isDark ? _darkCard2 : const Color(0xFFEDF0F3),
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
    );

    final textTheme = _buildTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        backgroundColor:
            isDark ? _darkSurface.withValues(alpha: 0.95) : colorScheme.surface,
        foregroundColor: isDark ? Colors.white : const Color(0xFF0D1117),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: isDark ? Colors.white : const Color(0xFF0D1117),
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white70 : const Color(0xFF374151),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        color: isDark ? _darkCard : Colors.white,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? _darkCard : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.07),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _seedColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.55)
              : Colors.black.withValues(alpha: 0.45),
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: _seedColor,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: isDark
            ? Colors.white.withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.4),
        suffixIconColor: isDark
            ? Colors.white.withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.4),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.15),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: isDark ? _darkCard : Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: isDark
            ? Colors.black.withValues(alpha: 0.4)
            : Colors.black.withValues(alpha: 0.07),
        indicatorColor: _seedColor.withValues(alpha: isDark ? 0.22 : 0.14),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? _seedColor
                : (isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.5)),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? _seedColor
                : (isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.45)),
          );
        }),
      ),
      dividerTheme: DividerThemeData(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.05),
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        minVerticalPadding: 12,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    final g = GoogleFonts.interTextTheme(base);
    return g.copyWith(
      displayLarge: g.displayLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.5),
      displayMedium: g.displayMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1),
      displaySmall: g.displaySmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineLarge: g.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
      headlineMedium: g.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      headlineSmall: g.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: g.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: g.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: g.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: g.bodyLarge?.copyWith(height: 1.55),
      bodyMedium: g.bodyMedium?.copyWith(height: 1.5),
      bodySmall: g.bodySmall?.copyWith(height: 1.45),
      labelLarge: g.labelLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.2),
      labelMedium: g.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      labelSmall: g.labelSmall?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.4),
    );
  }

  static TextStyle urduTextStyle(BuildContext context, {TextStyle? base}) {
    final style = base ?? Theme.of(context).textTheme.bodyLarge!;
    return GoogleFonts.notoNastaliqUrdu(textStyle: style);
  }

  // Subtle hero gradient — used on login/language screens
  static BoxDecoration heroGradient(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.45, 1.0],
        colors: isDark
            ? [
                const Color(0xFF00897B).withValues(alpha: 0.18),
                const Color(0xFF0D1117).withValues(alpha: 0.9),
                const Color(0xFF0D1117),
              ]
            : [
                const Color(0xFF00897B).withValues(alpha: 0.10),
                const Color(0xFFF4F6F8).withValues(alpha: 0.85),
                const Color(0xFFF4F6F8),
              ],
      ),
    );
  }

  // Solid colored brand gradient for cards / result header
  static LinearGradient brandGradient() => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF00897B), Color(0xFF00695C)],
      );

  static LinearGradient amberGradient() => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
      );
}
