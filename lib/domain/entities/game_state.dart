import 'package:equatable/equatable.dart';
import 'tetromino_type.dart';

class GameState extends Equatable {
  final List<List<int>> board; // 0 = 빈칸, 1-7 = 블록 타입
  final int currentPieceType;
  final int currentPieceX;
  final int currentPieceY;
  final int currentRotation;
  final int nextPieceType;
  final List<int> nextPieceQueue; // 다음 블록 여러 개
  final int? holdPieceType; // 보관된 블록 (null = 없음)
  final bool canHold; // Hold 가능 여부 (한 번만 Hold 가능)
  final int score;
  final int level;
  final int lines;
  final bool isGameOver;
  final bool isPaused;

  const GameState({
    required this.board,
    required this.currentPieceType,
    required this.currentPieceX,
    required this.currentPieceY,
    required this.currentRotation,
    required this.nextPieceType,
    required this.nextPieceQueue,
    this.holdPieceType,
    required this.canHold,
    required this.score,
    required this.level,
    required this.lines,
    required this.isGameOver,
    required this.isPaused,
  });

  @override
  List<Object?> get props => [
        board,
        currentPieceType,
        currentPieceX,
        currentPieceY,
        currentRotation,
        nextPieceType,
        nextPieceQueue,
        holdPieceType,
        canHold,
        score,
        level,
        lines,
        isGameOver,
        isPaused,
      ];
}

