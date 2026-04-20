import 'dart:convert';

import '../core/database/app_database.dart';
import '../models/caption_style.dart';
import '../models/photo_caption.dart';

/// PhotoCaption CRUD — DB 접근의 유일한 창구.
class CaptionRepository {
  final AppDatabase _db;

  const CaptionRepository(this._db);

  /// assetId로 단건 조회. 없으면 null.
  Future<PhotoCaption?> findByAssetId(String assetId) async {
    final row = await (_db.select(_db.photoCaptions)
          ..where((t) => t.assetId.equals(assetId)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  /// 여러 assetId에 대한 캡션 일괄 조회.
  Future<Map<String, PhotoCaption>> findByAssetIds(List<String> ids) async {
    if (ids.isEmpty) return {};
    final rows = await (_db.select(_db.photoCaptions)
          ..where((t) => t.assetId.isIn(ids)))
        .get();
    return {for (final r in rows) r.assetId: _fromRow(r)};
  }

  /// 전체 캡션 조회.
  Future<List<PhotoCaption>> findAll() async {
    final rows = await _db.select(_db.photoCaptions).get();
    return rows.map(_fromRow).toList();
  }

  /// upsert — 없으면 insert, 있으면 update.
  Future<void> upsert(PhotoCaption caption) async {
    await _db.into(_db.photoCaptions).insertOnConflictUpdate(
          PhotoCaptionsCompanion.insert(
            assetId: caption.assetId,
            captionText: caption.text,
            styleJson: _styleToJson(caption.style),
            updatedAt: DateTime.now(),
          ),
        );
  }

  /// 캡션 삭제.
  Future<void> delete(String assetId) async {
    await (_db.delete(_db.photoCaptions)
          ..where((t) => t.assetId.equals(assetId)))
        .go();
  }

  // ── Private ──────────────────────────────────────────────────────────────────

  PhotoCaption _fromRow(PhotoCaptionRecord row) {
    return PhotoCaption(
      assetId: row.assetId,
      text: row.captionText,
      style: _styleFromJson(row.styleJson),
    );
  }

  String _styleToJson(CaptionStyle style) => jsonEncode(style.toJson());

  CaptionStyle _styleFromJson(String json) {
    try {
      return CaptionStyle.fromJson(
          jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return const CaptionStyle();
    }
  }
}
