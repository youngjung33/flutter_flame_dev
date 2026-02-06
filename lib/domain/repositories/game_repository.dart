import '../entities/game_score.dart';
import '../entities/game_state.dart';

/** 점수·게임 상태 저장/로드 추상 레포지토리 (로컬 Hive 구현). */
abstract class GameRepository {
  /** 점수 저장 */
  Future<void> saveScore(GameScore score);

  /** 최고 점수 조회 */
  Future<GameScore?> getHighScore();

  /** 점수 목록 조회 (기본 최대 10개) */
  Future<List<GameScore>> getScoreHistory({int limit = 10});

  /** 게임 상태 저장 */
  Future<void> saveGameState(GameState state);

  /** 게임 상태 로드 */
  Future<GameState?> loadGameState();

  /** 게임 상태 삭제 */
  Future<void> deleteGameState();
}

