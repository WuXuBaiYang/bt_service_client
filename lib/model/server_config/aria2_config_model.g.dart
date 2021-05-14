// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aria2_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Aria2ConfigModelAdapter extends TypeAdapter<Aria2ConfigModel> {
  @override
  final int typeId = 1;

  @override
  Aria2ConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Aria2ConfigModel()
      ..path = fields[100] == null ? 'jsonrpc' : fields[100] as String
      ..method = fields[101] == null ? 'POST' : fields[101] as HTTPMethod
      ..secretToken = fields[102] == null ? '' : fields[102] as String
      ..protocol = fields[50] == null ? '' : fields[50] as Protocol
      ..hostname = fields[51] == null ? '' : fields[51] as String
      ..port = fields[52] == null ? 80 : fields[52] as num
      ..id = fields[0] == null ? '' : fields[0] as String
      ..createTime = fields[1] == null ? 0 : fields[1] as DateTime
      ..updateTime = fields[2] == null ? 0 : fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Aria2ConfigModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(100)
      ..write(obj.path)
      ..writeByte(101)
      ..write(obj.method)
      ..writeByte(102)
      ..write(obj.secretToken)
      ..writeByte(50)
      ..write(obj.protocol)
      ..writeByte(51)
      ..write(obj.hostname)
      ..writeByte(52)
      ..write(obj.port)
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
      other is Aria2ConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
