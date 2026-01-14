# 🎮 Tetris Game

Flutter와 Flame 엔진을 사용하여 개발한 클래식 테트리스 게임입니다. 클린 아키텍처 3계층 구조로 설계되어 확장 가능하고 유지보수가 용이합니다.

## 📋 목차

- [주요 기능](#주요-기능)
- [기술 스택](#기술-스택)
- [아키텍처](#아키텍처)
- [프로젝트 구조](#프로젝트-구조)
- [설치 및 실행](#설치-및-실행)
- [테스트](#테스트)
- [게임 플레이](#게임-플레이)
- [개발 가이드](#개발-가이드)

## ✨ 주요 기능

### 게임 기능
- ✅ 7가지 테트로미노 (I, O, T, S, Z, J, L)
- ✅ 블록 이동, 회전, 낙하
- ✅ 라인 클리어 및 점수 계산
- ✅ 레벨 시스템 (10줄마다 레벨 업, 속도 증가)
- ✅ 다음 블록 미리보기
- ✅ 게임 오버 처리
- ✅ 일시정지 기능

### 데이터 관리
- ✅ 로컬 DB 저장 (Hive)
- ✅ 최고 점수 저장
- ✅ 게임 상태 저장/로드

### 플랫폼 지원
- ✅ 모바일 (iOS, Android)
- ✅ 데스크톱 (Windows, macOS, Linux)
- ✅ 웹 (Web)

### 입력 지원
- ✅ 키보드 입력 (데스크톱)
- ✅ 터치 입력 (모바일)
- ✅ 화면 컨트롤 버튼

## 🛠 기술 스택

- **Flutter**: 크로스 플랫폼 프레임워크
- **Flame**: 2D 게임 엔진
- **Hive**: 로컬 NoSQL 데이터베이스
- **GetIt**: 의존성 주입
- **Equatable**: 객체 비교 유틸리티

## 🏗 아키텍처

이 프로젝트는 **클린 아키텍처 3계층 구조**를 따릅니다.

### 계층 구조

```
┌─────────────────────────────────────┐
│   Presentation Layer                │
│   (UI, Game, Components, Managers)  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Domain Layer                      │
│   (Entities, Use Cases,            │
│    Repository Interfaces)           │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Data Layer                        │
│   (Models, DataSources,             │
│    Repository Implementations)      │
└─────────────────────────────────────┘
```

### 계층별 역할

#### 1. Domain Layer (비즈니스 로직)
- **Entities**: 게임의 핵심 데이터 구조
  - `GameScore`: 점수 정보
  - `GameState`: 게임 상태
  - `TetrominoType`: 테트로미노 타입

- **Repository Interfaces**: 데이터 접근 추상화
  - `GameRepository`: 게임 데이터 저장/로드 인터페이스

- **Use Cases**: 단일 책임 비즈니스 로직
  - `SaveGameScore`: 점수 저장
  - `GetHighScore`: 최고 점수 조회
  - `SaveGameState`: 게임 상태 저장
  - `LoadGameState`: 게임 상태 로드

#### 2. Data Layer (데이터 소스)
- **Models**: Hive 데이터 모델
  - `GameScoreModel`: 점수 데이터 모델
  - `GameStateModel`: 게임 상태 데이터 모델

- **Data Sources**: 로컬 DB 접근
  - `GameLocalDataSource`: Hive를 통한 데이터 저장/로드

- **Repository Implementations**: Repository 인터페이스 구현
  - `GameRepositoryImpl`: 실제 데이터 처리

#### 3. Presentation Layer (UI 및 게임 로직)
- **Game**: Flame 게임 엔진
  - `TetrisGame`: 메인 게임 클래스

- **Components**: 게임 컴포넌트
  - `BoardComponent`: 게임 보드 렌더링
  - `NextPieceComponent`: 다음 블록 미리보기

- **Managers**: 게임 상태 관리
  - `GameStateManager`: 게임 로직 및 상태 관리

- **Widgets**: Flutter UI 위젯
  - `GameHUD`: 점수, 레벨 표시
  - `GameControls`: 게임 컨트롤 버튼

## 📁 프로젝트 구조

```
lib/
├── main.dart                          # 앱 진입점
├── core/
│   ├── constants/
│   │   └── tetromino_patterns.dart   # 테트로미노 패턴 정의
│   └── di/
│       └── service_locator.dart      # 의존성 주입 설정
├── data/
│   ├── datasources/
│   │   └── game_local_datasource.dart
│   ├── models/
│   │   ├── game_score_model.dart
│   │   └── game_state_model.dart
│   └── repositories/
│       └── game_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── game_score.dart
│   │   ├── game_state.dart
│   │   └── tetromino_type.dart
│   ├── repositories/
│   │   └── game_repository.dart
│   └── usecases/
│       ├── get_high_score.dart
│       ├── load_game_state.dart
│       ├── save_game_score.dart
│       └── save_game_state.dart
└── presentation/
    ├── components/
    │   ├── board_component.dart
    │   └── next_piece_component.dart
    ├── game/
    │   └── tetris_game.dart
    ├── managers/
    │   └── game_state_manager.dart
    └── widgets/
        ├── game_controls.dart
        ├── game_hud.dart
        └── next_piece_hud.dart
```

## 🚀 설치 및 실행

### 사전 요구사항

- Flutter SDK (3.10.4 이상)
- Dart SDK
- 개발 환경 (Android Studio, VS Code 등)

### 설치

1. 저장소 클론
```bash
git clone <repository-url>
cd flutter_flame_dev
```

2. 의존성 설치
```bash
flutter pub get
```

3. Hive 코드 생성
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 실행

#### 모바일
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

#### 데스크톱
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

#### 웹
```bash
flutter run -d chrome
```

## 🧪 테스트

### 전체 테스트 실행
```bash
flutter test
```

### 특정 테스트 파일 실행
```bash
# 게임 로직 테스트
flutter test test/game_state_manager_test.dart

# 패턴 테스트
flutter test test/tetromino_patterns_test.dart

# Entity/Model 변환 테스트
flutter test test/entity_model_test.dart
```

### 테스트 커버리지
현재 **32개의 테스트 케이스**가 모두 통과합니다:
- ✅ GameStateManager 테스트 (20개)
- ✅ TetrominoPatterns 테스트 (5개)
- ✅ Entity/Model 변환 테스트 (6개)
- ✅ Widget 테스트 (1개)

## 🎮 게임 플레이

### 조작 방법

#### 키보드 (데스크톱)
- **← →**: 블록 좌우 이동
- **↓**: 블록 빠르게 낙하
- **↑ / W**: 블록 회전
- **스페이스**: 하드 드롭 (즉시 낙하)
- **P**: 일시정지

#### 터치/마우스 (모바일/웹)
- 화면 하단의 컨트롤 버튼 사용
  - 좌우 화살표: 이동
  - 회전 버튼: 회전
  - 아래 화살표: 빠른 낙하
  - 일시정지 버튼: 일시정지/재개
  - 리셋 버튼: 게임 재시작

### 점수 시스템

- **1줄 클리어**: 100 × 레벨
- **2줄 클리어**: 300 × 레벨
- **3줄 클리어**: 500 × 레벨
- **4줄 클리어**: 800 × 레벨 (테트리스)
- **하드 드롭**: +2점 (블록당)

### 레벨 시스템

- 10줄을 클리어할 때마다 레벨이 1씩 증가
- 레벨이 올라갈수록 블록 낙하 속도가 빨라짐
- 낙하 속도: `1.0 - (레벨 - 1) × 0.05` 초 (최소 0.1초)

## 💻 개발 가이드

### 새로운 기능 추가

1. **Domain Layer에 Entity 추가**
   ```dart
   // lib/domain/entities/new_entity.dart
   class NewEntity extends Equatable { ... }
   ```

2. **Repository Interface에 메서드 추가**
   ```dart
   // lib/domain/repositories/game_repository.dart
   Future<void> newMethod();
   ```

3. **Use Case 생성**
   ```dart
   // lib/domain/usecases/new_usecase.dart
   class NewUseCase { ... }
   ```

4. **Data Layer에 Model 추가**
   ```dart
   // lib/data/models/new_model.dart
   @HiveType(typeId: X)
   class NewModel extends HiveObject { ... }
   ```

5. **Repository Implementation 구현**
   ```dart
   // lib/data/repositories/game_repository_impl.dart
   @override
   Future<void> newMethod() async { ... }
   ```

6. **Presentation Layer에서 사용**
   ```dart
   // Use Case를 Manager나 Widget에서 호출
   ```

### 코드 생성

Hive 모델을 수정한 후:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 의존성 주입

새로운 의존성을 추가하려면 `lib/core/di/service_locator.dart`에 등록:
```dart
sl.registerLazySingleton<NewService>(() => NewServiceImpl());
```

## 📚 참고 자료

- [Flame 공식 문서](https://docs.flame-engine.org/)
- [Flutter 공식 문서](https://docs.flutter.dev/)
- [Hive 문서](https://docs.hivedb.dev/)
- [클린 아키텍처 가이드](./FLAME_GAME_GUIDE.md)

## 🐛 알려진 이슈

현재 알려진 이슈는 없습니다.

## 🔮 향후 계획

- [ ] 멀티플레이어 모드
- [ ] 리플레이 기능
- [ ] 다양한 게임 모드
- [ ] 사운드 효과 및 배경음악
- [ ] 애니메이션 개선
- [ ] 리더보드 시스템

## 📄 라이선스

이 프로젝트는 개인 학습 및 포트폴리오 목적으로 제작되었습니다.

## 👨‍💻 개발자

프로젝트 개발 및 유지보수

---

**즐거운 게임 되세요! 🎮**
