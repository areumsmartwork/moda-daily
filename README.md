# TravelMap ArchiVer

> 스마트폰 사진첩의 GPS·시간 메타데이터를 기반으로 여행 경로를 지도 위에 시각화하고, 사진 캡션을 입력하고, 숏폼 영상으로 내보내는 크로스플랫폼(iOS/Android) 모바일 앱.

---

## 구현 현황

| 단계 | 기능 | 상태 |
|------|------|------|
| **F-1** | 사진·영상 선택 + GPS/시간/카메라 메타데이터 추출 | ✅ 완료 |
| **F-2** | 지도 시각화 (클러스터링, 경로선, 마커 스타일 커스터마이징) | ✅ 완료 |
| **F-3** | 숏폼 영상 생성·편집·아카이브 (FFmpeg) | ✅ 완료 |
| **F-3+** | 사진 캡션 입력 + 영상 텍스트 오버레이 | ✅ 완료 |
| **F-3+** | 타임라인 재생 (여행 회상 모드) | ✅ 완료 |
| **F-4** | AI 자막 생성 (Geocoding + LLM) | 🔜 예정 |

---

## 기술 스택

| 분류 | 선택 |
|------|------|
| Framework | Flutter (Dart 3) |
| 최소 OS | iOS 16+, Android 10 (API 29)+ |
| 사진첩 접근 | `photo_manager ^3.3.0` |
| EXIF 파싱 | `exif ^3.3.0` |
| 지도 SDK | `flutter_map ^8.2.2` + OpenStreetMap |
| 좌표 타입 | `latlong2 ^0.9.1` |
| 영상 편집 | `ffmpeg_kit_flutter_new ^4.1.0` |
| 로컬 DB | `drift ^2.32.1` + `drift_flutter ^0.3.0` |
| 영상 재생 | `video_player ^2.11.1` |
| 폰트 | `google_fonts ^8.0.2` |
| 날짜 포맷 | `intl ^0.20.2` |
| Geocoding | Google Maps Geocoding API (F-4 예정) |

---

## 아키텍처

**Business Logic / View 엄격 분리** 원칙으로 4개 레이어 + Interface 계층으로 구성한다.

```
┌─────────────────────────────────────────────────────────────┐
│  View  (Screen / Widget)                                    │
│                                                             │
│  의존 타입: Interface만 (구체 Controller 클래스 모름)            │
└──────────────────┬──────────────────────────────────────────┘
                   │  implements
┌──────────────────▼──────────────────────────────────────────┐
│  Interface  (lib/interfaces/)   ← Hook 반환 타입에 해당        │
│                                                             │
│  IArchiveViewModel       ICaptionViewModel                  │
│  ITravelMapViewModel     IPhotoSelectionViewModel           │
│  IExtractionViewModel                                       │
│                                                             │
│  모두 Listenable → ListenableBuilder에 직접 사용 가능           │
└──────────────────┬──────────────────────────────────────────┘
                   │  implements (구체 구현)
┌──────────────────▼──────────────────────────────────────────┐
│  Controller  (lib/controllers/)  = Business Logic           │
│                                                             │
│  ArchiveController       CaptionController                  │
│  TravelMapController     PhotoSelectionController           │
│  ExtractionController                                       │
│                                                             │
│  extends ChangeNotifier implements I*ViewModel              │
│  Service / Repository 호출, 상태 계산, 에러 처리               │
└──────────────────┬──────────────────────────────────────────┘
                   │  uses
┌──────────────────▼──────────────────────────────────────────┐
│  Service / Repository                                       │
│                                                             │
│  PhotoService   VideoService   GalleryService               │
│  ArchiveRepository   CaptionRepository                      │
└──────────────────┬──────────────────────────────────────────┘
                   │  uses (singleton)
┌──────────────────▼──────────────────────────────────────────┐
│  AppDependencies  (lib/core/di/)  = Singleton DI            │
│                                                             │
│  AppDatabase — 앱 전체 단일 인스턴스                            │
│  archiveRepository, captionRepository — 공유 싱글톤           │
│  createArchiveController()  createCaptionController()  ...  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  Style Library  (lib/core/theme/)  = 스타일 전용              │
│                                                             │
│  AppColors      — 색상 토큰 (검정/흰색 직접 사용 금지)           │
│  AppTypography  — display/headline/title/body/label 계층     │
│  AppSpacing     — 8pt grid, borderRadius, shadow            │
└─────────────────────────────────────────────────────────────┘
```

### 레이어 책임 원칙

| 레이어 | 책임 | 금지 사항 |
|---|---|---|
| **Style** | 색상·타입·간격 토큰 정의 | 로직 포함 |
| **Widget** | Constructor로만 데이터 주입받는 순수 UI | Controller/Service 직접 참조 |
| **Screen** | Interface 구독(Watch), 레이아웃 조합, 라우팅 | 구체 Controller/Repository 직접 `new` |
| **Interface** | ViewModel 공개 계약 (getter + async method 시그니처) | 구현 |
| **Controller** | 상태 관리, Service 호출, 에러 처리 | BuildContext / Widget import |
| **Service** | 외부 환경 통신 (갤러리, FFmpeg, DB) | 상태 보유 |
| **AppDependencies** | AppDatabase 싱글톤, Repository 공유, Controller 팩토리 | — |

---

## 파일 구조

```
lib/
├── main.dart
│
├── core/
│   ├── database/
│   │   ├── app_database.dart          # drift DB 정의 (VideoArchives, VideoGpsPoints,
│   │   │                              #   VideoEditHistory, PhotoCaptions 테이블)
│   │   └── app_database.g.dart        # drift 자동 생성 코드
│   ├── di/
│   │   └── app_dependencies.dart      # Singleton DI — AppDatabase·Repository 공유
│   └── theme/
│       ├── app_colors.dart            # 색상 토큰
│       ├── app_typography.dart        # 타이포그래피 시스템
│       ├── app_spacing.dart           # 간격·반경·그림자
│       ├── app_theme.dart             # MaterialApp 테마 조합
│       └── index.dart
│
├── interfaces/                        # ViewModel 계약 (Hook 반환 타입)
│   ├── i_archive_view_model.dart
│   ├── i_caption_view_model.dart
│   ├── i_travel_map_view_model.dart
│   ├── i_photo_selection_view_model.dart
│   └── i_extraction_view_model.dart
│
├── models/
│   ├── photo_metadata.dart            # 사진/영상 메타데이터 + AssetMediaType
│   ├── extraction_result.dart         # 추출 결과 집계
│   ├── marker_style.dart              # 지도 마커 스타일 (thumbnail / icon / userPhoto)
│   ├── caption_style.dart             # 캡션 스타일 (폰트·색상·위치 + 프리셋 4종)
│   └── photo_caption.dart             # 사진 캡션 (assetId + text + CaptionStyle)
│
├── services/
│   ├── photo_service.dart             # 갤러리 접근 + GPS EXIF 파싱
│   ├── video_service.dart             # FFmpeg 렌더링 + caption drawtext 오버레이
│   ├── gallery_service.dart           # 갤러리 저장
│   └── map_service.dart               # Geocoding API (F-4)
│
├── repositories/
│   ├── archive_repository.dart        # VideoArchive CRUD + GPS포인트 + 편집이력
│   └── caption_repository.dart        # PhotoCaption upsert / 조회 / 삭제
│
├── controllers/
│   ├── photo_selection_controller.dart  # implements IPhotoSelectionViewModel
│   ├── extraction_controller.dart       # implements IExtractionViewModel
│   ├── travel_map_controller.dart       # implements ITravelMapViewModel
│   │                                    #   (클러스터링·마커선택·타임라인재생·마커스타일)
│   ├── caption_controller.dart          # implements ICaptionViewModel
│   └── archive_controller.dart          # implements IArchiveViewModel
│                                        #   (영상생성·편집·롤백·삭제 오케스트레이션)
│
├── screens/
│   ├── home_screen.dart
│   ├── photo_selection_screen.dart
│   ├── metadata_result_screen.dart
│   ├── travel_map_screen.dart           # 지도·마커·경로·캡션·타임라인재생·영상생성
│   ├── archive_list_screen.dart         # 저장된 영상 목록
│   └── video_detail_screen.dart         # 영상 재생·GPS 경로·편집·롤백
│
└── widgets/
    ├── photo_grid.dart
    ├── photo_grid_item.dart             # StatefulWidget — 썸네일 캐시, 영상 배지
    ├── album_selector_sheet.dart
    ├── date_filter_bar.dart
    ├── selection_bottom_bar.dart
    ├── extraction_progress_dialog.dart
    ├── metadata_summary_card.dart
    ├── metadata_list_item.dart
    ├── map_route_layer.dart             # 경로선 Polyline 레이어
    ├── map_photo_marker.dart            # ITravelMapViewModel 의존 (캐시 전용)
    ├── photo_info_panel.dart            # 마커 탭 하단 패널 + 캡션 표시/편집 진입
    └── caption_input_sheet.dart         # 캡션 입력 바텀시트 + 스타일 프리셋 + 미리보기
    └── components/
        ├── video_progress_sheet.dart    # 영상 생성/편집 진행 상태 시트
        ├── archive_card.dart
        ├── video_player_card.dart
        ├── primary_cta_button.dart
        └── ...
```

---

## 화면 흐름

```
HomeScreen
  ├─ "여행 사진 선택하기"
  │    └─ PhotoSelectionScreen  (앨범 탐색 · 날짜 필터 · 사진+영상 멀티셀렉트)
  │         └─ "지도에 그리기"
  │              └─ ExtractionProgressDialog
  │                   └─ MetadataResultScreen  (요약 카드 · 시간순 목록)
  │                        └─ "지도에서 보기"
  │                             └─ TravelMapScreen
  │                                  ├─ 마커 탭 → PhotoInfoPanel
  │                                  │    └─ "문구 추가하기" → CaptionInputSheet
  │                                  ├─ 재생 버튼 → 타임라인 재생 (여행 회상 모드)
  │                                  ├─ 마커 스타일 버튼 → 스타일 선택 시트
  │                                  └─ "영상 만들기" → VideoProgressSheet
  │                                       └─ "보관함 보기" → ArchiveListScreen
  └─ "보관함"
       └─ ArchiveListScreen  (저장된 영상 목록)
            └─ 카드 탭 → VideoDetailScreen
                          ├─ 영상 재생
                          ├─ GPS 경로 미니맵
                          ├─ 편집 패널 (재생속도)
                          └─ 편집 이력 · 롤백
```

---

## 주요 기능 상세

### 마커 스타일 커스터마이징
- `MarkerStyle` 모델: `thumbnail` / `icon` / `userPhoto` 타입으로 확장 가능
- 프리셋 5종: 사진 썸네일, 스마일, 핀, 카메라, 별
- 지도 AppBar의 스타일 버튼 → 바텀시트에서 선택

### 타임라인 재생 (여행 회상 모드)
- 시간순 정렬된 사진을 2초 간격으로 자동 순회
- 마커 전환 시 지도 카메라 자동 이동
- 재생 중 하단 컨트롤 바: 진행률, 일시정지/재개, 정지

### 사진 캡션 + 영상 텍스트 오버레이
- 지도 화면에서 마커 탭 → 하단 패널의 "문구 추가하기"
- `CaptionInputSheet`: 텍스트 입력, 스타일 프리셋(모던/네온/엘레강트/캐주얼), 실시간 미리보기
- 캡션은 SQLite(`PhotoCaptions` 테이블)에 영구 저장
- 영상 생성 시 FFmpeg `drawtext` 필터로 해당 사진 구간에 오버레이

### 영상 생성 파이프라인
```
사진 에셋 목록
  → VideoService.exportVideo()        # FFmpeg concat + scale/pad 9:16
  → _buildCaptionFilter()             # drawtext 오버레이 (캡션 있는 사진만)
  → VideoService.extractThumbnail()   # 첫 프레임 JPEG
  → ArchiveRepository.insert()        # DB 저장
  → GalleryService.saveVideoToGallery() # 갤러리 저장
```

---

## 설치 및 실행

```bash
# 1. 의존성 설치
flutter pub get

# 2. drift 코드 생성 (DB 스키마 변경 후 필요)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. 실행
flutter devices
flutter run -d <device_id>
```

### 플랫폼 권한

**Android** (`AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.ACCESS_MEDIA_LOCATION" />
```

**iOS** (`Info.plist`)
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>여행 사진의 GPS 정보를 읽어 경로를 그립니다</string>
```

---

## 데이터 보안 원칙

모든 사진 데이터와 메타데이터는 **기기 내에서만 처리**된다.  
메타데이터 추출·영상 렌더링·GPS 경로 저장 전 과정이 로컬에서 완결된다.  
서버 전송은 F-4 AI 자막 단계에서 처리 방식을 결정한다.
