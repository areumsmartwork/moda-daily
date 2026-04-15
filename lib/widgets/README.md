# widgets

앱 전반에서 재사용되는 UI 위젯 모음.  
모든 위젯은 **순수 표시 위젯(dumb widget)** 원칙을 따르며, 비즈니스 로직 없이 생성자 인수로만 동작한다.

---

## 디렉토리 구조

```
widgets/
├── components/              # DESIGN.md 기반 디자인 시스템 컴포넌트
│   ├── index.dart           # barrel export (단일 import 진입점)
│   ├── app_top_bar.dart
│   ├── bottom_nav_bar.dart
│   ├── editorial_header.dart
│   ├── metadata_card.dart
│   └── primary_cta_button.dart
│
├── album_selector_sheet.dart
├── date_filter_bar.dart
├── extraction_progress_dialog.dart
├── map_photo_marker.dart
├── map_route_layer.dart
├── metadata_list_item.dart
├── metadata_summary_card.dart
├── photo_grid.dart
├── photo_grid_item.dart
├── photo_info_panel.dart
└── selection_bottom_bar.dart
```

---

## components/

[DESIGN.md](../../DESIGN.md) "Editorial Cartography" 디자인 시스템을 구현한 재사용 컴포넌트.  
`core/theme/`의 `AppColors`, `AppTypography`, `AppSpacing` 토큰만 참조한다.

```dart
import 'package:travel_map/widgets/components/index.dart';
```

### AppTopBar

브랜드 상단 바. `PreferredSizeWidget` 구현체로 `Scaffold.appBar`에 바로 사용한다.

| 인수 | 타입 | 설명 |
|---|---|---|
| `onBack` | `VoidCallback?` | null이면 뒤로가기 버튼 숨김 |
| `trailing` | `Widget?` | 우측 위젯 (아바타, 아이콘 등) |

`AppBarAvatar`를 `trailing`으로 전달하면 원형 아바타를 표시할 수 있다.

---

### AppBottomNavBar

글래스모피즘 하단 내비게이션 바.  
`BackdropFilter(blur: 20)` + `surface` 70% fill로 구현한다.

| 인수 | 타입 | 설명 |
|---|---|---|
| `currentTab` | `NavTab` | 현재 활성 탭 |
| `onTabSelected` | `ValueChanged<NavTab>` | 탭 변경 콜백 |

**NavTab** 값: `photos` · `metadata` · `map` · `export`

---

### EditorialHeader

화면 상단 섹션 레이블 + 대제목 + 서브타이틀 조합.

```
ARCHIVE SESSION      ← sessionLabel (all-caps, secondary 색상)
Metadata Logs        ← title (headlineLg, primary 색상)
14 items captured …  ← subtitle (bodyMd, onSurfaceVariant 색상)
```

| 인수 | 타입 | 설명 |
|---|---|---|
| `sessionLabel` | `String` | 상단 all-caps 레이블 |
| `title` | `String` | 메인 헤드라인 |
| `subtitle` | `String?` | 부가 설명 (생략 가능) |

---

### MetadataCard

사진 1장의 메타데이터를 표시하는 카드.  
88×88 썸네일 + 카메라 정보 + GPS 좌표(N/E 포맷) + 타임스탬프.

| 인수 | 타입 | 설명 |
|---|---|---|
| `metadata` | `PhotoMetadata` | GPS·카메라·시간 데이터 |
| `asset` | `AssetEntity?` | 썸네일용 에셋 (null이면 placeholder) |

---

### PrimaryCtaButton

그라디언트 pill 버튼. `primaryDark → primaryContainer` Deep Ink 그라디언트를 사용한다.

| 인수 | 타입 | 설명 |
|---|---|---|
| `label` | `String` | 버튼 텍스트 |
| `icon` | `IconData?` | 앞 아이콘 (생략 가능) |
| `onPressed` | `VoidCallback?` | null이면 비활성 |
| `expanded` | `bool` | 부모 너비 전체 사용 여부 (기본 `true`) |

---

## 개별 위젯

| 파일 | 용도 |
|---|---|
| `album_selector_sheet.dart` | 앨범 목록 바텀 시트 |
| `date_filter_bar.dart` | 날짜 범위 필터 칩 바 |
| `extraction_progress_dialog.dart` | 메타데이터 추출 진행 다이얼로그 |
| `map_photo_marker.dart` | 지도 위 사진 마커 |
| `map_route_layer.dart` | 여행 경로 폴리라인 레이어 |
| `metadata_list_item.dart` | 메타데이터 리스트 아이템 (레거시) |
| `metadata_summary_card.dart` | 추출 결과 요약 카드 (레거시) |
| `photo_grid.dart` | 사진 선택 그리드 |
| `photo_grid_item.dart` | 그리드 단일 아이템 (썸네일 + 선택 오버레이) |
| `photo_info_panel.dart` | 사진 상세 정보 패널 |
| `selection_bottom_bar.dart` | 사진 선택 화면 하단 고정 바 |

> `metadata_list_item`, `metadata_summary_card`는 `components/metadata_card`로 대체 예정인 레거시 위젯이다.
