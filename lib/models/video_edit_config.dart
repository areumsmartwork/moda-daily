/// 영상 편집 옵션.
/// JSON 직렬화는 [toJson]/[fromJson]으로 처리하여 DB에 저장한다.
class VideoEditConfig {
  /// 재생 속도 (1.0 = 기본, 2.0 = 2배속)
  final double speed;

  /// BGM 파일 경로 (앱 번들 또는 로컬 경로)
  final String? bgmPath;

  /// 트림 시작 시간 (초)
  final double? trimStart;

  /// 트림 종료 시간 (초)
  final double? trimEnd;

  /// FFmpeg 컬러 필터 문자열 (예: "hue=s=0" = 흑백)
  final String? colorFilter;

  const VideoEditConfig({
    this.speed = 1.0,
    this.bgmPath,
    this.trimStart,
    this.trimEnd,
    this.colorFilter,
  });

  Map<String, dynamic> toJson() => {
        'speed': speed,
        if (bgmPath != null) 'bgmPath': bgmPath,
        if (trimStart != null) 'trimStart': trimStart,
        if (trimEnd != null) 'trimEnd': trimEnd,
        if (colorFilter != null) 'colorFilter': colorFilter,
      };

  factory VideoEditConfig.fromJson(Map<String, dynamic> json) =>
      VideoEditConfig(
        speed: (json['speed'] as num?)?.toDouble() ?? 1.0,
        bgmPath: json['bgmPath'] as String?,
        trimStart: (json['trimStart'] as num?)?.toDouble(),
        trimEnd: (json['trimEnd'] as num?)?.toDouble(),
        colorFilter: json['colorFilter'] as String?,
      );

  String toJsonString() {
    final m = toJson();
    return m.entries
        .map((e) => '"${e.key}":${e.value is String ? '"${e.value}"' : e.value}')
        .join(',');
  }
}
