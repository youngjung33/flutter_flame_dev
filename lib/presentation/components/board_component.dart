import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants/tetromino_patterns.dart';
import '../managers/game_state_manager.dart';

class BoardComponent extends PositionComponent with HasGameRef {
  final GameStateManager gameState;
  final double cellSize;

  BoardComponent({
    required this.gameState,
    required this.cellSize,
  });

  @override
  void render(Canvas canvas) {
    // 보드 배경
    final boardWidth = GameStateManager.boardWidth * cellSize;
    final boardHeight = GameStateManager.boardHeight * cellSize;

    // 배경 테두리
    canvas.drawRect(
      Rect.fromLTWH(-2, -2, boardWidth + 4, boardHeight + 4),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, boardWidth, boardHeight),
      Paint()..color = Colors.black,
    );

    // 보드 그리드
    final gridPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int y = 0; y <= GameStateManager.boardHeight; y++) {
      canvas.drawLine(
        Offset(0, y * cellSize),
        Offset(boardWidth, y * cellSize),
        gridPaint,
      );
    }
    for (int x = 0; x <= GameStateManager.boardWidth; x++) {
      canvas.drawLine(
        Offset(x * cellSize, 0),
        Offset(x * cellSize, boardHeight),
        gridPaint,
      );
    }

    // 고정된 블록 그리기
    for (int y = 0; y < GameStateManager.boardHeight; y++) {
      for (int x = 0; x < GameStateManager.boardWidth; x++) {
        if (gameState.board[y][x] != 0) {
          _drawBlock(canvas, x, y, gameState.board[y][x]);
        }
      }
    }

    // 현재 블록 그리기
    if (!gameState.isGameOver) {
      final pattern = TetrominoPatterns.getPattern(
        gameState.currentPieceType,
        gameState.currentRotation,
      );
      for (int py = 0; py < 4; py++) {
        for (int px = 0; px < 4; px++) {
          if (pattern[py][px] == 1) {
            final x = gameState.currentPieceX + px;
            final y = gameState.currentPieceY + py;
            if (y >= 0) {
              _drawBlock(canvas, x, y, gameState.currentPieceType);
            }
          }
        }
      }
    }
  }

  void _drawBlock(Canvas canvas, int x, int y, int type) {
    final colors = [
      Colors.transparent,
      Colors.cyan,      // I
      Colors.yellow,    // O
      Colors.purple,    // T
      Colors.green,    // S
      Colors.red,       // Z
      Colors.blue,     // J
      Colors.orange,    // L
    ];

    final color = colors[type] ?? Colors.white;
    final rect = Rect.fromLTWH(
      x * cellSize + 1,
      y * cellSize + 1,
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

