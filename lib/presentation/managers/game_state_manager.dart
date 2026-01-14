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
  int score = 0;
  int level = 1;
  int lines = 0;
  bool isGameOver = false;
  bool isPaused = false;
  GameScore? highScore;

  double fallTimer = 0.0;
  double fallDelay = 1.0; // 초기 낙하 속도 (초)

  GameStateManager({
    required this.saveGameScore,
    required this.getHighScore,
    required this.saveGameState,
    required this.loadGameState,
  });

  Future<void> initialize() async {
    highScore = await getHighScore.call();
    _generateNextPiece();
    _spawnPiece();
  }

  void _generateNextPiece() {
    nextPieceType = Random().nextInt(7) + 1;
  }

  void _spawnPiece() {
    currentPieceType = nextPieceType;
    currentPieceX = boardWidth ~/ 2 - 2;
    currentPieceY = 0;
    currentRotation = 0;
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

    fallTimer += dt;
    if (fallTimer >= fallDelay) {
      if (_isValidPosition(currentPieceX, currentPieceY + 1, currentRotation)) {
        currentPieceY++;
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

