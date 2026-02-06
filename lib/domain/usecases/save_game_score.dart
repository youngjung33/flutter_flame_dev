import '../entities/game_score.dart';
import '../repositories/game_repository.dart';

/** 게임 점수를 로컬에 저장하는 유스케이스. */
class SaveGameScore {
  final GameRepository repository;

  SaveGameScore(this.repository);

  Future<void> call(GameScore score) async {
    await repository.saveScore(score);
  }
}

