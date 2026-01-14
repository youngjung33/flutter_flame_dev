import 'package:equatable/equatable.dart';

class GameScore extends Equatable {
  final int score;
  final int level;
  final int lines;
  final DateTime timestamp;

  const GameScore({
    required this.score,
    required this.level,
    required this.lines,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [score, level, lines, timestamp];
}

