# lib/interfaces — 계약 레이어 (Contract Layer)

이 디렉토리는 앱 전체의 **의존성 방향을 제어하는 단일 진실 공급원(single source of truth)** 이다.  
View → Interface ← Controller, Screen → Interface ← Service 구조를 통해  
구체 구현이 교체되어도 UI 코드는 수정 없이 동작한다.

---

## 설계 원칙

| 원칙 | 내용 |
|---|---|
| **단방향 의존** | View·Screen은 Interface만 import한다. 구체 클래스 이름은 등장하지 않는다. |
| **Listenable 상속** | ViewModel 인터페이스는 `implements Listenable`로 `ListenableBuilder`에 직접 사용 가능하다. |
| **구현 없음** | 이 파일들은 시그니처만 선언한다. 로직·상태·import 금지. |
| **교체 가능성** | 테스트용 Fake, 목업 서버 구현체 등 언제든 새 클래스를 꽂을 수 있다. |

---

## ViewModel 인터페이스 (View ↔ Controller 계약)

Flutter에서 Custom Hook의 반환 타입에 해당한다.  
`ChangeNotifier`를 직접 노출하지 않고, `Listenable`만 보장한다.

| 파일 | 인터페이스 | 구체 구현 | 주요 책임 |
|---|---|---|---|
| `i_photo_selection_view_model.dart` | `IPhotoSelectionViewModel` | `PhotoSelectionController` | 앨범 탐색, 사진 선택, 권한 상태 |
| `i_extraction_view_model.dart` | `IExtractionViewModel` | `ExtractionController` | GPS/EXIF 추출 진행률·결과 |
| `i_travel_map_view_model.dart` | `ITravelMapViewModel` | `TravelMapController` | 지도 마커·경로·타임라인 재생·마커 스타일 |
| `i_caption_view_model.dart` | `ICaptionViewModel` | `CaptionController` | 사진 캡션 CRUD·스타일 관리 |
| `i_archive_view_model.dart` | `IArchiveViewModel` | `ArchiveController` | 영상 생성·편집·롤백·삭제 오케스트레이션 |

### ViewModel 공통 계약

```dart
abstract class IXxxViewModel implements Listenable {
  // 상태 Getter (동기, 순수 읽기)
  SomeState get state;

  // 액션 (비동기 가능, 상태를 변경하고 notifyListeners 호출)
  Future<void> doSomething();
}
```

---

## Service 인터페이스 (Controller ↔ Service 계약)

Controller는 구체 서비스 클래스를 모른다.  
`AppDependencies`가 싱글톤 구현체를 생성하고 생성자 주입으로 전달한다.

| 파일 | 인터페이스 | 구체 구현 | 주요 책임 |
|---|---|---|---|
| `i_photo_service.dart` | `IPhotoService` | `PhotoService` | 갤러리 접근, 권한 요청, EXIF/GPS 추출 |
| `i_video_service.dart` | `IVideoService` | `VideoService` | FFmpeg MP4 생성·편집, 썸네일 추출 |
| `i_gallery_service.dart` | `IGalleryService` | `GalleryService` | 완성된 영상을 카메라 롤·앨범에 저장 |
| `i_map_service.dart` | `IMapService` | `MapService` | GPS 좌표 → 장소명 역지오코딩 (F-4 예정) |

### Service 공통 계약

```dart
abstract class IXxxService {
  // 부수 효과를 포함한 비동기 작업만 선언
  // 상태를 보유하지 않음 (const 구현체)
  Future<Result> doExternalWork(...);
}
```

---

## 의존성 흐름 요약

```
View (Screen/Widget)
  │  ListenableBuilder(listenable: IXxxViewModel)
  ▼
IXxxViewModel  ←────────────────  IXxxService
  ▲                                    ▲
  │  implements                        │  implements
  │                                    │
XxxController ──────────── uses ──── XxxService
(ChangeNotifier)                    (const class)
        │
        │  생성자 주입
        ▼
  AppDependencies  (Singleton DI)
```

---

## 새 인터페이스 추가 방법

1. `lib/interfaces/i_xxx.dart` 파일 생성
2. `abstract class IXxx` 선언 (ViewModel이면 `implements Listenable` 추가)
3. 구체 클래스에서 `implements IXxx` 추가 후 메서드 구현
4. `AppDependencies`에 싱글톤 또는 팩토리 등록
5. 이 README의 테이블에 한 줄 추가
