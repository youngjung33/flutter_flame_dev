import '../entities/game_score.dart';
import '../repositories/game_repository.dart';

/** 최고 점수를 조회하는 유스케이스. */
class GetHighScore {
  final GameRepository repository;

  GetHighScore(this.repository);

  Future<GameScore?> call() async {
    return await repository.getHighScore();
  }
}

