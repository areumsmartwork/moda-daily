import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

import '../core/database/app_database.dart';
import '../interfaces/i_archive_view_model.dart';
import '../interfaces/i_gallery_service.dart';
import '../interfaces/i_video_service.dart';
import '../models/photo_caption.dart';
import '../models/photo_metadata.dart';
import '../models/video_edit_config.dart';
import '../repositories/archive_repository.dart';

/// 숏폼 영상 생성 → GPS 연결 → DB 저장 → 갤러리 저장을 오케스트레이션.
///
/// UI는 [IArchiveViewModel] 인터페이스만 통해 이 Controller와 상호작용한다.
class ArchiveController extends ChangeNotifier implements IArchiveViewModel {
  final ArchiveRepository _repo;
  final IVideoService _videoService;
  final IGalleryService _galleryService;

  ArchiveController(this._repo, this._videoService, this._galleryService);

  // ── 상태 ──────────────────────────────────────────────────────────────────

  ArchiveState _state = const ArchiveState.idle();
  ArchiveState get state => _state;

  List<VideoArchive> _archives = [];
  List<VideoArchive> get archives => List.unmodifiable(_archives);

  final Map<int, List<VideoEditHistoryData>> _editHistories = {};

  // ── 초기화 ────────────────────────────────────────────────────────────────

  void init() {
    _repo.watchAll().listen((list) {
      _archives = list;
      notifyListeners();
    });
  }

  // ── 영상 생성 ──────────────────────────────────────────────────────────────

  @override
  Future<void> create({
    required List<dynamic> assets,
    required List<PhotoMetadata> metadataList,
    required String title,
    double durationPerPhoto = 2.0,
    Map<String, PhotoCaption>? captions,
  }) async {
    final typedAssets = assets.cast<AssetEntity>();
    _emit(const ArchiveState.creating(progress: 0.0));

    try {
      final videoPath = await _videoService.exportVideo(
        assets: typedAssets,
        durationPerPhoto: durationPerPhoto,
        outputFileName: _sanitizeFileName(title),
        captions: captions,
        onProgress: (p) => _emit(ArchiveState.creating(progress: p * 0.8)),
      );

      _emit(const ArchiveState.creating(progress: 0.85));
      final thumbPath = await _videoService.extractThumbnail(videoPath);

      _emit(const ArchiveState.creating(progress: 0.9));
      final archiveId = await _repo.insert(
        title: title,
        videoPath: videoPath,
        thumbnailPath: thumbPath,
        createdAt: DateTime.now(),
        durationSeconds: (durationPerPhoto * typedAssets.length).ceil(),
        gpsPointCount: metadataList.length,
      );

      await _repo.insertGpsPoints(
        archiveId,
        metadataList.asMap().entries.map((e) => GpsPointInput(
              latitude: e.value.latitude,
              longitude: e.value.longitude,
              altitude: e.value.altitude,
              capturedAt: e.value.capturedAt,
              photoAssetId: e.value.assetId,
              orderIndex: e.key,
            )).toList(),
      );

      _emit(const ArchiveState.creating(progress: 0.95));
      try {
        await _galleryService.saveVideoToGallery(videoPath);
      } catch (_) {}

      _emit(ArchiveState.done(archiveId: archiveId));
    } catch (e) {
      _emit(ArchiveState.error(message: e.toString()));
    }
  }

  // ── 영상 편집 ──────────────────────────────────────────────────────────────

  @override
  Future<void> applyEdit({
    required int archiveId,
    required VideoEditConfig config,
  }) async {
    final archive = await _repo.findById(archiveId);
    if (archive == null) {
      _emit(const ArchiveState.error(message: '아카이브를 찾을 수 없습니다.'));
      return;
    }

    _emit(const ArchiveState.editing(progress: 0.0));

    try {
      final newPath = await _videoService.applyEdit(
        sourceVideoPath: archive.videoPath,
        config: config,
        onProgress: (p) => _emit(ArchiveState.editing(progress: p * 0.9)),
      );

      await _repo.saveEdit(
        archiveId: archiveId,
        newVideoPath: newPath,
        editConfigJson: jsonEncode(config.toJson()),
      );

      try {
        await _galleryService.saveVideoToGallery(newPath);
      } catch (_) {}

      _emit(ArchiveState.done(archiveId: archiveId));
    } catch (e) {
      _emit(ArchiveState.error(message: e.toString()));
    }
  }

  // ── 편집 이력 / 롤백 ──────────────────────────────────────────────────────

  @override
  Future<List<VideoGpsPoint>> getGpsPoints(int archiveId) =>
      _repo.getGpsPoints(archiveId);

  @override
  Future<List<VideoEditHistoryData>> loadEditHistory(int archiveId) async {
    final history = await _repo.getEditHistory(archiveId);
    _editHistories[archiveId] = history;
    notifyListeners();
    return history;
  }

  @override
  Future<void> rollback(int archiveId, int version) async {
    _emit(const ArchiveState.editing(progress: 0.0));
    try {
      await _repo.rollbackToVersion(archiveId, version);
      _emit(ArchiveState.done(archiveId: archiveId));
    } catch (e) {
      _emit(ArchiveState.error(message: e.toString()));
    }
  }

  // ── 삭제 ──────────────────────────────────────────────────────────────────

  @override
  Future<void> delete(int archiveId) async {
    await _repo.delete(archiveId);
    notifyListeners();
  }

  // ── 상태 초기화 ────────────────────────────────────────────────────────────

  @override
  void resetState() => _emit(const ArchiveState.idle());

  // ── Private ────────────────────────────────────────────────────────────────

  void _emit(ArchiveState next) {
    _state = next;
    notifyListeners();
  }

  static String _sanitizeFileName(String title) {
    return title.replaceAll(RegExp(r'[^\w가-힣]'), '_').toLowerCase();
  }
}

// ── 상태 모델 ──────────────────────────────────────────────────────────────────

sealed class ArchiveState {
  const ArchiveState();

  const factory ArchiveState.idle() = ArchiveStateIdle;
  const factory ArchiveState.creating({required double progress}) = ArchiveStateCreating;
  const factory ArchiveState.editing({required double progress}) = ArchiveStateEditing;
  const factory ArchiveState.done({required int archiveId}) = ArchiveStateDone;
  const factory ArchiveState.error({required String message}) = ArchiveStateError;
}

class ArchiveStateIdle extends ArchiveState {
  const ArchiveStateIdle();
}

class ArchiveStateCreating extends ArchiveState {
  final double progress;
  const ArchiveStateCreating({required this.progress});
}

class ArchiveStateEditing extends ArchiveState {
  final double progress;
  const ArchiveStateEditing({required this.progress});
}

class ArchiveStateDone extends ArchiveState {
  final int archiveId;
  const ArchiveStateDone({required this.archiveId});
}

class ArchiveStateError extends ArchiveState {
  final String message;
  const ArchiveStateError({required this.message});
}
