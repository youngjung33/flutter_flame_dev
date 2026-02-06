import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants/tetromino_patterns.dart';
import '../managers/game_state_manager.dart';

/**
 * 메인 보드 렌더: 그리드·고정 블록·Ghost Piece·현재 블록. [cellSize]는 리사이즈 시 갱신됨.
 */
class BoardComponent extends PositionComponent with HasGameRef {
  final GameStateManager gameState;
  double cellSize; // 한 셀 픽셀 크기 (TetrisGame._layout에서 설정)

  BoardComponent({
    required this.gameState,
    required this.cellSize,
  });

  /** 보드 배경·그리드·고정 블록·Ghost·현재 블록 순서로 그리기. */
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

    // Ghost Piece 그리기 (예상 낙하 위치)
    if (!gameState.isGameOver) {
      final ghostY = gameState.getGhostY();
      if (ghostY != gameState.currentPieceY) {
        final pattern = TetrominoPatterns.getPattern(
          gameState.currentPieceType,
          gameState.currentRotation,
        );
        for (int py = 0; py < 4; py++) {
          for (int px = 0; px < 4; px++) {
            if (pattern[py][px] == 1) {
              final x = gameState.currentPieceX + px;
              final y = ghostY + py;
              if (y >= 0 && y < GameStateManager.boardHeight) {
                _drawGhostBlock(canvas, x, y, gameState.currentPieceType);
              }
            }
          }
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

  /** Ghost 블록: 반투명 테두리만 그려 착지 예상 위치 표시. */
  void _drawGhostBlock(Canvas canvas, int x, int y, int type) {
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

    final color = colors[type] ?? Colors.white;
    final rect = Rect.fromLTWH(
      x * cellSize + 1,
      y * cellSize + 1,
      cellSize - 2,
      cellSize - 2,
    );

    // 반투명 테두리만 그리기
    canvas.drawRect(
      rect,
      Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  /** 셀 (x,y)에 타입별 색상 블록 + 하이라이트 테두리 그리기. */
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

