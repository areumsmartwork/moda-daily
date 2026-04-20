import 'dart:convert';

import 'caption_style.dart';

/// 단일 사진에 연결된 캡션 문구와 스타일.
class PhotoCaption {
  final String assetId;
  final String text;
  final CaptionStyle style;

  const PhotoCaption({
    required this.assetId,
    required this.text,
    required this.style,
  });

  PhotoCaption copyWith({String? text, CaptionStyle? style}) => PhotoCaption(
        assetId: assetId,
        text: text ?? this.text,
        style: style ?? this.style,
      );

  Map<String, dynamic> toJson() => {
        'assetId': assetId,
        'text': text,
        'style': style.toJson(),
      };

  factory PhotoCaption.fromJson(Map<String, dynamic> json) => PhotoCaption(
        assetId: json['assetId'] as String,
        text: json['text'] as String,
        style: CaptionStyle.fromJson(
            json['style'] as Map<String, dynamic>),
      );

  String toJsonString() => jsonEncode(toJson());
  factory PhotoCaption.fromJsonString(String s) =>
      PhotoCaption.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
