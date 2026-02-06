import 'package:flutter/material.dart';
import '../managers/game_state_manager.dart';

/**
 * 게임 HUD: 점수·레벨·라인·최고점·PAUSED·GAME OVER를 화면 비율로 왼쪽 상단에 표시.
 */
class GameHUD extends StatelessWidget {
  final GameStateManager gameState;

  const GameHUD({required this.gameState, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final short = size.shortestSide;   // 폰트/간격 비율 기준
    final top = size.height * 0.02;    // 상단 여백
    final left = size.width * 0.04;     // 좌측 여백
    final titleFontSize = short * 0.045;  // 점수 등 제목
    final bodyFontSize = short * 0.038;   // 레벨·라인
    final smallFontSize = short * 0.034;  // 최고점
    final largeFontSize = short * 0.06;   // PAUSED / GAME OVER
    final spacing = short * 0.012;        // 항목 간 간격
    final largeSpacing = short * 0.02;   // 섹션 간 간격

    return Positioned(
      top: top,
      left: left,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Score: ${gameState.score}',
            style: TextStyle(
              color: Colors.white,
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(short * 0.005, short * 0.005),
                  blurRadius: short * 0.01,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          SizedBox(height: spacing),
          Text(
            'Level: ${gameState.level}',
            style: TextStyle(
              color: Colors.white,
              fontSize: bodyFontSize,
              shadows: [
                Shadow(
                  offset: Offset(short * 0.005, short * 0.005),
                  blurRadius: short * 0.01,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          SizedBox(height: spacing),
          Text(
            'Lines: ${gameState.lines}',
            style: TextStyle(
              color: Colors.white,
              fontSize: bodyFontSize,
              shadows: [
                Shadow(
                  offset: Offset(short * 0.005, short * 0.005),
                  blurRadius: short * 0.01,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          if (gameState.highScore != null) ...[
            SizedBox(height: largeSpacing),
            Text(
              'High Score: ${gameState.highScore!.score}',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: smallFontSize,
                shadows: [
                  Shadow(
                    offset: Offset(short * 0.005, short * 0.005),
                    blurRadius: short * 0.01,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
          if (gameState.isPaused) ...[
            SizedBox(height: largeSpacing),
            Text(
              'PAUSED',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: largeFontSize,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(short * 0.005, short * 0.005),
                    blurRadius: short * 0.01,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
          if (gameState.isGameOver) ...[
            SizedBox(height: largeSpacing),
            Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.red,
                fontSize: largeFontSize,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(short * 0.005, short * 0.005),
                    blurRadius: short * 0.01,
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
