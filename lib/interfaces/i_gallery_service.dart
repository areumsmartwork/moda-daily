import 'package:photo_manager/photo_manager.dart';

abstract class IGalleryService {
  Future<AssetEntity> saveVideoToGallery(
    String filePath, {
    String albumName,
  });

  Future<AssetEntity> saveImageToGallery(
    String filePath, {
    String albumName,
  });
}
