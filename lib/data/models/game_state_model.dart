import 'package:hive/hive.dart';
import '../../domain/entities/game_state.dart';

part 'game_state_model.g.dart';

@HiveType(typeId: 1)
class GameStateModel extends HiveObject {
  @HiveField(0)
  List<List<int>> board;

  @HiveField(1)
  int currentPieceType;

  @HiveField(2)
  int currentPieceX;

  @HiveField(3)
  int currentPieceY;

  @HiveField(4)
  int currentRotation;

  @HiveField(5)
  int nextPieceType;

  @HiveField(11)
  List<int> nextPieceQueue;

  @HiveField(12)
  int? holdPieceType;

  @HiveField(13)
  bool canHold;

  @HiveField(6)
  int score;

  @HiveField(7)
  int level;

  @HiveField(8)
  int lines;

  @HiveField(9)
  bool isGameOver;

  @HiveField(10)
  bool isPaused;

  GameStateModel({
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

  factory GameStateModel.fromEntity(GameState entity) {
    return GameStateModel(
      board: entity.board,
      currentPieceType: entity.currentPieceType,
      currentPieceX: entity.currentPieceX,
      currentPieceY: entity.currentPieceY,
      currentRotation: entity.currentRotation,
      nextPieceType: entity.nextPieceType,
      nextPieceQueue: List<int>.from(entity.nextPieceQueue),
      holdPieceType: entity.holdPieceType,
      canHold: entity.canHold,
      score: entity.score,
      level: entity.level,
      lines: entity.lines,
      isGameOver: entity.isGameOver,
      isPaused: entity.isPaused,
    );
  }
}

