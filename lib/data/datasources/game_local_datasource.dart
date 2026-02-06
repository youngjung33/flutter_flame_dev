import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_score_model.dart';
import '../models/game_state_model.dart';

/** Hive 로컬 저장소: 점수 박스·게임 상태 박스 접근. */
class GameLocalDataSource {
  static const String _scoreBoxName = 'scores';   // 점수 목록 박스 이름
  static const String _stateBoxName = 'game_state'; // 게임 상태 박스 이름
  static const String _stateKey = 'current_state';  // 상태 저장 키 (단일)

  Future<Box<GameScoreModel>> get _scoreBox async {
    return await Hive.openBox<GameScoreModel>(_scoreBoxName);
  }

  Future<Box<GameStateModel>> get _stateBox async {
    return await Hive.openBox<GameStateModel>(_stateBoxName);
  }

  /** 점수 한 건을 scores 박스에 추가. */
  Future<void> saveScore(GameScoreModel score) async {
    final box = await _scoreBox;
    await box.add(score);
  }

  /** scores 박스에서 점수가 가장 높은 레코드 1건 반환. */
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

  /** 점수 목록을 점수 내림차순으로 [limit]개까지 반환. */
  Future<List<GameScoreModel>> getScoreHistory({int limit = 10}) async {
    final box = await _scoreBox;
    final scores = box.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    return scores.take(limit).toList();
  }

  /** 게임 상태를 game_state 박스에 [_stateKey]로 저장 (덮어쓰기). */
  Future<void> saveGameState(GameStateModel state) async {
    final box = await _stateBox;
    await box.put(_stateKey, state);
  }

  /** 저장된 게임 상태 1건 로드. 없으면 null. */
  Future<GameStateModel?> loadGameState() async {
    final box = await _stateBox;
    return box.get(_stateKey);
  }

  /** 게임 상태 키 삭제. */
  Future<void> deleteGameState() async {
    final box = await _stateBox;
    await box.delete(_stateKey);
  }
}

