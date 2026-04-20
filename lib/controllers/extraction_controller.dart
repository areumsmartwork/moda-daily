import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

import '../interfaces/i_extraction_view_model.dart';
import '../interfaces/i_photo_service.dart';
import '../models/extraction_result.dart';

/// 메타데이터 추출 작업의 상태를 관리한다.
///
/// UI는 [IExtractionViewModel] 인터페이스만 통해 이 Controller와 상호작용한다.
class ExtractionController extends ChangeNotifier
    implements IExtractionViewModel {
  final IPhotoService _photoService;

  ExtractionController(this._photoService);

  // ─── 상태 ─────────────────────────────────────────────────────────────────

  bool _isExtracting = false;
  int _progress = 0;
  int _total = 0;
  ExtractionResult? _result;
  String? _errorMessage;

  // ─── Getters ──────────────────────────────────────────────────────────────

  bool get isExtracting => _isExtracting;
  int get progress => _progress;
  int get total => _total;
  ExtractionResult? get result => _result;
  String? get errorMessage => _errorMessage;

  double get progressRatio => _total > 0 ? _progress / _total : 0.0;
  String get progressText => '$_progress / $_total';

  // ─── 추출 실행 ────────────────────────────────────────────────────────────

  Future<void> extract(List<AssetEntity> assets) async {
    if (_isExtracting || assets.isEmpty) return;

    _isExtracting = true;
    _progress = 0;
    _total = assets.length;
    _result = null;
    _errorMessage = null;
    notifyListeners();

    try {
      _result = await _photoService.extractMetadata(
        assets,
        onProgress: (current, total) {
          _progress = current;
          _total = total;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = '추출 중 오류가 발생했습니다: $e';
    } finally {
      _isExtracting = false;
      notifyListeners();
    }
  }

  void reset() {
    _isExtracting = false;
    _progress = 0;
    _total = 0;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }
}
