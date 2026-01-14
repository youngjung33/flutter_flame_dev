import '../entities/game_state.dart';
import '../repositories/game_repository.dart';

class LoadGameState {
  final GameRepository repository;

  LoadGameState(this.repository);

  Future<GameState?> call() async {
    return await repository.loadGameState();
  }
}

