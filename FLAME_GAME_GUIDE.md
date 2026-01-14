# Flame 엔진 게임 개발 가이드

Flutter 개발자는 익숙하지만 게임 개발과 Flame 엔진이 처음인 개발자를 위한 구조 가이드입니다.

## 목차
1. [Flame 엔진이란?](#flame-엔진이란)
2. [프로젝트 설정](#프로젝트-설정)
3. [클린 아키텍처 구조](#클린-아키텍처-구조)
4. [Flame 기본 개념](#flame-기본-개념)
5. [주요 기능 개요](#주요-기능-개요)

---

## Flame 엔진이란?

Flame은 Flutter를 위한 2D 게임 엔진입니다. Flutter의 위젯 시스템 위에 구축되어 있어 Flutter 개발자에게 친숙한 API를 제공합니다.

### 주요 특징
- **Component 기반 아키텍처**: 재사용 가능한 컴포넌트로 게임 구성
- **Flutter 통합**: Flutter 위젯과 게임을 함께 사용 가능
- **성능 최적화**: 하드웨어 가속 렌더링
- **크로스 플랫폼**: iOS, Android, Web, Desktop 지원

---

## 프로젝트 설정

### 필수 의존성
```yaml
dependencies:
  flame: ^1.15.0
  hive: ^2.2.3              # 로컬 DB (NoSQL)
  hive_flutter: ^1.1.0
  get_it: ^7.6.4            # 의존성 주입
  equatable: ^2.0.5         # Entity 비교

dev_dependencies:
  hive_generator: ^2.0.1     # Hive 코드 생성
  build_runner: ^2.4.7
```

### Assets 설정
```yaml
flutter:
  assets:
    - assets/images/
    - assets/audio/
```

---

## 클린 아키텍처 구조

Flame 게임을 클린 아키텍처 3계층 구조로 구성하는 방법입니다.

### 프로젝트 폴더 구조

```
lib/
├── main.dart
├── core/
│   ├── di/              # 의존성 주입 설정 (GetIt)
│   └── constants/       # 상수
├── data/
│   ├── datasources/     # 데이터 소스 (로컬 DB - Hive)
│   ├── models/          # 데이터 모델 (Hive Adapter)
│   └── repositories/    # Repository 구현
├── domain/
│   ├── entities/        # 비즈니스 엔티티
│   ├── repositories/    # Repository 인터페이스
│   └── usecases/        # Use Cases (비즈니스 로직)
└── presentation/
    ├── game/            # Flame Game 클래스
    ├── components/      # Flame Components
    ├── managers/        # 게임 매니저 (상태 관리)
    └── widgets/         # Flutter 위젯 (HUD, 메뉴 등)
```

### 1. Domain Layer (비즈니스 로직)

**역할**: 비즈니스 로직과 규칙을 담당하는 순수한 계층

#### Entities
- 게임의 핵심 데이터 구조
- Equatable을 사용하여 비교 가능하게 구현
- 예: GameScore, PlayerStats, GameSettings 등

#### Repository Interfaces
- 데이터 접근에 대한 추상화
- Domain 계층은 구현 세부사항을 모름
- 예: GameRepository, SettingsRepository 등

#### Use Cases
- 단일 책임 원칙에 따라 하나의 기능만 수행
- Repository를 통해 데이터 접근
- 비즈니스 로직 처리
- 예: SaveGameScore, GetHighScore, UpdatePlayerStats 등

### 2. Data Layer (데이터 소스 및 Repository 구현)

**역할**: 데이터 저장 및 외부 소스와의 통신 담당

#### Models
- Hive Adapter를 사용한 데이터 모델
- Entity와 Model 간 변환 메서드 제공 (toEntity, fromEntity)
- 코드 생성 필요 (build_runner)

#### Data Sources
- 로컬 DB (Hive) 직접 접근
- CRUD 작업 수행
- 예: GameLocalDataSource

#### Repository Implementation
- Domain의 Repository 인터페이스 구현
- Data Source를 사용하여 실제 데이터 처리
- Model ↔ Entity 변환 담당

### 3. Presentation Layer (UI 및 게임 로직)

**역할**: 사용자 인터페이스와 게임 렌더링 담당

#### Game (FlameGame)
- Flame 게임의 진입점
- 컴포넌트 관리
- 게임 루프 제어

#### Components
- 게임 내 모든 객체 (플레이어, 적, 배경 등)
- PositionComponent, SpriteComponent 등 상속
- 게임 로직과 렌더링 담당

#### Managers
- 게임 상태 관리
- Use Cases를 호출하여 비즈니스 로직 실행
- 예: GameStateManager, ScoreManager 등

#### Widgets
- Flutter 위젯 (HUD, 메뉴, 설정 화면 등)
- 게임 위에 오버레이되는 UI

### 의존성 주입 (DI)

**GetIt**을 사용하여 의존성 관리:
- Service Locator 패턴
- Data Source, Repository, Use Case 등 등록
- main.dart에서 초기화

### 데이터 흐름

```
Presentation (Game/Components/Managers)
    ↓ 호출
Use Cases (비즈니스 로직)
    ↓ 호출
Repository Interface (Domain)
    ↓ 구현
Repository Implementation (Data)
    ↓ 사용
Local Data Source (Hive)
    ↓ 저장
로컬 DB (Hive Box)
```

### 클린 아키텍처의 장점

1. **관심사 분리**: 각 계층이 명확한 책임을 가짐
2. **테스트 용이성**: 각 계층을 독립적으로 테스트 가능
3. **유지보수성**: 변경 사항이 다른 계층에 영향을 최소화
4. **확장성**: 새로운 기능 추가가 용이
5. **재사용성**: Domain Layer는 다른 플랫폼에서도 재사용 가능

---

## Flame 기본 개념

### Game 클래스
- `FlameGame`을 상속받아 게임 생성
- `onLoad()`: 게임 초기화
- `update(dt)`: 매 프레임 호출 (dt = delta time)
- `render(canvas)`: 커스텀 렌더링 (필요시)

### Component 시스템
- 게임의 모든 객체는 Component
- `Component`: 기본 컴포넌트
- `PositionComponent`: 위치를 가진 컴포넌트
- `SpriteComponent`: 이미지를 가진 컴포넌트
- `SpriteAnimationComponent`: 애니메이션을 가진 컴포넌트

### 컴포넌트 생명주기
- `onLoad()`: 컴포넌트 로드 시 한 번 호출
- `onMount()`: 게임에 마운트될 때 호출
- `update(dt)`: 매 프레임 호출
- `render(canvas)`: 렌더링
- `onRemove()`: 제거될 때 호출

### Mixins
- `HasGameRef`: Game 인스턴스 접근
- `KeyboardHandler`: 키보드 입력 처리
- `TapCallbacks`: 터치/마우스 입력 처리
- `DragCallbacks`: 드래그 입력 처리
- `CollisionCallbacks`: 충돌 감지

---

## 주요 기능 개요

### 스프라이트와 이미지
- `Sprite`: 단일 이미지
- `SpriteSheet`: 여러 프레임이 있는 이미지 시트
- `SpriteAnimation`: 애니메이션 시퀀스
- `images.load()`: 이미지 로드

### 입력 처리
- **키보드**: `KeyboardHandler` mixin 사용
- **터치/마우스**: `TapCallbacks`, `DragCallbacks` mixin 사용
- 입력 이벤트는 Component에서 처리

### 물리 엔진
- **Forge2D**: Box2D 포팅, 물리 시뮬레이션
- `Forge2DGame`을 상속받아 사용
- `BodyComponent`: 물리 객체

### 사운드
- `flame_audio` 패키지 사용
- 배경음악과 효과음 지원

### 애니메이션
- `Effect` 클래스들: MoveToEffect, ScaleEffect, RotateEffect 등
- `EffectController`: 애니메이션 제어

### 카메라
- `camera.followComponent()`: 특정 컴포넌트 추적
- `camera.setBounds()`: 카메라 이동 범위 제한

### 충돌 감지
- `HasCollisionDetection` mixin
- `Hitbox` 컴포넌트 추가
- `CollisionCallbacks` mixin으로 충돌 이벤트 처리

### 파티클 시스템
- `ParticleSystemComponent` 사용
- 다양한 파티클 타입 제공

### 상태 관리
- 게임 상태는 Manager 클래스에서 관리
- Use Cases를 통해 Domain Layer와 통신

### HUD (Head-Up Display)
- Flutter 위젯으로 구현
- `GameWidget` 위에 오버레이
- 게임 상태 표시

---

## 유용한 리소스

- **공식 문서**: https://docs.flame-engine.org/
- **GitHub**: https://github.com/flame-engine/flame
- **예제 게임**: https://examples.flame-engine.org/
- **커뮤니티**: https://discord.gg/pxrBmy4

---

## 개발 시 고려사항

### 성능 최적화
- 컴포넌트 풀링: 자주 생성/제거되는 객체 재사용
- 화면 밖 컴포넌트는 렌더링 스킵
- 이미지 최적화: 적절한 크기와 포맷 사용

### 메모리 관리
- 사용하지 않는 컴포넌트는 제거
- 이미지와 사운드는 적절히 캐싱
- Hive Box는 필요시에만 열기

### 디버깅
- `debugMode = true`: FPS 표시, 충돌 박스 시각화
- 각 계층별로 독립적인 테스트 작성

---

이 가이드는 Flame 게임 개발의 구조와 개념을 이해하는 데 도움이 됩니다. 실제 구현은 프로젝트 요구사항에 맞게 진행하세요.
