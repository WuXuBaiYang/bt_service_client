import 'package:bt_service_manager/tools/file.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'server_database.dart';
/*
* 数据库管理
* @author jtechjh
* @Time 2021/5/14 9:04 上午
*/

class DBManage {
  static final _instance = DBManage._internal();

  factory DBManage() => _instance;

  DBManage._internal();

  //数据库路径
  final String _dbPath = "/hive_db";

  //服务数据库
  ServerDatabase server = ServerDatabase();

  //初始化
  Future<void> init() async {
    //初始化hive数据库
    Hive.init(await FileTools.getDocumentPath(path: _dbPath));
    //初始化子数据库
    await server.initDB();
  }
}

final dbManage = DBManage();

/*
* 数据库基类
* @author jtechjh
* @Time 2021/5/14 9:10 上午
*/
abstract class BaseDatabase {
  //初始化方法
  Future<void> initDB();

  //懒加载启动所有容器
  @protected
  Future<void> lazyLoadBox<T>(List<String> boxNames) async {
    for (var name in boxNames) {
      await Hive.openLazyBox<T>(name);
    }
  }

  //插入一条数据
  @protected
  Future<bool> insert<T>(
      {@required String boxName, @required T model, String key}) async {
    try {
      var box = await getBox<T>(boxName);
      if (null != box) {
        if (null != key && key.isNotEmpty) {
          await box.put(key, model);
        } else {
          await box.add(model);
        }
      }
      return true;
    } catch (e) {}
    return false;
  }

  //插入多条数据
  @protected
  Future<bool> insertAll<T>(
      {@required String boxName,
      List<T> modelList,
      Map<dynamic, T> modelMap}) async {
    try {
      var box = await getBox<T>(boxName);
      if (null != box) {
        if (null != modelList && modelList.isNotEmpty) {
          await box.addAll(modelList);
        } else if (null != modelMap && modelMap.isNotEmpty) {
          await box.putAll(modelMap);
        }
      }
      return true;
    } catch (e) {}
    return false;
  }

  //删除数据
  @protected
  Future<bool> delete<T>(
      {@required String boxName,
      String key,
      List<String> keys,
      int index}) async {
    try {
      var box = await getBox<T>(boxName);
      if (null != box) {
        if (null != key && key.isNotEmpty) {
          await box.delete(key);
        } else if (null != index && index >= 0) {
          await box.deleteAt(index);
        } else if (null != keys && keys.isNotEmpty) {
          await box.deleteAll(keys);
        }
      }
      return true;
    } catch (e) {}
    return false;
  }

  //修改数据数据
  @protected
  Future<bool> update<T>({
    @required String boxName,
    @required T model,
    String key,
    int index,
  }) async {
    try {
      var box = await getBox<T>(boxName);
      if (null != box) {
        if (null != key && key.isNotEmpty) {
          await box.put(key, model);
        } else if (null != index && index >= 0) {
          await box.putAt(index, model);
        }
      }
      return true;
    } catch (e) {}
    return false;
  }

  //修改多条数据
  @protected
  Future<bool> updateAll<T>({
    @required String boxName,
    @required Map<dynamic, T> modelMap,
  }) async {
    try {
      var box = await getBox<T>(boxName);
      if (null != box) {
        await box.putAll(modelMap);
      }
      return true;
    } catch (e) {}
    return false;
  }

  //获取数据
  @protected
  Future<T> get<T>(
      {@required String boxName, String key, int index, T def}) async {
    try {
      var box = await getBox<T>(boxName);
      if (null != box) {
        if (null != key && key.isNotEmpty) {
          return box.get(key, defaultValue: def);
        } else if (null != index && index >= 0) {
          return box.getAt(index);
        }
      }
    } catch (e) {}
    return def;
  }

  //获取全部数据-集合
  @protected
  Future<List<T>> getAllList<T>({@required String boxName}) async {
    try {
      var box = await getBox<T>(boxName);
      if (null != box) {
        return box.values.toList();
      }
    } catch (e) {}
    return [];
  }

  //获取全部数据-表
  @protected
  Future<Map<dynamic, T>> getAllMap<T>({@required String boxName}) async {
    try {
      var box = await getBox<T>(boxName);
      if (null != box) {
        return box.toMap();
      }
    } catch (e) {}
    return {};
  }

  //获取容器
  @protected
  Future<Box<T>> getBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return null;
  }
}
