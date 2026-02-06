import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../components/board_component.dart';
import '../components/hold_piece_component.dart';
import '../components/next_queue_component.dart';
import '../managers/game_state_manager.dart';

/**
 * Flame 테트리스 게임. Hold·보드·Next 영역을 비율로 배치하고, 리사이즈 시 레이아웃 재계산.
 */
class TetrisGame extends FlameGame {
  final GameStateManager gameState;
  late final BoardComponent board;
  late final HoldPieceComponent holdPiece;
  late final NextQueueComponent nextQueue;
  // onLoad 완료 후에만 onGameResize에서 _layout 호출 (late 초기화 전 접근 방지)
  bool _layoutReady = false;

  TetrisGame({required this.gameState});

  /**
   * 화면 [size]에 맞춰 Hold·보드·Next 위치·셀 크기를 비율로 계산해 컴포넌트에 적용.
   */
  void _layout(Vector2 size) {
    final w = size.x;
    final h = size.y;
    final short = w < h ? w : h; // 셀 크기 clamp용

    // 비율로 영역 할당 (가로/세로 공통)
    final holdRatio = 0.14;
    final gapRatio = 0.02;
    final nextRatio = 0.12;
    final boardWidthPx = w * (1 - holdRatio - gapRatio - nextRatio);
    final boardHeightPx = h * 0.62;
    final cellByWidth = boardWidthPx / GameStateManager.boardWidth;
    final cellByHeight = boardHeightPx / GameStateManager.boardHeight;
    final cellSize = (cellByWidth < cellByHeight ? cellByWidth : cellByHeight)
        .clamp(short * 0.02, short * 0.08);

    final boardWidth = GameStateManager.boardWidth * cellSize;
    final boardHeight = GameStateManager.boardHeight * cellSize;
    final holdAreaWidth = w * holdRatio;
    final gap = w * gapRatio;
    final nextAreaWidth = w * nextRatio;
    final startX = (w - (holdAreaWidth + boardWidth + gap + nextAreaWidth)) / 2;
    final startY = (h - boardHeight) / 2 - h * 0.04;

    holdPiece.cellSize = cellSize * 0.55;
    holdPiece.position = Vector2(startX, startY);

    board.cellSize = cellSize;
    board.position = Vector2(startX + holdAreaWidth, startY);

    nextQueue.cellSize = cellSize * 0.45;
    nextQueue.position = Vector2(startX + holdAreaWidth + boardWidth + gap, startY);
  }

  /** Hold·보드·Next 컴포넌트 생성·추가 후 [_layout] 호출. */
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    holdPiece = HoldPieceComponent(
      gameState: gameState,
      cellSize: 20,
    );
    add(holdPiece);

    board = BoardComponent(
      gameState: gameState,
      cellSize: 20,
    );
    add(board);

    nextQueue = NextQueueComponent(
      gameState: gameState,
      cellSize: 16,
    );
    add(nextQueue);

    _layout(size);
    _layoutReady = true;
  }

  /** 화면 크기 변경(회전 등) 시 레이아웃 재계산. */
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (_layoutReady) {
      _layout(size);
    }
  }

  /** 매 프레임 [gameState.update] 호출. */
  @override
  void update(double dt) {
    super.update(dt);
    gameState.update(dt);
  }

  /** Flame 기본 렌더 (실제 그리기는 각 컴포넌트에서). */
  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
