// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerStateAdapter extends TypeAdapter<ServerState> {
  @override
  final int typeId = 230;

  @override
  ServerState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServerState.Disconnected;
      case 1:
        return ServerState.Connected;
      case 2:
        return ServerState.Connecting;
      default:
        return ServerState.Disconnected;
    }
  }

  @override
  void write(BinaryWriter writer, ServerState obj) {
    switch (obj) {
      case ServerState.Disconnected:
        writer.writeByte(0);
        break;
      case ServerState.Connected:
        writer.writeByte(1);
        break;
      case ServerState.Connecting:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GlobalSettingsModelAdapter extends TypeAdapter<GlobalSettingsModel> {
  @override
  final int typeId = 200;

  @override
  GlobalSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GlobalSettingsModel(
      globalDownSpeedLevel: fields[30] == null
          ? []
          : (fields[30] as List)?.cast<SpeedLevelItem>(),
      globalUpSpeedLevel: fields[31] == null
          ? []
          : (fields[31] as List)?.cast<SpeedLevelItem>(),
      downSpeedLevel: fields[32] == null
          ? []
          : (fields[32] as List)?.cast<SpeedLevelItem>(),
      upSpeedLevel: fields[33] == null
          ? []
          : (fields[33] as List)?.cast<SpeedLevelItem>(),
      serverStates: fields[34] == null
          ? []
          : (fields[34] as Map)?.cast<ServerState, ServerStateItem>(),
    )
      ..id = fields[0] == null ? '' : fields[0] as String
      ..createTime = fields[1] == null ? 0 : fields[1] as DateTime
      ..updateTime = fields[2] == null ? 0 : fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, GlobalSettingsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(30)
      ..write(obj.globalDownSpeedLevel)
      ..writeByte(31)
      ..write(obj.globalUpSpeedLevel)
      ..writeByte(32)
      ..write(obj.downSpeedLevel)
      ..writeByte(33)
      ..write(obj.upSpeedLevel)
      ..writeByte(34)
      ..write(obj.serverStates)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createTime)
      ..writeByte(2)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlobalSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpeedLevelItemAdapter extends TypeAdapter<SpeedLevelItem> {
  @override
  final int typeId = 220;

  @override
  SpeedLevelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpeedLevelItem(
      speed: fields[30] == null ? 0 : fields[30] as num,
      color: fields[31] == null ? 4294967295 : fields[31] as int,
    )
      ..id = fields[0] == null ? '' : fields[0] as String
      ..createTime = fields[1] == null ? 0 : fields[1] as DateTime
      ..updateTime = fields[2] == null ? 0 : fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, SpeedLevelItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(30)
      ..write(obj.speed)
      ..writeByte(31)
      ..write(obj.color)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createTime)
      ..writeByte(2)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeedLevelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServerStateItemAdapter extends TypeAdapter<ServerStateItem> {
  @override
  final int typeId = 221;

  @override
  ServerStateItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerStateItem(
      state: fields[30] == null ? 0 : fields[30] as ServerState,
      color: fields[31] == null ? 4294967295 : fields[31] as int,
    )
      ..id = fields[0] == null ? '' : fields[0] as String
      ..createTime = fields[1] == null ? 0 : fields[1] as DateTime
      ..updateTime = fields[2] == null ? 0 : fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, ServerStateItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(30)
      ..write(obj.state)
      ..writeByte(31)
      ..write(obj.color)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createTime)
      ..writeByte(2)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerStateItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
