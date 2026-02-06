import 'package:hive/hive.dart';
import '../../domain/entities/game_state.dart';

part 'game_state_model.g.dart';

/** Hive 저장용 게임 상태 모델 (typeId: 1). [GameState] 엔티티와 변환. */
@HiveType(typeId: 1)
class GameStateModel extends HiveObject {
  @HiveField(0)
  List<List<int>> board; // 0=빈칸, 1~7=블록 타입

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
  List<int> nextPieceQueue; // 다음 블록 큐

  @HiveField(12)
  int? holdPieceType; // 보관 블록 (없으면 null)

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

  /** 도메인 엔티티 [GameState]로 변환. */
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

  /** [GameState] 엔티티에서 모델 생성. */
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

