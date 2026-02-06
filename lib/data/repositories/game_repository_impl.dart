import '../../domain/entities/game_score.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_local_datasource.dart';
import '../models/game_score_model.dart';
import '../models/game_state_model.dart';

/** [GameRepository] 구현: 로컬 DataSource를 통해 Hive에 점수·게임 상태 저장/로드. */
class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource dataSource;

  GameRepositoryImpl(this.dataSource);

  /** 엔티티를 모델로 변환 후 DataSource에 저장. */
  @override
  Future<void> saveScore(GameScore score) async {
    final model = GameScoreModel.fromEntity(score);
    await dataSource.saveScore(model);
  }

  /** DataSource에서 최고점 모델 조회 후 엔티티로 변환해 반환. */
  @override
  Future<GameScore?> getHighScore() async {
    final model = await dataSource.getHighScore();
    return model?.toEntity();
  }

  /** 점수 목록을 모델→엔티티 변환 후 반환. */
  @override
  Future<List<GameScore>> getScoreHistory({int limit = 10}) async {
    final models = await dataSource.getScoreHistory(limit: limit);
    return models.map((model) => model.toEntity()).toList();
  }

  /** 엔티티를 모델로 변환 후 DataSource에 게임 상태 저장. */
  @override
  Future<void> saveGameState(GameState state) async {
    final model = GameStateModel.fromEntity(state);
    await dataSource.saveGameState(model);
  }

  /** DataSource에서 게임 상태 로드 후 엔티티로 변환해 반환. */
  @override
  Future<GameState?> loadGameState() async {
    final model = await dataSource.loadGameState();
    return model?.toEntity();
  }

  /** 저장된 게임 상태 삭제. */
  @override
  Future<void> deleteGameState() async {
    await dataSource.deleteGameState();
  }
}

