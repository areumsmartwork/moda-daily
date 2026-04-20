import 'package:flutter/material.dart' show DateTimeRange;
import 'package:photo_manager/photo_manager.dart';

import '../models/extraction_result.dart';

abstract class IPhotoService {
  Future<PermissionState> requestPermission();
  Future<void> openSettings();
  Future<List<AssetPathEntity>> getAlbums();
  Future<List<AssetEntity>> getPhotos(
    AssetPathEntity album, {
    int page,
    int pageSize,
  });
  Future<List<AssetEntity>> getPhotosByDateRange(
    AssetPathEntity album,
    DateTimeRange range, {
    int page,
    int pageSize,
  });
  Future<ExtractionResult> extractMetadata(
    List<AssetEntity> assets, {
    void Function(int current, int total)? onProgress,
  });
}
