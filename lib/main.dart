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
  @override
  void initState() {
    super.initState();
    // 키보드 입력 리스너 (데스크톱용)
    _setupKeyboardListener();
  }

  void _setupKeyboardListener() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              widget.gameState.moveLeft();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              widget.gameState.moveRight();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              widget.gameState.moveDown();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
                event.logicalKey == LogicalKeyboardKey.keyW) {
              widget.gameState.rotate();
            } else if (event.logicalKey == LogicalKeyboardKey.space) {
              widget.gameState.hardDrop();
            } else if (event.logicalKey == LogicalKeyboardKey.keyP) {
              widget.gameState.togglePause();
            }
          }
        },
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
            ),
          ],
        ),
      ),
    );
  }
}
