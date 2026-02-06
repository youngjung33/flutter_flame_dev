import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/game_state_manager.dart';

/**
 * 하단 조작 버튼: 좌/회전/Hold/하/우/일시정지/리셋. 화면 비율로 반응형 크기.
 */
class GameControls extends StatelessWidget {
  final GameStateManager gameState;
  final Function() onPause;
  final Function() onReset;
  final Function() onHold;

  const GameControls({
    required this.gameState,
    required this.onPause,
    required this.onReset,
    required this.onHold,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.sizeOf(context).height * 0.02; // 하단 여백 (비율)
    return Positioned(
      bottom: bottom,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _controlButton(gameState.isGameOver ? null : gameState.moveLeft, Colors.blue, Icons.arrow_back),
          _controlButton(gameState.isGameOver ? null : gameState.rotate, Colors.purple, Icons.rotate_right),
          _controlButton((gameState.isGameOver || !gameState.canHold) ? null : onHold, Colors.teal, Icons.swap_horiz),
          _controlButton(gameState.isGameOver ? null : gameState.moveDown, Colors.green, Icons.arrow_downward),
          _controlButton(gameState.isGameOver ? null : gameState.moveRight, Colors.blue, Icons.arrow_forward),
          _controlButton(gameState.isGameOver ? null : onPause, Colors.orange, gameState.isPaused ? Icons.play_arrow : Icons.pause),
          _controlButton(onReset, Colors.red, Icons.refresh),
        ],
      ),
    );
  }

  /** 원형 버튼 하나. [Expanded]+[AspectRatio]+[FittedBox]로 비율 유지. */
  Widget _controlButton(VoidCallback? onPressed, Color color, IconData icon) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cellSize = constraints.maxWidth; // 정사각형 한 변
            final padding = cellSize * 0.08;       // 버튼 주변 여백
            return Padding(
              padding: EdgeInsets.all(padding),
              child: FittedBox(
                fit: BoxFit.contain,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.all(16),
                    minimumSize: Size.zero,
                    shape: const CircleBorder(),
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

