// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qb_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QBConfigModelAdapter extends TypeAdapter<QBConfigModel> {
  @override
  final int typeId = 3;

  @override
  QBConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QBConfigModel()
      ..protocol = fields[50] == null ? '' : fields[50] as Protocol
      ..hostname = fields[51] == null ? '' : fields[51] as String
      ..port = fields[52] == null ? 80 : fields[52] as num
      ..id = fields[0] == null ? '' : fields[0] as String
      ..createTime = fields[1] == null ? 0 : fields[1] as DateTime
      ..updateTime = fields[2] == null ? 0 : fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, QBConfigModel obj) {
    writer
      ..writeByte(6)
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
      other is QBConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
