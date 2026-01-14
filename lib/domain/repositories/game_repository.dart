import '../entities/game_score.dart';
import '../entities/game_state.dart';

abstract class GameRepository {
  // 점수 저장
  Future<void> saveScore(GameScore score);

  // 최고 점수 조회
  Future<GameScore?> getHighScore();

  // 점수 목록 조회
  Future<List<GameScore>> getScoreHistory({int limit = 10});

  // 게임 상태 저장
  Future<void> saveGameState(GameState state);

  // 게임 상태 로드
  Future<GameState?> loadGameState();

  // 게임 상태 삭제
  Future<void> deleteGameState();
}

