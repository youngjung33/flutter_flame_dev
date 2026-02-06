import '../entities/game_state.dart';
import '../repositories/game_repository.dart';

/** 현재 게임 상태를 로컬에 저장하는 유스케이스. */
class SaveGameState {
  final GameRepository repository;

  SaveGameState(this.repository);

  Future<void> call(GameState state) async {
    await repository.saveGameState(state);
  }
}

