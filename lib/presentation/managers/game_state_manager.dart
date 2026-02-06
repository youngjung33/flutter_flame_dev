import 'dart:math';
import '../../domain/entities/game_score.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/usecases/save_game_score.dart';
import '../../domain/usecases/get_high_score.dart';
import '../../domain/usecases/save_game_state.dart';
import '../../domain/usecases/load_game_state.dart';
import '../../core/constants/tetromino_patterns.dart';
import '../../core/constants/wall_kicks.dart';

/**
 * 테트리스 게임 로직 전담.
 * 보드·현재/다음/홀드 블록·점수·레벨·라인, 이동/회전/드롭/Hold/일시정지/게임오버·저장/불러오기.
 */
class GameStateManager {
  final SaveGameScore saveGameScore;
  final GetHighScore getHighScore;
  final SaveGameState saveGameState;
  final LoadGameState loadGameState;

  // 게임 보드 (10x20), 0=빈칸, 1~7=피스 타입
  static const int boardWidth = 10;
  static const int boardHeight = 20;

  List<List<int>> board = List.generate(
    boardHeight,
    (_) => List.filled(boardWidth, 0),
  );

  int currentPieceType = 0;   // 1=I, 2=O, 3=T, 4=S, 5=Z, 6=J, 7=L
  int currentPieceX = 0;      // 현재 블록 왼쪽 상단(4x4 기준) x
  int currentPieceY = 0;      // 현재 블록 왼쪽 상단 y
  int currentRotation = 0;     // 0~3 (시계 방향)
  int nextPieceType = 0;
  List<int> nextPieceQueue = []; // 다음 블록 여러 개 (최대 5개)
  int? holdPieceType;         // 보관된 블록 타입 (없으면 null)
  bool canHold = true;        // Hold 가능 여부 (블록 스폰 시마다 true로 리셋)
  int score = 0;
  int level = 1;
  int lines = 0;              // 누적 제거 라인 수
  bool isGameOver = false;
  bool isPaused = false;
  GameScore? highScore;       // 최고 점수 (로컬 저장)

  double fallTimer = 0.0;     // 다음 자동 낙하까지 남은 시간 누적
  double fallDelay = 1.0;     // 자동 낙하 간격(초), 레벨에 따라 감소
  bool isSoftDropping = false; // 아래 키 유지 중 여부

  GameStateManager({
    required this.saveGameScore,
    required this.getHighScore,
    required this.saveGameState,
    required this.loadGameState,
  });

  /** 고득점 로드, Next 큐·첫 블록 생성 후 스폰. */
  Future<void> initialize() async {
    highScore = await getHighScore.call();
    _initializeNextQueue();
    _generateNextPiece();
    _spawnPiece();
  }

  /** Next Queue 초기화: 5개 블록을 랜덤 생성해 큐에 채움. */
  void _initializeNextQueue() {
    nextPieceQueue = [];
    for (int i = 0; i < 5; i++) {
      nextPieceQueue.add(Random().nextInt(7) + 1);
    }
  }

  /** 다음 블록을 큐에서 꺼내 [nextPieceType]에 넣고, 큐 맨 뒤에 새 블록 하나 추가. */
  void _generateNextPiece() {
    if (nextPieceQueue.isEmpty) {
      _initializeNextQueue();
    }
    nextPieceType = nextPieceQueue.removeAt(0);
    // 큐에 새로운 블록 추가
    nextPieceQueue.add(Random().nextInt(7) + 1);
  }

  /** 현재 블록을 [nextPieceType]으로 스폰(중앙 상단), 다음 블록 생성, 스폰 불가 시 게임오버. */
  void _spawnPiece() {
    currentPieceType = nextPieceType;
    currentPieceX = boardWidth ~/ 2 - 2;
    currentPieceY = 0;
    currentRotation = 0;
    canHold = true; // 새 블록 스폰 시 Hold 가능
    _generateNextPiece();

    // 게임 오버 체크
    if (!_isValidPosition(currentPieceX, currentPieceY, currentRotation)) {
      isGameOver = true;
      gameOver();
    }
  }

  /** (x,y)에서 주어진 [rotation]으로 현재 피스가 보드/경계와 겹치지 않으면 true. */
  bool _isValidPosition(int x, int y, int rotation) {
    final pattern = TetrominoPatterns.getPattern(currentPieceType, rotation);
    for (int py = 0; py < 4; py++) {
      for (int px = 0; px < 4; px++) {
        if (pattern[py][px] == 1) {
          final nx = x + px;
          final ny = y + py;
          if (nx < 0 || nx >= boardWidth || ny >= boardHeight) {
            return false;
          }
          if (ny >= 0 && board[ny][nx] != 0) {
            return false;
          }
        }
      }
    }
    return true;
  }

  /** 왼쪽으로 1칸 이동 (가능할 때만). */
  void moveLeft() {
    if (isGameOver || isPaused) return;
    if (_isValidPosition(currentPieceX - 1, currentPieceY, currentRotation)) {
      currentPieceX--;
    }
  }

  /** 오른쪽으로 1칸 이동 (가능할 때만). */
  void moveRight() {
    if (isGameOver || isPaused) return;
    if (_isValidPosition(currentPieceX + 1, currentPieceY, currentRotation)) {
      currentPieceX++;
    }
  }

  /** 시계 방향 회전. SRS 월킥: 제자리 실패 시 오프셋 순서대로 시도해 끼워 넣기. */
  void rotate() {
    if (isGameOver || isPaused) return;
    final newRotation = (currentRotation + 1) % 4;
    final kicks = WallKicks.getKicksForType(currentPieceType)[currentRotation];
    for (final (dx, dy) in kicks) {
      // SRS: dx=오른쪽, dy=위쪽 → 우리 좌표계(y 아래+)에서는 (x+dx, y-dy)
      final tryX = currentPieceX + dx;
      final tryY = currentPieceY - dy;
      if (_isValidPosition(tryX, tryY, newRotation)) {
        currentPieceX = tryX;
        currentPieceY = tryY;
        currentRotation = newRotation;
        return;
      }
    }
  }

  /** 아래로 1칸 이동. 불가 시 락·라인 제거·다음 스폰. */
  void moveDown() {
    if (isGameOver || isPaused) return;
    if (_isValidPosition(currentPieceX, currentPieceY + 1, currentRotation)) {
      currentPieceY++;
      fallTimer = 0.0; // 수동 이동 시 타이머 리셋
    } else {
      _lockPiece();
      _clearLines();
      if (!isGameOver) {
        _spawnPiece();
        fallTimer = 0.0;
      }
    }
  }

  /** Hold: 현재 블록을 보관하고 다음 블록으로 교체. 보관함이 있으면 현재↔보관 교환. 한 스폰당 1회만. */
  void hold() {
    if (isGameOver || isPaused || !canHold) return;

    if (holdPieceType == null) {
      // 보관함이 비어있으면 현재 블록 보관
      holdPieceType = currentPieceType;
      _spawnPiece();
    } else {
      // 보관함에 블록이 있으면 교환
      final temp = holdPieceType;
      holdPieceType = currentPieceType;
      currentPieceType = temp!;
      currentPieceX = boardWidth ~/ 2 - 2;
      currentPieceY = 0;
      currentRotation = 0;
    }
    canHold = false; // 한 번만 Hold 가능
  }

  /** Soft Drop 시작: 아래 키 누름 시 낙하 속도 증가. */
  void startSoftDrop() {
    if (isGameOver || isPaused) return;
    isSoftDropping = true;
  }

  /** Soft Drop 해제 (아래 키 뗐을 때). */
  void stopSoftDrop() {
    isSoftDropping = false;
  }

  /** Ghost Piece용: 현재 블록이 착지할 y 좌표(바닥 또는 쌓인 블록 위). */
  int getGhostY() {
    int ghostY = currentPieceY;
    while (_isValidPosition(currentPieceX, ghostY + 1, currentRotation)) {
      ghostY++;
    }
    return ghostY;
  }

  /** 하드 드롭: 즉시 착지 후 락·라인 제거·다음 스폰, 보너스 점수. */
  void hardDrop() {
    if (isGameOver || isPaused) return;
    while (_isValidPosition(currentPieceX, currentPieceY + 1, currentRotation)) {
      currentPieceY++;
      score += 2; // 하드 드롭 보너스
    }
    _lockPiece();
    _clearLines();
    _spawnPiece();
  }

  /** 현재 블록을 보드에 고정 (board에 타입 기록). */
  void _lockPiece() {
    final pattern = TetrominoPatterns.getPattern(currentPieceType, currentRotation);
    for (int py = 0; py < 4; py++) {
      for (int px = 0; px < 4; px++) {
        if (pattern[py][px] == 1) {
          final nx = currentPieceX + px;
          final ny = currentPieceY + py;
          if (ny >= 0 && ny < boardHeight && nx >= 0 && nx < boardWidth) {
            board[ny][nx] = currentPieceType;
          }
        }
      }
    }
  }

  /** 꽉 찬 줄 제거(아래부터), 점수·레벨·[fallDelay] 갱신. */
  void _clearLines() {
    int linesCleared = 0;
    for (int y = boardHeight - 1; y >= 0; y--) {
      if (board[y].every((cell) => cell != 0)) {
        board.removeAt(y);
        board.insert(0, List.filled(boardWidth, 0));
        linesCleared++;
        y++; // 같은 줄 다시 체크
      }
    }

    if (linesCleared > 0) {
      lines += linesCleared;
      // 점수: 1줄=100, 2줄=300, 3줄=500, 4줄=800 (인덱스=동시 제거 줄 수)
      final lineScores = [0, 100, 300, 500, 800];
      score += lineScores[linesCleared] * level;
      // 레벨 업 (10줄마다)
      level = (lines ~/ 10) + 1;
      // 낙하 속도 증가
      fallDelay = (1.0 - (level - 1) * 0.05).clamp(0.1, 1.0);
    }
  }

  /** 매 프레임 호출. [dt]만큼 [fallTimer] 증가, 간격 도달 시 1칸 낙하 또는 락·스폰. */
  void update(double dt) {
    if (isGameOver || isPaused) return;

    // Soft Drop 중이면 0.05초 간격, 아니면 레벨별 fallDelay
    final currentFallDelay = isSoftDropping ? 0.05 : fallDelay;

    fallTimer += dt;
    if (fallTimer >= currentFallDelay) {
      if (_isValidPosition(currentPieceX, currentPieceY + 1, currentRotation)) {
        currentPieceY++;
        if (isSoftDropping) {
          score += 1; // Soft Drop 보너스 (블록당 1점)
        }
        fallTimer = 0.0;
      } else {
        _lockPiece();
        _clearLines();
        if (!isGameOver) {
          _spawnPiece();
          fallTimer = 0.0;
        } else {
          gameOver();
        }
      }
    }
  }

  /** 일시정지 토글 (게임오버가 아닐 때만). */
  void togglePause() {
    if (!isGameOver) {
      isPaused = !isPaused;
    }
  }

  bool _gameOverCalled = false; // gameOver 중복 호출 방지

  /** 게임오버 처리: 점수 저장, 최고점 갱신. */
  Future<void> gameOver() async {
    if (isGameOver && _gameOverCalled) return;
    _gameOverCalled = true;
    isGameOver = true;

    final gameScore = GameScore(
      score: score,
      level: level,
      lines: lines,
      timestamp: DateTime.now(),
    );

    await saveGameScore.call(gameScore);

    if (highScore == null || score > highScore!.score) {
      highScore = gameScore;
    }
  }

  /** 보드·점수·레벨·블록 상태 초기화 후 새 게임 스폰. */
  void reset() {
    board = List.generate(
      boardHeight,
      (_) => List.filled(boardWidth, 0),
    );
    score = 0;
    level = 1;
    lines = 0;
    isGameOver = false;
    isPaused = false;
    fallTimer = 0.0;
    fallDelay = 1.0;
    _gameOverCalled = false;
    holdPieceType = null;
    canHold = true;
    isSoftDropping = false;
    _initializeNextQueue();
    _generateNextPiece();
    _spawnPiece();
  }

  /** 현재 상태를 [GameState] 엔티티로 변환 (저장/복원용). */
  GameState toEntity() {
    return GameState(
      board: board,
      currentPieceType: currentPieceType,
      currentPieceX: currentPieceX,
      currentPieceY: currentPieceY,
      currentRotation: currentRotation,
      nextPieceType: nextPieceType,
      nextPieceQueue: List<int>.from(nextPieceQueue),
      holdPieceType: holdPieceType,
      canHold: canHold,
      score: score,
      level: level,
      lines: lines,
      isGameOver: isGameOver,
      isPaused: isPaused,
    );
  }

  /** [GameState] 엔티티에서 상태 복원 (불러오기용). */
  void fromEntity(GameState state) {
    board = state.board.map((row) => List<int>.from(row)).toList();
    currentPieceType = state.currentPieceType;
    currentPieceX = state.currentPieceX;
    currentPieceY = state.currentPieceY;
    currentRotation = state.currentRotation;
    nextPieceType = state.nextPieceType;
    nextPieceQueue = List<int>.from(state.nextPieceQueue);
    holdPieceType = state.holdPieceType;
    canHold = state.canHold;
    score = state.score;
    level = state.level;
    lines = state.lines;
    isGameOver = state.isGameOver;
    isPaused = state.isPaused;
    fallDelay = (1.0 - (level - 1) * 0.05).clamp(0.1, 1.0);
  }

  /** 현재 게임 상태를 로컬에 저장. */
  Future<void> saveState() async {
    await saveGameState.call(toEntity());
  }

  /** 로컬에 저장된 게임 상태를 불러와 적용. */
  Future<void> loadState() async {
    final state = await loadGameState.call();
    if (state != null) {
      fromEntity(state);
    }
  }
}

