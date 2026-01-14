import 'package:hive/hive.dart';
import '../../domain/entities/game_score.dart';

part 'game_score_model.g.dart';

@HiveType(typeId: 0)
class GameScoreModel extends HiveObject {
  @HiveField(0)
  int score;

  @HiveField(1)
  int level;

  @HiveField(2)
  int lines;

  @HiveField(3)
  DateTime timestamp;

  GameScoreModel({
    required this.score,
    required this.level,
    required this.lines,
    required this.timestamp,
  });

  GameScore toEntity() {
    return GameScore(
      score: score,
      level: level,
      lines: lines,
      timestamp: timestamp,
    );
  }

  factory GameScoreModel.fromEntity(GameScore entity) {
    return GameScoreModel(
      score: entity.score,
      level: entity.level,
      lines: entity.lines,
      timestamp: entity.timestamp,
    );
  }
}

