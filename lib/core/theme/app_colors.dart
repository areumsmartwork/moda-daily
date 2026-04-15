import 'package:flutter/material.dart';

/// 앱 전역 컬러 토큰.
/// DESIGN.md "Colors & Surface Logic" 기반.
///
/// 사용 원칙:
/// - 1px solid 경계선 금지 → tonal shift / 음수 공간 / 그림자로 구분
/// - 100% black(#000000) 금지 → [onSurface] 사용
abstract final class AppColors {
  AppColors._();

  // ─── Brand ──────────────────────────────────────────────────────────────

  /// Primary — Navy. 신뢰감 있는 데이터 중심 색.
  static const Color primary = Color(0xFF1A237E);

  /// Primary Dark — "Deep Ink" gradient 시작점 (hero CTA용).
  static const Color primaryDark = Color(0xFF000666);

  /// Primary Container — floating overlay, high-impact metadata 배경.
  static const Color primaryContainer = Color(0xFF1A237E);

  /// On Primary Container — primaryContainer 위 텍스트.
  static const Color onPrimaryContainer = Color(0xFFBDC2FF);

  /// Primary Fixed Dim — 어두운 배경 위 secondary 텍스트.
  static const Color primaryFixedDim = Color(0xFFBDC2FF);

  /// Secondary — Teal. 여행의 신선한 감성, 지도 마커 강조.
  static const Color secondary = Color(0xFF00BFA5);

  /// Secondary Fixed — active filter chip 배경. "vibrant map" 에너지.
  static const Color secondaryFixed = Color(0xFF68FADD);

  /// Tertiary — 딥 레드 브라운. 에러/정지 장소 표시.
  static const Color tertiary = Color(0xFF380B00);

  // ─── Surface Hierarchy (레이어 순서: base → section → card → floating) ─

  /// Base canvas.
  static const Color surface = Color(0xFFF9F9F9);

  /// Layout section 배경.
  static const Color surfaceContainer = Color(0xFFEEEEEE);

  /// Card 배경 — surface 위에서 자연스럽게 "pop".
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  /// On-Surface 텍스트. "잉크 on 종이" 느낌 유지.
  static const Color onSurface = Color(0xFF1A1C1C);

  /// On-Surface 보조 텍스트 (60% 불투명도 대신 별도 토큰 사용).
  static const Color onSurfaceVariant = Color(0xFF44474E);

  // ─── Outline ────────────────────────────────────────────────────────────

  /// "Ghost Border" — 접근성 필요 시에만. 15% opacity로 사용.
  static const Color outlineVariant = Color(0xFFC6C5D4);

  // ─── Semantic ───────────────────────────────────────────────────────────

  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF1B5E20);

  // ─── Shadow ─────────────────────────────────────────────────────────────

  /// 앰비언트 그림자 색상 (primary tint, 6% opacity).
  /// Usage: BoxShadow(color: AppColors.shadowPrimary, blurRadius: 48)
  static const Color shadowPrimary = Color(0x0F1A237E);

  // ─── Gradient ───────────────────────────────────────────────────────────

  /// Hero CTA "Deep Ink" 그라디언트.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryContainer],
  );

  /// AppBar / 지도 상단 페이드 아웃 오버레이.
  static const LinearGradient mapTopFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.black54, Colors.transparent],
  );
}
