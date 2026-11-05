import 'package:flutter/material.dart';

/// Ýolugra palette: a deep oasis teal with a warm saffron accent, on calm sand-tinted
/// neutrals. Colors are defined once here and reached through the theme.
abstract final class AppColors {
  static const teal = Color(0xFF0B7A6B);
  static const tealDark = Color(0xFF075548);
  static const tealSoft = Color(0xFFDDF1EC);
  static const saffron = Color(0xFFF0A23B);
  static const saffronSoft = Color(0xFFFDF0DC);
  static const ink = Color(0xFF13211F);
  static const inkMuted = Color(0xFF5B6B68);
  static const sand = Color(0xFFF5F4EF);
  static const line = Color(0xFFE2E4DE);
  static const danger = Color(0xFFC2413A);
  static const success = Color(0xFF2F8A55);
  static const night = Color(0xFF0E1615);
  static const nightCard = Color(0xFF17221F);
}

/// Status colors that both themes share.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({required this.pending, required this.positive, required this.negative, required this.neutral});

  final Color pending;
  final Color positive;
  final Color negative;
  final Color neutral;

  @override
  StatusColors copyWith({Color? pending, Color? positive, Color? negative, Color? neutral}) => StatusColors(
        pending: pending ?? this.pending,
        positive: positive ?? this.positive,
        negative: negative ?? this.negative,
        neutral: neutral ?? this.neutral,
      );

  @override
  StatusColors lerp(StatusColors? other, double t) => other == null
      ? this
      : StatusColors(
          pending: Color.lerp(pending, other.pending, t)!,
          positive: Color.lerp(positive, other.positive, t)!,
          negative: Color.lerp(negative, other.negative, t)!,
          neutral: Color.lerp(neutral, other.neutral, t)!,
        );
}

abstract final class AppTheme {
  static const radius = 16.0;
  static const gap = 16.0;

  static ThemeData light() => _build(
        ColorScheme.fromSeed(
          seedColor: AppColors.teal,
          primary: AppColors.teal,
          onPrimary: Colors.white,
          primaryContainer: AppColors.tealSoft,
          onPrimaryContainer: AppColors.tealDark,
          secondary: AppColors.saffron,
          onSecondary: AppColors.ink,
          secondaryContainer: AppColors.saffronSoft,
          surface: Colors.white,
          onSurface: AppColors.ink,
          onSurfaceVariant: AppColors.inkMuted,
          outlineVariant: AppColors.line,
          error: AppColors.danger,
        ),
        scaffold: AppColors.sand,
      );

  static ThemeData dark() => _build(
        ColorScheme.fromSeed(
          seedColor: AppColors.teal,
          brightness: Brightness.dark,
          primary: const Color(0xFF5CC8B4),
          secondary: AppColors.saffron,
          surface: AppColors.nightCard,
        ),
        scaffold: AppColors.night,
      );

  static ThemeData _build(ColorScheme scheme, {required Color scaffold}) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
    final base = ThemeData(useMaterial3: true, colorScheme: scheme, scaffoldBackgroundColor: scaffold);
    final text = base.textTheme.apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
    return base.copyWith(
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: shape.copyWith(side: BorderSide(color: scheme.outlineVariant)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: shape,
          textStyle: text.titleMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: shape,
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: text.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(textStyle: text.labelLarge)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: scheme.outlineVariant)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: scheme.outlineVariant)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: scheme.primary, width: 2)),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(text.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      ),
      snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: shape),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      extensions: [
        StatusColors(
          pending: AppColors.saffron,
          positive: AppColors.success,
          negative: AppColors.danger,
          neutral: scheme.onSurfaceVariant,
        ),
      ],
    );
  }
}
