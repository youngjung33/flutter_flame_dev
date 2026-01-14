import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants/tetromino_patterns.dart';
import '../managers/game_state_manager.dart';

class NextPieceComponent extends PositionComponent with HasGameRef {
  final GameStateManager gameState;
  final double cellSize;

  NextPieceComponent({
    required this.gameState,
    required this.cellSize,
  });

  @override
  void render(Canvas canvas) {
    final pattern = TetrominoPatterns.getPattern(gameState.nextPieceType, 0);
    final size = 4 * cellSize;

    // 배경
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size, size),
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    // 다음 블록 그리기
    for (int py = 0; py < 4; py++) {
      for (int px = 0; px < 4; px++) {
        if (pattern[py][px] == 1) {
          final colors = [
            Colors.transparent,
            Colors.cyan,
            Colors.yellow,
            Colors.purple,
            Colors.green,
            Colors.red,
            Colors.blue,
            Colors.orange,
          ];

          final color = colors[gameState.nextPieceType] ?? Colors.white;
          final rect = Rect.fromLTWH(
            px * cellSize + 1,
            py * cellSize + 1,
            cellSize - 2,
            cellSize - 2,
          );

          canvas.drawRect(rect, Paint()..color = color);
        }
      }
    }
  }
}

