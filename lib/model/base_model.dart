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

  toJson() {}

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

  //将json转换为map
  Map<K, V> fromMap<K, V>(
    obj, {
    @required Map<K, V> Function(dynamic k, dynamic v) from,
    Map<K, V> def = const {},
  }) {
    if (obj is Map) {
      Map<K, V> tempMap = {};
      for (dynamic k in obj.keys) {
        dynamic v = obj[k];
        tempMap.addAll(from(k, v));
      }
      return tempMap;
    }
    return def;
  }

  //将集合转换为json
  List toList<T extends BaseModel>(List<T> data, {List def = const []}) {
    if (null == data) return def;
    List tempList = [];
    for (T item in data) {
      tempList.add(item.toJson());
    }
    return tempList;
  }

  //将json转换为map
  Map toMap<K, V>(
    Map<K, V> data, {
    @required Map Function(K k, V v) to,
    Map def = const {},
  }) {
    if (null == data) return def;
    Map tempMap = {};
    for (K k in data.keys) {
      V v = data[k];
      tempMap.addAll(to(k, v));
    }
    return tempMap;
  }
}
