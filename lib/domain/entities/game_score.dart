import 'package:equatable/equatable.dart';

/** 게임 종료 시 기록되는 점수·레벨·라인·시각 (저장/최고점 비교용). */
class GameScore extends Equatable {
  final int score;
  final int level;
  final int lines;
  final DateTime timestamp; // 기록 시각

  const GameScore({
    required this.score,
    required this.level,
    required this.lines,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [score, level, lines, timestamp];
}

