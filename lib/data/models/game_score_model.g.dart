// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_score_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameScoreModelAdapter extends TypeAdapter<GameScoreModel> {
  @override
  final int typeId = 0;

  @override
  GameScoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameScoreModel(
      score: fields[0] as int,
      level: fields[1] as int,
      lines: fields[2] as int,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GameScoreModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.lines)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameScoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
