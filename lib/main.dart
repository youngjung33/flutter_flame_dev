import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'core/di/service_locator.dart' as di;
import 'presentation/game/tetris_game.dart';
import 'presentation/managers/game_state_manager.dart';
import 'presentation/widgets/game_hud.dart';
import 'presentation/widgets/game_controls.dart';
import 'domain/usecases/save_game_score.dart';
import 'domain/usecases/get_high_score.dart';
import 'domain/usecases/save_game_state.dart';
import 'domain/usecases/load_game_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 의존성 주입 초기화
  await di.init();

  // 게임 상태 매니저 생성
  final gameState = GameStateManager(
    saveGameScore: di.sl<SaveGameScore>(),
    getHighScore: di.sl<GetHighScore>(),
    saveGameState: di.sl<SaveGameState>(),
    loadGameState: di.sl<LoadGameState>(),
  );

  // 게임 초기화
  await gameState.initialize();

  // 게임 생성
  final game = TetrisGame(gameState: gameState);

  runApp(MyApp(game: game, gameState: gameState));
}

class MyApp extends StatelessWidget {
  final TetrisGame game;
  final GameStateManager gameState;

  const MyApp({
    required this.game,
    required this.gameState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: GameScreen(game: game, gameState: gameState),
    );
  }
}

class GameScreen extends StatefulWidget {
  final TetrisGame game;
  final GameStateManager gameState;

  const GameScreen({
    required this.game,
    required this.gameState,
    super.key,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 위젯이 빌드된 후 포커스 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        widget.gameState.moveLeft();
        setState(() {});
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        widget.gameState.moveRight();
        setState(() {});
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        widget.gameState.startSoftDrop();
        widget.gameState.moveDown();
        setState(() {});
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.keyW) {
        widget.gameState.rotate();
        setState(() {});
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        widget.gameState.hardDrop();
        setState(() {});
      } else if (event.logicalKey == LogicalKeyboardKey.keyC ||
          event.logicalKey == LogicalKeyboardKey.keyH) {
        widget.gameState.hold();
        setState(() {});
      } else if (event.logicalKey == LogicalKeyboardKey.keyP) {
        setState(() {
          widget.gameState.togglePause();
        });
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        widget.gameState.stopSoftDrop();
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          children: [
            // 게임 화면
            GameWidget<TetrisGame>.controlled(
              gameFactory: () => widget.game,
            ),
            // HUD
            GameHUD(gameState: widget.gameState),
            // 컨트롤
            GameControls(
              gameState: widget.gameState,
              onPause: () {
                setState(() {
                  widget.gameState.togglePause();
                });
              },
              onReset: () {
                setState(() {
                  widget.gameState.reset();
                });
              },
              onHold: () {
                setState(() {
                  widget.gameState.hold();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}


