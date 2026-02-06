import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasources/game_local_datasource.dart';
import '../../data/models/game_score_model.dart';
import '../../data/models/game_state_model.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/usecases/get_high_score.dart';
import '../../domain/usecases/load_game_state.dart';
import '../../domain/usecases/save_game_score.dart';
import '../../domain/usecases/save_game_state.dart';

/** GetIt 인스턴스 (DI 컨테이너). */
final sl = GetIt.instance;

/**
 * 의존성 주입 초기화: Hive 설정, DataSource/Repository/UseCase 등록.
 * 앱 시작 시 main()에서 한 번 호출.
 */
Future<void> init() async {
  // Hive 초기화
  await Hive.initFlutter();

  // Hive Adapter 등록 (0=GameScore, 1=GameState)
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(GameScoreModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(GameStateModelAdapter());
  }

  // Data Source
  sl.registerLazySingleton<GameLocalDataSource>(
    () => GameLocalDataSource(),
  );

  // Repository
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SaveGameScore(sl()));
  sl.registerLazySingleton(() => GetHighScore(sl()));
  sl.registerLazySingleton(() => SaveGameState(sl()));
  sl.registerLazySingleton(() => LoadGameState(sl()));
}

