import '../../controllers/archive_controller.dart';
import '../../controllers/caption_controller.dart';
import '../../controllers/extraction_controller.dart';
import '../../controllers/photo_selection_controller.dart';
import '../../interfaces/i_gallery_service.dart';
import '../../interfaces/i_map_service.dart';
import '../../interfaces/i_photo_service.dart';
import '../../interfaces/i_video_service.dart';
import '../../repositories/archive_repository.dart';
import '../../repositories/caption_repository.dart';
import '../../services/gallery_service.dart';
import '../../services/map_service.dart';
import '../../services/photo_service.dart';
import '../../services/video_service.dart';
import '../database/app_database.dart';

/// 앱 전역 의존성 컨테이너 (Singleton).
///
/// - AppDatabase / Repository / Service는 앱 생명주기 동안 단일 인스턴스를 공유한다.
/// - Controller는 화면 생명주기에 맞게 팩토리 메서드로 생성한다.
///   (ChangeNotifier이므로 화면 dispose 시 직접 dispose 필요)
///
/// 사용법:
/// ```dart
/// final ctrl = AppDependencies.instance.createArchiveController();
/// ```
class AppDependencies {
  AppDependencies._();
  static final AppDependencies instance = AppDependencies._();

  // ── 싱글톤 DB ─────────────────────────────────────────────────────────────

  final AppDatabase _db = AppDatabase();

  // ── 싱글톤 Repository ─────────────────────────────────────────────────────

  late final ArchiveRepository archiveRepository = ArchiveRepository(_db);
  late final CaptionRepository captionRepository = CaptionRepository(_db);

  // ── 싱글톤 Service ────────────────────────────────────────────────────────

  final IPhotoService photoService = const PhotoService();
  final IVideoService videoService = const VideoService();
  final IGalleryService galleryService = const GalleryService();
  final IMapService mapService = const MapService();

  // ── Controller 팩토리 (화면마다 새 인스턴스) ──────────────────────────────

  ArchiveController createArchiveController() =>
      ArchiveController(archiveRepository, videoService, galleryService)..init();

  CaptionController createCaptionController() =>
      CaptionController(captionRepository);

  PhotoSelectionController createPhotoSelectionController() =>
      PhotoSelectionController(photoService);

  ExtractionController createExtractionController() =>
      ExtractionController(photoService);
}
