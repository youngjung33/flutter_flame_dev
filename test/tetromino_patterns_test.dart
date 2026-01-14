import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_game/core/constants/tetromino_patterns.dart';

void main() {
  group('TetrominoPatterns 테스트', () {
    test('모든 테트로미노 타입의 패턴이 존재하는지', () {
      for (int type = 1; type <= 7; type++) {
        for (int rotation = 0; rotation < 4; rotation++) {
          final pattern = TetrominoPatterns.getPattern(type, rotation);
          expect(pattern, isNotNull);
          expect(pattern.length, 4);
          expect(pattern[0].length, 4);
        }
      }
    });

    test('I 블록 패턴이 올바른지', () {
      final pattern0 = TetrominoPatterns.getPattern(1, 0); // I 블록, 0도 회전
      // I 블록은 가로로 4칸
      expect(pattern0[1], [1, 1, 1, 1]);
    });

    test('O 블록은 모든 회전이 동일한지', () {
      final pattern0 = TetrominoPatterns.getPattern(2, 0); // O 블록
      final pattern1 = TetrominoPatterns.getPattern(2, 1);
      final pattern2 = TetrominoPatterns.getPattern(2, 2);
      final pattern3 = TetrominoPatterns.getPattern(2, 3);

      // O 블록은 회전해도 모양이 같음
      expect(pattern0, pattern1);
      expect(pattern1, pattern2);
      expect(pattern2, pattern3);
    });

    test('패턴이 4x4 그리드인지', () {
      for (int type = 1; type <= 7; type++) {
        for (int rotation = 0; rotation < 4; rotation++) {
          final pattern = TetrominoPatterns.getPattern(type, rotation);
          expect(pattern.length, 4, reason: 'Type $type, Rotation $rotation');
          for (var row in pattern) {
            expect(row.length, 4, reason: 'Type $type, Rotation $rotation');
          }
        }
      }
    });

    test('색상이 올바르게 반환되는지', () {
      for (int type = 1; type <= 7; type++) {
        final color = TetrominoPatterns.getColorForType(type);
        expect(color, type);
      }
    });
  });
}

