import 'package:hive/hive.dart';
import '../../domain/entities/game_score.dart';

part 'game_score_model.g.dart';

/** Hive 저장용 점수 모델 (typeId: 0). [GameScore] 엔티티와 변환. */
@HiveType(typeId: 0)
class GameScoreModel extends HiveObject {
  @HiveField(0)
  int score;

  @HiveField(1)
  int level;

  @HiveField(2)
  int lines;

  @HiveField(3)
  DateTime timestamp; // 기록 시각

  GameScoreModel({
    required this.score,
    required this.level,
    required this.lines,
    required this.timestamp,
  });

  /** 도메인 엔티티 [GameScore]로 변환. */
  GameScore toEntity() {
    return GameScore(
      score: score,
      level: level,
      lines: lines,
      timestamp: timestamp,
    );
  }

  /** [GameScore] 엔티티에서 모델 생성. */
  factory GameScoreModel.fromEntity(GameScore entity) {
    return GameScoreModel(
      score: entity.score,
      level: entity.level,
      lines: entity.lines,
      timestamp: entity.timestamp,
    );
  }
}

