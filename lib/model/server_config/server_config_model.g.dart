// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerTypeAdapter extends TypeAdapter<ServerType> {
  @override
  final int typeId = 100;

  @override
  ServerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServerType.Aria2;
      case 1:
        return ServerType.Transmission;
      case 2:
        return ServerType.QBitTorrent;
      default:
        return ServerType.Aria2;
    }
  }

  @override
  void write(BinaryWriter writer, ServerType obj) {
    switch (obj) {
      case ServerType.Aria2:
        writer.writeByte(0);
        break;
      case ServerType.Transmission:
        writer.writeByte(1);
        break;
      case ServerType.QBitTorrent:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HTTPMethodAdapter extends TypeAdapter<HTTPMethod> {
  @override
  final int typeId = 101;

  @override
  HTTPMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HTTPMethod.POST;
      case 1:
        return HTTPMethod.GET;
      case 2:
        return HTTPMethod.PUT;
      case 3:
        return HTTPMethod.DELETE;
      default:
        return HTTPMethod.POST;
    }
  }

  @override
  void write(BinaryWriter writer, HTTPMethod obj) {
    switch (obj) {
      case HTTPMethod.POST:
        writer.writeByte(0);
        break;
      case HTTPMethod.GET:
        writer.writeByte(1);
        break;
      case HTTPMethod.PUT:
        writer.writeByte(2);
        break;
      case HTTPMethod.DELETE:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HTTPMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProtocolAdapter extends TypeAdapter<Protocol> {
  @override
  final int typeId = 102;

  @override
  Protocol read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Protocol.HTTP;
      case 1:
        return Protocol.HTTPS;
      case 2:
        return Protocol.WS;
      case 3:
        return Protocol.WSS;
      default:
        return Protocol.HTTP;
    }
  }

  @override
  void write(BinaryWriter writer, Protocol obj) {
    switch (obj) {
      case Protocol.HTTP:
        writer.writeByte(0);
        break;
      case Protocol.HTTPS:
        writer.writeByte(1);
        break;
      case Protocol.WS:
        writer.writeByte(2);
        break;
      case Protocol.WSS:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
