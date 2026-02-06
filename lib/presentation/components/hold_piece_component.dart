import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants/tetromino_patterns.dart';
import '../managers/game_state_manager.dart';

class HoldPieceComponent extends PositionComponent with HasGameRef {
  final GameStateManager gameState;
  final double cellSize;

  HoldPieceComponent({
    required this.gameState,
    required this.cellSize,
  });

  @override
  void render(Canvas canvas) {
    // 배경
    final size = 4 * cellSize;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size, size),
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    // 보관된 블록이 있으면 그리기
    if (gameState.holdPieceType != null) {
      final pattern = TetrominoPatterns.getPattern(gameState.holdPieceType!, 0);
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

            final color = colors[gameState.holdPieceType!] ?? Colors.white;
            final rect = Rect.fromLTWH(
              px * cellSize + 1,
              py * cellSize + 1,
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
    } else {
      // 보관함이 비어있으면 텍스트 표시
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Hold',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size / 2 - textPainter.width / 2, size / 2 - textPainter.height / 2));
    }
  }
}

