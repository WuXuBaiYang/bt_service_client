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
enum HTTPMethod { POST, GET, PUT, DELETE }

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
