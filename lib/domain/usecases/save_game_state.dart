import '../entities/game_state.dart';
import '../repositories/game_repository.dart';

class SaveGameState {
  final GameRepository repository;

  SaveGameState(this.repository);

  Future<void> call(GameState state) async {
    await repository.saveGameState(state);
  }
}

