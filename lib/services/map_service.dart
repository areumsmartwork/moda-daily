import '../interfaces/i_map_service.dart';

/// Geocoding API 통신 서비스 (F-4에서 구현).
/// GPS 좌표 → 실제 장소명 변환을 담당한다.
class MapService implements IMapService {
  const MapService();

  // TODO(F-4): Google Maps Geocoding API 키를 환경 변수로 주입
  // static const _apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  @override
  Future<String> reverseGeocode(double lat, double lng) async {
    // TODO(F-4): HTTP 호출로 교체
    return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  }
}
