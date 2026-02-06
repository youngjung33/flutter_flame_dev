import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../managers/game_state_manager.dart';

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
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 왼쪽 이동
          ElevatedButton(
            onPressed: gameState.isGameOver ? null : gameState.moveLeft,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          // 회전
          ElevatedButton(
            onPressed: gameState.isGameOver ? null : gameState.rotate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.rotate_right, color: Colors.white),
          ),
          // Hold
          ElevatedButton(
            onPressed: (gameState.isGameOver || !gameState.canHold) ? null : onHold,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.swap_horiz, color: Colors.white),
          ),
          // 아래 이동
          ElevatedButton(
            onPressed: gameState.isGameOver ? null : gameState.moveDown,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.arrow_downward, color: Colors.white),
          ),
          // 오른쪽 이동
          ElevatedButton(
            onPressed: gameState.isGameOver ? null : gameState.moveRight,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
          // 일시정지
          ElevatedButton(
            onPressed: gameState.isGameOver ? null : onPause,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: Icon(
              gameState.isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
            ),
          ),
          // 리셋
          ElevatedButton(
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

