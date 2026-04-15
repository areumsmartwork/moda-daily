import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// 앱 전역 ThemeData.
/// main.dart의 MaterialApp(theme: AppTheme.light)에 주입.
abstract final class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,

      // Primary — Navy
      primary: AppColors.primary,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,

      // Secondary — Teal
      secondary: AppColors.secondary,
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: AppColors.secondaryFixed,
      onSecondaryContainer: Color(0xFF00201B),

      // Tertiary — Deep Red Brown
      tertiary: AppColors.tertiary,
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFDBD1),
      onTertiaryContainer: Color(0xFF380B00),

      // Surface
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: Color(0xFFF3F3F3),
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: Color(0xFFE8E8E8),
      surfaceContainerHighest: Color(0xFFE2E2E2),
      onSurfaceVariant: AppColors.onSurfaceVariant,

      // Outline — "Ghost Border" 전용. 직접 사용 시 0.15 opacity 적용.
      outline: AppColors.outlineVariant,
      outlineVariant: AppColors.outlineVariant,

      // Error
      error: AppColors.error,
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),

      // Scrim / Shadow
      shadow: AppColors.shadowPrimary,
      scrim: Color(0xFF000000),

      // Inverse
      inverseSurface: Color(0xFF2F3131),
      onInverseSurface: Color(0xFFF0F1F1),
      inversePrimary: AppColors.primaryFixedDim,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,

      // ── AppBar ───────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.onSurface,
        titleTextStyle: AppTypography.titleLg,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      // "No-Line Rule": elevation + surface color 조합으로 깊이 표현.
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceContainerLowest,
        shadowColor: AppColors.shadowPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          // ghost border — 15% opacity
          side: const BorderSide(
            color: Color(0x26C6C5D4), // outlineVariant @ 15%
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s2,
        ),
      ),

      // ── FilledButton ─────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? AppColors.surfaceContainer
                : AppColors.primary,
          ),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          textStyle: WidgetStateProperty.all(AppTypography.titleSm),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.s6,
              vertical: AppSpacing.s4,
            ),
          ),
          elevation: WidgetStateProperty.all(0),
        ),
      ),

      // ── OutlinedButton (Secondary 스타일) ─────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(AppColors.surfaceContainerLowest),
          foregroundColor: WidgetStateProperty.all(AppColors.primary),
          textStyle: WidgetStateProperty.all(AppTypography.titleSm),
          side: WidgetStateProperty.all(BorderSide.none),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
          ),
        ),
      ),

      // ── TextButton (Tertiary/ghost 스타일) ────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColors.secondary),
          textStyle: WidgetStateProperty.all(
            AppTypography.labelLg.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.secondary,
            ),
          ),
        ),
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        selectedColor: AppColors.secondaryFixed,
        labelStyle: AppTypography.labelMd,
        side: const BorderSide(
          color: Color(0x26C6C5D4), // ghost border
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3,
          vertical: AppSpacing.s1,
        ),
      ),

      // ── BottomSheet ───────────────────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        titleTextStyle: AppTypography.headlineSm,
        contentTextStyle: AppTypography.bodyMd,
      ),

      // ── FloatingActionButton ──────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),

      // ── ProgressIndicator ─────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.secondary,
        linearTrackColor: AppColors.surfaceContainer,
      ),

      // ── Divider — DESIGN.md "No-Line Rule"으로 기본 비노출 ────────────────
      dividerTheme: const DividerThemeData(
        color: Colors.transparent,
        thickness: 0,
        space: 0,
      ),

      // ── Input ─────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        labelStyle: AppTypography.bodyMd,
        hintStyle: AppTypography.bodyMd.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: Color(0x26C6C5D4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: Color(0x26C6C5D4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
