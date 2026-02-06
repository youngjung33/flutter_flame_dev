import 'dart:math';
import '../../domain/entities/game_score.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/usecases/save_game_score.dart';
import '../../domain/usecases/get_high_score.dart';
import '../../domain/usecases/save_game_state.dart';
import '../../domain/usecases/load_game_state.dart';
import '../../core/constants/tetromino_patterns.dart';

class GameStateManager {
  final SaveGameScore saveGameScore;
  final GetHighScore getHighScore;
  final SaveGameState saveGameState;
  final LoadGameState loadGameState;

  // 게임 보드 (10x20)
  static const int boardWidth = 10;
  static const int boardHeight = 20;

  List<List<int>> board = List.generate(
    boardHeight,
    (_) => List.filled(boardWidth, 0),
  );

  int currentPieceType = 0;
  int currentPieceX = 0;
  int currentPieceY = 0;
  int currentRotation = 0;
  int nextPieceType = 0;
  List<int> nextPieceQueue = []; // 다음 블록 여러 개 (최대 5개)
  int? holdPieceType; // 보관된 블록
  bool canHold = true; // Hold 가능 여부 (블록 스폰 시마다 리셋)
  int score = 0;
  int level = 1;
  int lines = 0;
  bool isGameOver = false;
  bool isPaused = false;
  GameScore? highScore;

  double fallTimer = 0.0;
  double fallDelay = 1.0; // 초기 낙하 속도 (초)
  bool isSoftDropping = false; // Soft Drop 중인지

  GameStateManager({
    required this.saveGameScore,
    required this.getHighScore,
    required this.saveGameState,
    required this.loadGameState,
  });

  Future<void> initialize() async {
    highScore = await getHighScore.call();
    _initializeNextQueue();
    _generateNextPiece();
    _spawnPiece();
  }

  // Next Queue 초기화 (5개 블록 미리 생성)
  void _initializeNextQueue() {
    nextPieceQueue = [];
    for (int i = 0; i < 5; i++) {
      nextPieceQueue.add(Random().nextInt(7) + 1);
    }
  }

  void _generateNextPiece() {
    if (nextPieceQueue.isEmpty) {
      _initializeNextQueue();
    }
    nextPieceType = nextPieceQueue.removeAt(0);
    // 큐에 새로운 블록 추가
    nextPieceQueue.add(Random().nextInt(7) + 1);
  }

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

  void moveLeft() {
    if (isGameOver || isPaused) return;
    if (_isValidPosition(currentPieceX - 1, currentPieceY, currentRotation)) {
      currentPieceX--;
    }
  }

  void moveRight() {
    if (isGameOver || isPaused) return;
    if (_isValidPosition(currentPieceX + 1, currentPieceY, currentRotation)) {
      currentPieceX++;
    }
  }

  void rotate() {
    if (isGameOver || isPaused) return;
    final newRotation = (currentRotation + 1) % 4;
    if (_isValidPosition(currentPieceX, currentPieceY, newRotation)) {
      currentRotation = newRotation;
    }
  }

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

  // Hold 기능 (현재 블록을 보관하고 다음 블록 가져오기)
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

  // Soft Drop (아래 키를 누르고 있을 때 빠르게 낙하)
  void startSoftDrop() {
    if (isGameOver || isPaused) return;
    isSoftDropping = true;
  }

  void stopSoftDrop() {
    isSoftDropping = false;
  }

  // Ghost Piece 위치 계산 (블록이 떨어질 위치)
  int getGhostY() {
    int ghostY = currentPieceY;
    while (_isValidPosition(currentPieceX, ghostY + 1, currentRotation)) {
      ghostY++;
    }
    return ghostY;
  }

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
      // 점수 계산: 1줄=100, 2줄=300, 3줄=500, 4줄=800
      final lineScores = [0, 100, 300, 500, 800];
      score += lineScores[linesCleared] * level;
      // 레벨 업 (10줄마다)
      level = (lines ~/ 10) + 1;
      // 낙하 속도 증가
      fallDelay = (1.0 - (level - 1) * 0.05).clamp(0.1, 1.0);
    }
  }

  void update(double dt) {
    if (isGameOver || isPaused) return;

    // Soft Drop 중이면 더 빠르게 낙하
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

  void togglePause() {
    if (!isGameOver) {
      isPaused = !isPaused;
    }
  }

  bool _gameOverCalled = false;

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

  Future<void> saveState() async {
    await saveGameState.call(toEntity());
  }

  Future<void> loadState() async {
    final state = await loadGameState.call();
    if (state != null) {
      fromEntity(state);
    }
  }
}

