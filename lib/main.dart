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

/**
 * 앱 진입점.
 * 세로 고정, DI·게임 상태·Flame 게임 초기화 후 [MyApp] 실행.
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 세로 모드만 지원 (테트리스 UI에 맞춤)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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

/**
 * 루트 위젯. 다크 테마 MaterialApp으로 [GameScreen]을 홈으로 표시.
 */
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

/**
 * 게임 화면. Flame [GameWidget], HUD, 터치 컨트롤을 겹쳐 표시하고 키보드 입력을 처리.
 */
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
  // 키보드 포커스용 (방향키·스페이스 등 입력 수신)
  final FocusNode _focusNode = FocusNode();
  // 스페이스 키 반복 입력 무시용: KeyUp 전까지 true 유지
  bool _spaceKeyHeld = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /**
   * 키 입력 처리: 좌/우/아래/회전, 스페이스(하드드롭), C/H(Hold), P(일시정지).
   * 스페이스는 키 반복 시 무시하고, 아래 화살표는 KeyUp 시 소프트드롭 해제.
   */
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
        // 키 반복 무시: 같은 키가 눌린 채로 들어오는 KeyDown은 무시, KeyUp 후에만 새로 처리
        if (_spaceKeyHeld) return;
        _spaceKeyHeld = true;
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
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        _spaceKeyHeld = false;
      }
    }
  }

  /** 게임 화면·HUD·하단 컨트롤을 Stack으로 겹쳐 표시. */
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


