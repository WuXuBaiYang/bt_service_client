import 'package:bt_service_manager/tools/tools.dart';
import 'package:hive/hive.dart';

/*
* 基类
* @author jtechjh
* @Time 2021/5/12 5:44 下午
*/
abstract class BaseModel {
  //id
  @HiveField(0, defaultValue: "")
  String id;

  //创建时间
  @HiveField(1, defaultValue: 0)
  DateTime createTime;

  //更新时间
  @HiveField(2, defaultValue: 0)
  DateTime updateTime;

  BaseModel() {
    id = Tools.generationID;
    createTime = DateTime.now();
    updateTime = createTime;
  }
}