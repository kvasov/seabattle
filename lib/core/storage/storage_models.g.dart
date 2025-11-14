// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 0;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      language: fields[0] as String,
      isSoundEnabled: fields[1] as bool,
      isAnimationsEnabled: fields[2] as bool,
      isVibrationEnabled: fields[3] as bool,
      themeModeIndex: fields[4] as int,
      seedColorValue: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.isSoundEnabled)
      ..writeByte(2)
      ..write(obj.isAnimationsEnabled)
      ..writeByte(3)
      ..write(obj.isVibrationEnabled)
      ..writeByte(4)
      ..write(obj.themeModeIndex)
      ..writeByte(5)
      ..write(obj.seedColorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatisticsModelAdapter extends TypeAdapter<StatisticsModel> {
  @override
  final int typeId = 1;

  @override
  StatisticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatisticsModel(
      totalGames: fields[0] as int,
      totalWins: fields[1] as int,
      totalHits: fields[2] as int,
      totalShots: fields[3] as int,
      totalCancelled: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StatisticsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalGames)
      ..writeByte(1)
      ..write(obj.totalWins)
      ..writeByte(2)
      ..write(obj.totalHits)
      ..writeByte(3)
      ..write(obj.totalShots)
      ..writeByte(4)
      ..write(obj.totalCancelled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
