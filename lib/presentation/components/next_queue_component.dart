import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants/tetromino_patterns.dart';
import '../managers/game_state_manager.dart';

/**
 * Next 큐 영역: 다음에 나올 블록 5개를 세로로 표시. [cellSize]는 리사이즈 시 갱신됨.
 */
class NextQueueComponent extends PositionComponent with HasGameRef {
  final GameStateManager gameState;
  double cellSize; // 한 셀 픽셀 크기

  NextQueueComponent({
    required this.gameState,
    required this.cellSize,
  });

  /** Next 큐 블록들을 위에서부터 세로로 하나씩 그리기. */
  @override
  void render(Canvas canvas) {
    // 다음 블록 큐 그리기 (최대 5개), 간격은 셀 크기 비율
    final pieceSize = 4 * cellSize;   // 4x4 미노 한 칸 크기
    final spacing = cellSize * 0.5;   // 블록 사이 세로 간격
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

