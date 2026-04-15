import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// 앱 전역 타이포그래피 토큰.
/// DESIGN.md "Typography" 기반.
///
/// - Display / Headline: Plus Jakarta Sans — 도시명·여행 제목 등 표현적 용도
/// - Body / Label / Data: Manrope — 메타데이터·로그 등 기술적 정보
abstract final class AppTypography {
  AppTypography._();

  // ─── Font Family ─────────────────────────────────────────────────────────

  /// 표현적 텍스트 (도시명, 섹션 제목)
  static TextStyle get _jakarta => GoogleFonts.plusJakartaSans(
        color: AppColors.onSurface,
      );

  /// 기술 데이터 텍스트 (좌표, 고도, 날짜)
  static TextStyle get _manrope => GoogleFonts.manrope(
        color: AppColors.onSurface,
      );

  // ─── Display (Plus Jakarta Sans) ─────────────────────────────────────────

  /// display-lg: 도시명·여행 제목 마스트헤드. letter-spacing tight.
  static TextStyle get displayLg => _jakarta.copyWith(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        height: 1.0,
      );

  /// display-md
  static TextStyle get displayMd => _jakarta.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.1,
      );

  /// display-sm
  static TextStyle get displaySm => _jakarta.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.1,
      );

  // ─── Headline (Plus Jakarta Sans) ────────────────────────────────────────

  /// headline-lg: 화면 섹션 앵커.
  static TextStyle get headlineLg => _jakarta.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      );

  /// headline-md: 메타데이터 섹션 기본 앵커.
  static TextStyle get headlineMd => _jakarta.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  /// headline-sm
  static TextStyle get headlineSm => _jakarta.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // ─── Title (Plus Jakarta Sans) ───────────────────────────────────────────

  static TextStyle get titleLg => _jakarta.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get titleMd => _jakarta.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      );

  static TextStyle get titleSm => _jakarta.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      );

  // ─── Body (Manrope) ───────────────────────────────────────────────────────

  static TextStyle get bodyLg => _manrope.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  /// 여행 로그 주력 텍스트.
  static TextStyle get bodyMd => _manrope.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get bodySm => _manrope.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // ─── Label (Manrope) ──────────────────────────────────────────────────────

  static TextStyle get labelLg => _manrope.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMd => _manrope.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  /// label-sm: 기술 메타데이터 (LAT/LONG, ALTITUDE 등).
  /// DESIGN.md 지정: all-caps + 5% letter-spacing.
  static TextStyle get labelSm => _manrope.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.55, // ~5% of 11px
      );

  /// label-sm을 all-caps로 사용하는 데이터 레이블 전용 스타일.
  static TextStyle get dataLabel => labelSm.copyWith(
        letterSpacing: 1.2,
        color: AppColors.onSurfaceVariant,
      );

  // ─── TextTheme 조립 (MaterialApp에 주입) ─────────────────────────────────

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLg,
        displayMedium: displayMd,
        displaySmall: displaySm,
        headlineLarge: headlineLg,
        headlineMedium: headlineMd,
        headlineSmall: headlineSm,
        titleLarge: titleLg,
        titleMedium: titleMd,
        titleSmall: titleSm,
        bodyLarge: bodyLg,
        bodyMedium: bodyMd,
        bodySmall: bodySm,
        labelLarge: labelLg,
        labelMedium: labelMd,
        labelSmall: labelSm,
      );
}
