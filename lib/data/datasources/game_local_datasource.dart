import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_score_model.dart';
import '../models/game_state_model.dart';

class GameLocalDataSource {
  static const String _scoreBoxName = 'scores';
  static const String _stateBoxName = 'game_state';
  static const String _stateKey = 'current_state';

  Future<Box<GameScoreModel>> get _scoreBox async {
    return await Hive.openBox<GameScoreModel>(_scoreBoxName);
  }

  Future<Box<GameStateModel>> get _stateBox async {
    return await Hive.openBox<GameStateModel>(_stateBoxName);
  }

  // 점수 저장
  Future<void> saveScore(GameScoreModel score) async {
    final box = await _scoreBox;
    await box.add(score);
  }

  // 최고 점수 조회
  Future<GameScoreModel?> getHighScore() async {
    final box = await _scoreBox;
    if (box.isEmpty) return null;

    GameScoreModel? highest = box.values.first;
    for (var score in box.values) {
      if (score.score > (highest?.score ?? 0)) {
        highest = score;
      }
    }
    return highest;
  }

  // 점수 목록 조회
  Future<List<GameScoreModel>> getScoreHistory({int limit = 10}) async {
    final box = await _scoreBox;
    final scores = box.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    return scores.take(limit).toList();
  }

  // 게임 상태 저장
  Future<void> saveGameState(GameStateModel state) async {
    final box = await _stateBox;
    await box.put(_stateKey, state);
  }

  // 게임 상태 로드
  Future<GameStateModel?> loadGameState() async {
    final box = await _stateBox;
    return box.get(_stateKey);
  }

  // 게임 상태 삭제
  Future<void> deleteGameState() async {
    final box = await _stateBox;
    await box.delete(_stateKey);
  }
}

