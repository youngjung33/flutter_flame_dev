import '../entities/game_state.dart';
import '../repositories/game_repository.dart';

/** 저장된 게임 상태를 로컬에서 불러오는 유스케이스. */
class LoadGameState {
  final GameRepository repository;

  LoadGameState(this.repository);

  Future<GameState?> call() async {
    return await repository.loadGameState();
  }
}

