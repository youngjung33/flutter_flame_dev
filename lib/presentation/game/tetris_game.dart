import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../components/board_component.dart';
import '../components/hold_piece_component.dart';
import '../components/next_queue_component.dart';
import '../managers/game_state_manager.dart';

class TetrisGame extends FlameGame {
  final GameStateManager gameState;
  late final BoardComponent board;
  late final HoldPieceComponent holdPiece;
  late final NextQueueComponent nextQueue;

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

    // Hold 블록 컴포넌트 추가 (보드 왼쪽 상단)
    holdPiece = HoldPieceComponent(
      gameState: gameState,
      cellSize: cellSize * 0.6,
    );
    holdPiece.position = Vector2(
      board.position.x - 100,
      board.position.y,
    );
    add(holdPiece);

    // Next Queue 컴포넌트 추가 (보드 오른쪽 상단)
    nextQueue = NextQueueComponent(
      gameState: gameState,
      cellSize: cellSize * 0.5,
    );
    nextQueue.position = Vector2(
      board.position.x + boardWidth + 20,
      board.position.y,
    );
    add(nextQueue);
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

