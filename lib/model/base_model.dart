import 'package:bt_service_manager/tools/tools.dart';
import 'package:hive/hive.dart';

/*
* 基类
* @author jtechjh
* @Time 2021/5/12 5:44 下午
*/
abstract class BaseModel extends HiveObject {
  //id
  @HiveField(0, defaultValue: "")
  String id;

  //创建时间
  @HiveField(1, defaultValue: 0)
  num createTime;

  //更新时间
  @HiveField(2, defaultValue: 0)
  num updateTime;

  BaseModel() {
    id = Tools.generationID;
    createTime = DateTime.now().millisecondsSinceEpoch;
    updateTime = createTime;
  }
}

/*
* http协议
* @author jtechjh
* @Time 2021/5/13 5:17 下午
*/
@HiveType(typeId: 1)
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
@HiveType(typeId: 1)
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
