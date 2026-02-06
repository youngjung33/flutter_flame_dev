/// SRS (Super Rotation System) wall kick 데이터.
/// 회전 시 원래 위치가 막혀 있으면 이 오프셋을 순서대로 시도해 끼워 넣기.
/// 좌표: dx = 오른쪽(+), dy = 위쪽(+) → 적용 시 (x + dx, y - dy) 사용 (y는 아래가 +).
class WallKicks {
  WallKicks._();

  /// SRS 기본 킥 후 실패 시 시도할 단순 오프셋 (좌/우/위/아래 1~2칸)
  static const List<(int, int)> _fallbackKicks = [
    (-1, 0), (1, 0), (-2, 0), (2, 0),
    (0, 1), (0, -1), (0, 2), (0, -2),
    (-1, 1), (1, 1), (-1, -1), (1, -1),
  ];

  /// J, L, T, S, Z 공통 (시계 방향: from → (from+1)%4)
  static const List<List<(int, int)>> _jltszBase = [
    [ (0, 0), (-1, 0), (-1, 1), (0, -2), (-1, -2) ],
    [ (0, 0), ( 1, 0), ( 1, -1), (0,  2), ( 1,  2) ],
    [ (0, 0), ( 1, 0), ( 1, 1), (0, -2), ( 1, -2) ],
    [ (0, 0), (-1, 0), (-1, -1), (0,  2), (-1,  2) ],
  ];

  /// I 피스 전용 (시계 방향)
  static const List<List<(int, int)>> _iBase = [
    [ (0, 0), (-2, 0), ( 1, 0), (-2, -1), ( 1,  2) ],
    [ (0, 0), (-1, 0), ( 2, 0), (-1,  2), ( 2, -1) ],
    [ (0, 0), ( 2, 0), (-1, 0), ( 2,  1), (-1, -2) ],
    [ (0, 0), ( 1, 0), (-2, 0), ( 1, -2), (-2,  1) ],
  ];

  /** 각 회전 행에 SRS 기본 킥 뒤에 [_fallbackKicks]를 붙인 테이블 생성. */
  static List<List<(int, int)>> _withFallback(List<List<(int, int)>> base) {
    return [
      for (final row in base) [...row, ..._fallbackKicks],
    ];
  }

  static late final List<List<(int, int)>> jltsz = _withFallback(_jltszBase);
  static late final List<List<(int, int)>> i = _withFallback(_iBase);

  /// O 피스는 킥 없음 (제자리만)
  static const List<List<(int, int)>> o = [
    [ (0, 0) ],
    [ (0, 0) ],
    [ (0, 0) ],
    [ (0, 0) ],
  ];

  /// 피스 타입(1~7)에 해당하는 킥 테이블 반환.
  static List<List<(int, int)>> getKicksForType(int pieceType) {
    switch (pieceType) {
      case 1: return i;
      case 2: return o;
      default: return jltsz;
    }
  }
}
