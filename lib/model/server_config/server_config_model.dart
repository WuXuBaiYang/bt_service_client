import 'package:bt_service_manager/model/base_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'server_config_model.g.dart';

/*
* 服务配置对象
* @author jtechjh
* @Time 2021/5/13 4:22 下午
*/
abstract class ServerConfigModel extends BaseModel {
  //协议
  @HiveField(50, defaultValue: Protocol.HTTP)
  Protocol protocol;

  //域名/IP
  @HiveField(51, defaultValue: "")
  String hostname;

  //端口号
  @HiveField(52, defaultValue: 80)
  num port;

  //别名
  @HiveField(53, defaultValue: "")
  String alias;

  //标签
  @HiveField(54, defaultValue: <String>[])
  List<String> tags;

  //标记颜色
  @HiveField(55, defaultValue: Colors.transparent)
  Color flagColor;

  //自定义图标路径
  @HiveField(56, defaultValue: "")
  String logoPath;

  //服务器类别
  @HiveField(57)
  ServerType type;

  //排序序号
  @HiveField(58, defaultValue: 0)
  int orderNum;

  //拼接基础地址
  String get baseUrl => "${protocol.text}$hostname:$port";

  //判断当前配置是否为编辑状态
  bool get isEdited => id?.isNotEmpty ?? false;

  ServerConfigModel();

  ServerConfigModel.create(
    this.alias,
    this.tags,
    this.flagColor,
    this.logoPath,
    this.protocol,
    this.hostname,
    this.port,
    this.type,
  );
}

/*
* 服务器类别
* @author jtechjh
* @Time 2021/5/19 2:47 下午
*/
@HiveType(typeId: 100)
enum ServerType {
  @HiveField(0)
  Aria2,
  @HiveField(1)
  Transmission,
  @HiveField(2)
  QBitTorrent,
}

/*
* 扩展服务器类别输出服务器类型文本
* @author jtechjh
* @Time 2021/5/19 2:48 下午
*/
extension ServerTypeExtension on ServerType {
  String get text {
    switch (this) {
      case ServerType.Aria2:
        return "Aria2";
      case ServerType.Transmission:
        return "Transmission";
      case ServerType.QBitTorrent:
        return "QBitTorrent";
    }
    return "";
  }
}

/*
* http协议
* @author jtechjh
* @Time 2021/5/13 5:17 下午
*/
@HiveType(typeId: 101)
enum HTTPMethod {
  @HiveField(0, defaultValue: true)
  POST,
  @HiveField(1)
  GET,
  @HiveField(2)
  PUT,
  @HiveField(3)
  DELETE,
}

/*
* 扩展http协议枚举方法
* @author jtechjh
* @Time 2021/5/13 5:19 下午
*/
extension HTTPMethodExtension on HTTPMethod {
  //获取枚举对应文本
  String get text {
    switch (this) {
      case HTTPMethod.POST:
        return "POST";
      case HTTPMethod.GET:
        return "GET";
      case HTTPMethod.PUT:
        return "PUT";
      case HTTPMethod.DELETE:
        return "DELETE";
    }
    return "";
  }
}

/*
* 请求协议
* @author jtechjh
* @Time 2021/5/14 8:52 上午
*/
@HiveType(typeId: 102)
enum Protocol {
  @HiveField(0, defaultValue: true)
  HTTP,
  @HiveField(1)
  HTTPS,
  @HiveField(2)
  WS,
  @HiveField(3)
  WSS,
}

extension ProtocolExtension on Protocol {
  //获取枚举对应文本
  String get text {
    switch (this) {
      case Protocol.HTTP:
        return "http://";
      case Protocol.HTTPS:
        return "https://";
      case Protocol.WS:
        return "ws://";
      case Protocol.WSS:
        return "wss://";
    }
    return "";
  }
}
