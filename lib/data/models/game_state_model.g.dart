// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStateModelAdapter extends TypeAdapter<GameStateModel> {
  @override
  final int typeId = 1;

  @override
  GameStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameStateModel(
      board: (fields[0] as List)
          .map((dynamic e) => (e as List).cast<int>())
          .toList(),
      currentPieceType: fields[1] as int,
      currentPieceX: fields[2] as int,
      currentPieceY: fields[3] as int,
      currentRotation: fields[4] as int,
      nextPieceType: fields[5] as int,
      nextPieceQueue: (fields[11] as List).cast<int>(),
      holdPieceType: fields[12] as int?,
      canHold: fields[13] as bool,
      score: fields[6] as int,
      level: fields[7] as int,
      lines: fields[8] as int,
      isGameOver: fields[9] as bool,
      isPaused: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GameStateModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.board)
      ..writeByte(1)
      ..write(obj.currentPieceType)
      ..writeByte(2)
      ..write(obj.currentPieceX)
      ..writeByte(3)
      ..write(obj.currentPieceY)
      ..writeByte(4)
      ..write(obj.currentRotation)
      ..writeByte(5)
      ..write(obj.nextPieceType)
      ..writeByte(11)
      ..write(obj.nextPieceQueue)
      ..writeByte(12)
      ..write(obj.holdPieceType)
      ..writeByte(13)
      ..write(obj.canHold)
      ..writeByte(6)
      ..write(obj.score)
      ..writeByte(7)
      ..write(obj.level)
      ..writeByte(8)
      ..write(obj.lines)
      ..writeByte(9)
      ..write(obj.isGameOver)
      ..writeByte(10)
      ..write(obj.isPaused);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
