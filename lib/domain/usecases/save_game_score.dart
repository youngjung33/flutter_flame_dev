import '../entities/game_score.dart';
import '../repositories/game_repository.dart';

class SaveGameScore {
  final GameRepository repository;

  SaveGameScore(this.repository);

  Future<void> call(GameScore score) async {
    await repository.saveScore(score);
  }
}

