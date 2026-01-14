import '../../domain/entities/game_score.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_local_datasource.dart';
import '../models/game_score_model.dart';
import '../models/game_state_model.dart';

class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource dataSource;

  GameRepositoryImpl(this.dataSource);

  @override
  Future<void> saveScore(GameScore score) async {
    final model = GameScoreModel.fromEntity(score);
    await dataSource.saveScore(model);
  }

  @override
  Future<GameScore?> getHighScore() async {
    final model = await dataSource.getHighScore();
    return model?.toEntity();
  }

  @override
  Future<List<GameScore>> getScoreHistory({int limit = 10}) async {
    final models = await dataSource.getScoreHistory(limit: limit);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveGameState(GameState state) async {
    final model = GameStateModel.fromEntity(state);
    await dataSource.saveGameState(model);
  }

  @override
  Future<GameState?> loadGameState() async {
    final model = await dataSource.loadGameState();
    return model?.toEntity();
  }

  @override
  Future<void> deleteGameState() async {
    await dataSource.deleteGameState();
  }
}

