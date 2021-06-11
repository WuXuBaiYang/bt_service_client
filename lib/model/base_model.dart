import 'package:bt_service_manager/tools/tools.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

/*
* 基类
* @author jtechjh
* @Time 2021/5/12 5:44 下午
*/
// ignore: must_be_immutable
abstract class BaseModel extends Equatable {
  //id
  @HiveField(0, defaultValue: "")
  String id;

  //创建时间
  @HiveField(1, defaultValue: 0)
  DateTime createTime;

  //更新时间
  @HiveField(2, defaultValue: 0)
  DateTime updateTime;

  BaseModel({
    String id,
    DateTime createTime,
    DateTime updateTime,
  })  : id = id ?? Tools.generationID,
        createTime = createTime ?? DateTime.now(),
        updateTime = updateTime ?? DateTime.now();

  @override
  List<Object> get props => [
        id,
        createTime,
        updateTime,
      ];

  fromJson(json) {}

  //将json转换为集合
  List<T> fromList<T extends BaseModel>(
    obj, {
    @required T Function(Map item) from,
    List<T> def = const [],
  }) {
    if (obj is List) {
      List<T> tempList = [];
      for (dynamic item in obj) {
        tempList.add(from(item));
      }
      return tempList;
    }
    return def;
  }

  toJson() {}
}
