import 'package:flutter/material.dart';

/// 앱 전역 스페이싱 & 형태(Shape) 토큰.
/// DESIGN.md "Elevation & Depth", "Components" 기반.
abstract final class AppSpacing {
  AppSpacing._();

  // ─── Spacing Scale ───────────────────────────────────────────────────────

  static const double s1 = 4.0;
  static const double s2 = 8.0;
  static const double s3 = 12.0;
  static const double s4 = 16.0;  // 기본 단위
  static const double s5 = 20.0;
  static const double s6 = 24.0;
  static const double s8 = 32.0;  // 여백 확대 (화면이 붐빌 때)
  static const double s10 = 40.0;
  static const double s12 = 48.0;
  static const double s16 = 64.0;

  // ─── Border Radius (Shape 8~24, DESIGN.md 기준) ──────────────────────────

  /// xs: 작은 UI 요소 (chip 내부 이미지 등)
  static const double radiusXs = 8.0;

  /// sm: 일반 카드, 입력 필드
  static const double radiusSm = 12.0;

  /// md: 대부분의 카드, 다이얼로그
  static const double radiusMd = 16.0;

  /// lg: 이미지 중심의 Travel Card — "cinematic frame"
  static const double radiusLg = 20.0;

  /// xl: 대형 미디어 카드
  static const double radiusXl = 24.0;

  /// full: pill 버튼, chip
  static const double radiusFull = 9999.0;

  // ─── BorderRadius 헬퍼 ───────────────────────────────────────────────────

  static BorderRadius get cardRadius =>
      BorderRadius.circular(radiusMd);

  static BorderRadius get travelCardRadius =>
      BorderRadius.circular(radiusXl);

  static BorderRadius get pillRadius =>
      BorderRadius.circular(radiusFull);

  static BorderRadius get bottomSheetRadius =>
      const BorderRadius.vertical(top: Radius.circular(radiusLg));

  // ─── Shadow (Ambient, primary tint 6%) ───────────────────────────────────

  /// 카드 기본 그림자 — 부드럽고 diffused.
  static List<BoxShadow> get cardShadow => const [
        BoxShadow(
          color: Color(0x0F1A237E), // primary @ 6%
          blurRadius: 24,
          offset: Offset(0, 4),
        ),
      ];

  /// 플로팅 요소 그림자 (비디오 플레이어, 모달).
  static List<BoxShadow> get floatingShadow => const [
        BoxShadow(
          color: Color(0x141A237E), // primary @ 8%
          blurRadius: 48,
          spreadRadius: 0,
          offset: Offset(0, 8),
        ),
      ];

  // ─── Glassmorphism ────────────────────────────────────────────────────────

  /// 지도 범례, 영상 컨트롤 오버레이용 글래스 효과 색상.
  /// backdrop-filter: blur(20px) 와 함께 사용.
  static const Color glassFill = Color(0xB3F9F9F9); // surface @ 70%
  static const double glassBlur = 20.0;
}

/// DESIGN.md ShapeTheme 토큰을 Material3 ShapeTheme으로 변환.
abstract final class AppShapes {
  AppShapes._();

  static ShapeDecoration card({double? radius}) => ShapeDecoration(
        color: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? AppSpacing.radiusMd),
        ),
        shadows: AppSpacing.cardShadow,
      );
}
