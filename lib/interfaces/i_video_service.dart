import 'package:photo_manager/photo_manager.dart';

import '../models/photo_caption.dart';
import '../models/video_edit_config.dart';

typedef VideoProgressCallback = void Function(double progress);

abstract class IVideoService {
  Future<String> exportVideo({
    required List<AssetEntity> assets,
    double durationPerPhoto,
    String outputFileName,
    Map<String, PhotoCaption>? captions,
    VideoProgressCallback? onProgress,
  });

  Future<String> applyEdit({
    required String sourceVideoPath,
    required VideoEditConfig config,
    VideoProgressCallback? onProgress,
  });

  Future<String> extractThumbnail(String videoPath);
}
