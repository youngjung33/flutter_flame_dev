import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../components/board_component.dart';
import '../components/next_piece_component.dart';
import '../managers/game_state_manager.dart';

class TetrisGame extends FlameGame {
  final GameStateManager gameState;
  late final BoardComponent board;
  late final NextPieceComponent nextPiece;

  TetrisGame({required this.gameState});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 셀 크기 계산 (화면 크기에 맞춤)
    final cellSize = (size.y * 0.7 / GameStateManager.boardHeight).clamp(20.0, 40.0);
    final boardWidth = GameStateManager.boardWidth * cellSize;
    final boardHeight = GameStateManager.boardHeight * cellSize;

    // 보드 컴포넌트 추가 (중앙 배치)
    board = BoardComponent(
      gameState: gameState,
      cellSize: cellSize,
    );
    board.position = Vector2(
      (size.x - boardWidth) / 2,
      (size.y - boardHeight) / 2 - 50,
    );
    add(board);

    // 다음 블록 컴포넌트 추가 (보드 오른쪽 상단)
    nextPiece = NextPieceComponent(
      gameState: gameState,
      cellSize: cellSize * 0.6,
    );
    nextPiece.position = Vector2(
      board.position.x + boardWidth + 20,
      board.position.y,
    );
    add(nextPiece);
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameState.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}

