import 'dart:ui';

/// 캡션 폰트 스타일 종류.
/// FFmpeg drawtext의 fontfile과 매핑된다.
enum CaptionFontStyle {
  bold,        // 굵은 고딕 (기본)
  sansSerif,   // 기본 고딕
  serif,       // 명조체
  handwriting, // 손글씨풍
}

/// 캡션 출력 위치
enum CaptionPosition { top, center, bottom }

/// 캡션의 시각적 스타일을 정의한다.
/// [toJson]/[fromJson]으로 DB에 저장된다.
class CaptionStyle {
  final CaptionFontStyle fontStyle;
  final double fontSize;

  /// 0xAARRGGBB 형식 텍스트 색상
  final int textColorHex;

  /// 0xAARRGGBB 형식 배경 박스 색상 (alpha 0 = 배경 없음)
  final int bgColorHex;

  final CaptionPosition position;

  const CaptionStyle({
    this.fontStyle = CaptionFontStyle.bold,
    this.fontSize = 44,
    this.textColorHex = 0xFFFFFFFF,
    this.bgColorHex = 0x99000000,
    this.position = CaptionPosition.bottom,
  });

  // ── 프리셋 ──────────────────────────────────────────────────────────────────

  /// 흰 굵은 글씨 + 반투명 검정 박스 (기본)
  static const CaptionStyle modern = CaptionStyle(
    fontStyle: CaptionFontStyle.bold,
    fontSize: 44,
    textColorHex: 0xFFFFFFFF,
    bgColorHex: 0x99000000,
    position: CaptionPosition.bottom,
  );

  /// 노란 글씨 + 배경 없음
  static const CaptionStyle neon = CaptionStyle(
    fontStyle: CaptionFontStyle.bold,
    fontSize: 48,
    textColorHex: 0xFFFFEB3B,
    bgColorHex: 0x00000000,
    position: CaptionPosition.bottom,
  );

  /// 흰 명조체 + 어두운 반투명 박스
  static const CaptionStyle elegant = CaptionStyle(
    fontStyle: CaptionFontStyle.serif,
    fontSize: 40,
    textColorHex: 0xFFF5F5F5,
    bgColorHex: 0xCC1A1A1A,
    position: CaptionPosition.bottom,
  );

  /// 하늘색 손글씨 + 배경 없음
  static const CaptionStyle casual = CaptionStyle(
    fontStyle: CaptionFontStyle.handwriting,
    fontSize: 46,
    textColorHex: 0xFF81D4FA,
    bgColorHex: 0x00000000,
    position: CaptionPosition.bottom,
  );

  // ── 직렬화 ──────────────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'fontStyle': fontStyle.name,
        'fontSize': fontSize,
        'textColorHex': textColorHex,
        'bgColorHex': bgColorHex,
        'position': position.name,
      };

  factory CaptionStyle.fromJson(Map<String, dynamic> json) => CaptionStyle(
        fontStyle: CaptionFontStyle.values.firstWhere(
          (e) => e.name == json['fontStyle'],
          orElse: () => CaptionFontStyle.bold,
        ),
        fontSize: (json['fontSize'] as num?)?.toDouble() ?? 44,
        textColorHex: (json['textColorHex'] as int?) ?? 0xFFFFFFFF,
        bgColorHex: (json['bgColorHex'] as int?) ?? 0x99000000,
        position: CaptionPosition.values.firstWhere(
          (e) => e.name == json['position'],
          orElse: () => CaptionPosition.bottom,
        ),
      );

  CaptionStyle copyWith({
    CaptionFontStyle? fontStyle,
    double? fontSize,
    int? textColorHex,
    int? bgColorHex,
    CaptionPosition? position,
  }) =>
      CaptionStyle(
        fontStyle: fontStyle ?? this.fontStyle,
        fontSize: fontSize ?? this.fontSize,
        textColorHex: textColorHex ?? this.textColorHex,
        bgColorHex: bgColorHex ?? this.bgColorHex,
        position: position ?? this.position,
      );

  // ── UI 헬퍼 ─────────────────────────────────────────────────────────────────

  Color get textColor => Color(textColorHex);
  Color get bgColor => Color(bgColorHex);
  bool get hasBg => (bgColorHex >> 24) & 0xFF > 0;
}

/// 프리셋 목록 (설정 UI에서 사용)
const List<({String label, CaptionStyle style})> kCaptionStylePresets = [
  (label: '모던', style: CaptionStyle.modern),
  (label: '네온', style: CaptionStyle.neon),
  (label: '엘레강트', style: CaptionStyle.elegant),
  (label: '캐주얼', style: CaptionStyle.casual),
];
