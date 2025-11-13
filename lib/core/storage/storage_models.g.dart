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
    // Обработка миграции: если seedColorValue отсутствует (старые данные), используем значение по умолчанию
    final seedColorValue = fields[5] as int? ?? Colors.teal.value;
    return SettingsModel(
      language: fields[0] as String,
      isSoundEnabled: fields[1] as bool,
      isAnimationsEnabled: fields[2] as bool,
      isVibrationEnabled: fields[3] as bool,
      themeModeIndex: fields[4] as int,
      seedColor: Color(seedColorValue),
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

class StatisticsAdapter extends TypeAdapter<Statistics> {
  @override
  final int typeId = 1;

  @override
  Statistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Statistics(
      totalGames: fields[0] as int,
      totalWins: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Statistics obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.totalGames)
      ..writeByte(1)
      ..write(obj.totalWins);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
