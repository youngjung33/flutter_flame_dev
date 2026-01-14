import 'package:flutter/material.dart';
import '../managers/game_state_manager.dart';

class GameHUD extends StatelessWidget {
  final GameStateManager gameState;

  const GameHUD({required this.gameState, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score: ${gameState.score}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Level: ${gameState.level}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lines: ${gameState.lines}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          if (gameState.highScore != null) ...[
            const SizedBox(height: 16),
            Text(
              'High Score: ${gameState.highScore!.score}',
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 18,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
          if (gameState.isPaused) ...[
            const SizedBox(height: 16),
            const Text(
              'PAUSED',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
          if (gameState.isGameOver) ...[
            const SizedBox(height: 16),
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.red,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

