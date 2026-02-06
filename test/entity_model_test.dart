import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_game/data/models/game_score_model.dart';
import 'package:tetris_game/data/models/game_state_model.dart';
import 'package:tetris_game/domain/entities/game_score.dart';
import 'package:tetris_game/domain/entities/game_state.dart';

void main() {
  group('GameScore Entity/Model 변환 테스트', () {
    test('Entity에서 Model로 변환', () {
      final entity = GameScore(
        score: 1000,
        level: 5,
        lines: 50,
        timestamp: DateTime(2024, 1, 1),
      );

      final model = GameScoreModel.fromEntity(entity);

      expect(model.score, 1000);
      expect(model.level, 5);
      expect(model.lines, 50);
      expect(model.timestamp, DateTime(2024, 1, 1));
    });

    test('Model에서 Entity로 변환', () {
      final model = GameScoreModel(
        score: 2000,
        level: 10,
        lines: 100,
        timestamp: DateTime(2024, 2, 1),
      );

      final entity = model.toEntity();

      expect(entity.score, 2000);
      expect(entity.level, 10);
      expect(entity.lines, 100);
      expect(entity.timestamp, DateTime(2024, 2, 1));
    });

    test('양방향 변환 일관성', () {
      final originalEntity = GameScore(
        score: 1500,
        level: 7,
        lines: 75,
        timestamp: DateTime.now(),
      );

      final model = GameScoreModel.fromEntity(originalEntity);
      final convertedEntity = model.toEntity();

      expect(convertedEntity.score, originalEntity.score);
      expect(convertedEntity.level, originalEntity.level);
      expect(convertedEntity.lines, originalEntity.lines);
      expect(convertedEntity.timestamp, originalEntity.timestamp);
    });
  });

  group('GameState Entity/Model 변환 테스트', () {
    test('Entity에서 Model로 변환', () {
      final board = List.generate(
        20,
        (_) => List.filled(10, 0),
      );
      board[19][5] = 1; // 테스트용 블록

      final entity = GameState(
        board: board,
        currentPieceType: 2,
        currentPieceX: 5,
        currentPieceY: 10,
        currentRotation: 1,
        nextPieceType: 3,
        nextPieceQueue: [4, 5, 6, 7, 1],
        holdPieceType: null,
        canHold: true,
        score: 500,
        level: 2,
        lines: 15,
        isGameOver: false,
        isPaused: false,
      );

      final model = GameStateModel.fromEntity(entity);

      expect(model.currentPieceType, 2);
      expect(model.currentPieceX, 5);
      expect(model.currentPieceY, 10);
      expect(model.currentRotation, 1);
      expect(model.nextPieceType, 3);
      expect(model.score, 500);
      expect(model.level, 2);
      expect(model.lines, 15);
      expect(model.isGameOver, false);
      expect(model.isPaused, false);
      expect(model.board.length, 20);
      expect(model.board[19][5], 1);
    });

    test('Model에서 Entity로 변환', () {
      final board = List.generate(
        20,
        (_) => List.filled(10, 0),
      );
      board[18][3] = 4;

      final model = GameStateModel(
        board: board,
        currentPieceType: 1,
        currentPieceX: 3,
        currentPieceY: 8,
        currentRotation: 2,
        nextPieceType: 5,
        nextPieceQueue: [2, 3, 4, 5, 6],
        holdPieceType: 7,
        canHold: false,
        score: 750,
        level: 3,
        lines: 20,
        isGameOver: true,
        isPaused: false,
      );

      final entity = model.toEntity();

      expect(entity.currentPieceType, 1);
      expect(entity.currentPieceX, 3);
      expect(entity.currentPieceY, 8);
      expect(entity.currentRotation, 2);
      expect(entity.nextPieceType, 5);
      expect(entity.score, 750);
      expect(entity.level, 3);
      expect(entity.lines, 20);
      expect(entity.isGameOver, true);
      expect(entity.isPaused, false);
      expect(entity.board.length, 20);
      expect(entity.board[18][3], 4);
    });

    test('양방향 변환 일관성', () {
      final board = List.generate(
        20,
        (_) => List.filled(10, 0),
      );
      for (int i = 0; i < 10; i++) {
        board[19][i] = 1; // 한 줄 채우기
      }

      final originalEntity = GameState(
        board: board,
        currentPieceType: 6,
        currentPieceX: 4,
        currentPieceY: 15,
        currentRotation: 3,
        nextPieceType: 7,
        nextPieceQueue: [1, 2, 3, 4, 5],
        holdPieceType: 2,
        canHold: true,
        score: 1000,
        level: 4,
        lines: 30,
        isGameOver: false,
        isPaused: true,
      );

      final model = GameStateModel.fromEntity(originalEntity);
      final convertedEntity = model.toEntity();

      expect(convertedEntity.currentPieceType, originalEntity.currentPieceType);
      expect(convertedEntity.currentPieceX, originalEntity.currentPieceX);
      expect(convertedEntity.currentPieceY, originalEntity.currentPieceY);
      expect(convertedEntity.currentRotation, originalEntity.currentRotation);
      expect(convertedEntity.nextPieceType, originalEntity.nextPieceType);
      expect(convertedEntity.score, originalEntity.score);
      expect(convertedEntity.level, originalEntity.level);
      expect(convertedEntity.lines, originalEntity.lines);
      expect(convertedEntity.isGameOver, originalEntity.isGameOver);
      expect(convertedEntity.isPaused, originalEntity.isPaused);
      expect(convertedEntity.board.length, originalEntity.board.length);
      for (int i = 0; i < 10; i++) {
        expect(convertedEntity.board[19][i], originalEntity.board[19][i]);
      }
    });
  });
}

