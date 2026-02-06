import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants/tetromino_patterns.dart';
import '../managers/game_state_manager.dart';

class NextQueueComponent extends PositionComponent with HasGameRef {
  final GameStateManager gameState;
  final double cellSize;

  NextQueueComponent({
    required this.gameState,
    required this.cellSize,
  });

  @override
  void render(Canvas canvas) {
    // 다음 블록 큐 그리기 (최대 5개)
    final pieceSize = 4 * cellSize;
    final spacing = 10.0;
    final totalHeight = (pieceSize + spacing) * gameState.nextPieceQueue.length;

    for (int i = 0; i < gameState.nextPieceQueue.length; i++) {
      final yOffset = i * (pieceSize + spacing);
      
      // 배경
      canvas.drawRect(
        Rect.fromLTWH(0, yOffset, pieceSize, pieceSize),
        Paint()..color = Colors.black.withOpacity(0.5),
      );

      // 블록 그리기
      final pieceType = gameState.nextPieceQueue[i];
      final pattern = TetrominoPatterns.getPattern(pieceType, 0);
      
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

            final color = colors[pieceType] ?? Colors.white;
            final rect = Rect.fromLTWH(
              px * cellSize + 1,
              yOffset + py * cellSize + 1,
              cellSize - 2,
              cellSize - 2,
            );

            canvas.drawRect(rect, Paint()..color = color);
            canvas.drawRect(
              rect,
              Paint()
                ..color = Colors.white.withOpacity(0.3)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.0,
            );
          }
        }
      }
    }
  }
}

