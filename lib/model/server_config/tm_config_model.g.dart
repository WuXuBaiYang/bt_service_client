// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tm_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TMConfigModelAdapter extends TypeAdapter<TMConfigModel> {
  @override
  final int typeId = 3;

  @override
  TMConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TMConfigModel()
      ..path = fields[30] == null ? 'jsonrpc' : fields[30] as String
      ..method = fields[31] == null ? HTTPMethod.POST : fields[31] as HTTPMethod
      ..secretToken = fields[32] == null ? '' : fields[32] as String
      ..protocol = fields[50] == null ? Protocol.HTTP : fields[50] as Protocol
      ..hostname = fields[51] == null ? '' : fields[51] as String
      ..port = fields[52] == null ? 80 : fields[52] as num
      ..alias = fields[53] == null ? '' : fields[53] as String
      ..tags = fields[54] == null ? [] : (fields[54] as List)?.cast<String>()
      ..flagColor = fields[55] == null ? const Color(0) : fields[55] as Color
      ..logoPath = fields[56] == null ? '' : fields[56] as String
      ..logoCircle = fields[57] == null ? true : fields[57] as bool
      ..type = fields[58] as ServerType
      ..orderNum = fields[59] == null ? 0 : fields[59] as int
      ..id = fields[0] == null ? '' : fields[0] as String
      ..createTime = fields[1] == null ? 0 : fields[1] as DateTime
      ..updateTime = fields[2] == null ? 0 : fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, TMConfigModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(30)
      ..write(obj.path)
      ..writeByte(31)
      ..write(obj.method)
      ..writeByte(32)
      ..write(obj.secretToken)
      ..writeByte(50)
      ..write(obj.protocol)
      ..writeByte(51)
      ..write(obj.hostname)
      ..writeByte(52)
      ..write(obj.port)
      ..writeByte(53)
      ..write(obj.alias)
      ..writeByte(54)
      ..write(obj.tags)
      ..writeByte(55)
      ..write(obj.flagColor)
      ..writeByte(56)
      ..write(obj.logoPath)
      ..writeByte(57)
      ..write(obj.logoCircle)
      ..writeByte(58)
      ..write(obj.type)
      ..writeByte(59)
      ..write(obj.orderNum)
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
      other is TMConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
