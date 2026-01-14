import '../entities/game_score.dart';
import '../repositories/game_repository.dart';

class GetHighScore {
  final GameRepository repository;

  GetHighScore(this.repository);

  Future<GameScore?> call() async {
    return await repository.getHighScore();
  }
}

