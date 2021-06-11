import 'package:bt_service_manager/model/base_model.dart';
import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/model/server_config/qb_config_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/model/server_config/tm_config_model.dart';
import 'package:bt_service_manager/tools/file.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'server_db.dart';
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

  //服务器配置
  final server = ServerDatabase();

  //初始化
  Future<void> init() async {
    //初始化hive数据库
    Hive.init(await FileTools.getDocumentPath(path: _dbPath));
    //初始化子数据库
    await server.initDB();
    //注册通用协议数据库适配器
    _registerAdapter();
  }

  //注册适配器
  _registerAdapter() {
    //服务器相关
    Hive.registerAdapter<HTTPMethod>(HTTPMethodAdapter());
    Hive.registerAdapter<Protocol>(ProtocolAdapter());
    Hive.registerAdapter<ServerType>(ServerTypeAdapter());
    Hive.registerAdapter<QBConfigModel>(QBConfigModelAdapter());
    Hive.registerAdapter<Aria2ConfigModel>(Aria2ConfigModelAdapter());
    Hive.registerAdapter<TMConfigModel>(TMConfigModelAdapter());
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

  //插入一条数据
  @protected
  Future<void> insert<T extends BaseModel>(String boxName,
      {@required T model}) async {
    var box = await getBox<T>(boxName);
    await box?.put(model.id, model);
  }

  //插入多条数据
  @protected
  Future<void> insertAll<T extends BaseModel>(String boxName,
      {@required List<T> models}) async {
    var box = await getBox<T>(boxName);
    for (var item in models) {
      await box?.put(item.id, item);
    }
  }

  //删除数据
  @protected
  Future<void> delete<T extends BaseModel>(String boxName,
      {@required String key}) async {
    var box = await getBox<T>(boxName);
    await box?.delete(key);
  }

  //修改数据数据
  @protected
  Future<void> update<T extends BaseModel>(String boxName,
      {@required T model}) async {
    var box = await getBox<T>(boxName);
    await box?.put(model.id, model);
  }

  //修改多条数据
  @protected
  Future<void> updateAll<T extends BaseModel>(String boxName,
      {@required List<T> models}) async {
    var box = await getBox<T>(boxName);
    for (var item in models) {
      await box?.put(item.id, item);
    }
  }

  //获取数据
  @protected
  Future<T> query<T extends BaseModel>(String boxName,
      {@required String key, T def}) async {
    var box = await getBox<T>(boxName);
    return box?.get(key, defaultValue: def);
  }

  //获取全部数据-集合
  @protected
  Future<List<T>> queryAll<T extends BaseModel>(String boxName) async {
    var box = await getBox<T>(boxName);
    return box?.values?.toList() ?? [];
  }

  @protected
  Future<int> queryLength<T extends BaseModel>(String boxName) async {
    var box = await getBox<T>(boxName);
    return box?.length ?? 0;
  }

  //监听一个box的对象
  @protected
  Future<Stream<BoxEvent>> watch<T extends BaseModel>(String boxName,
      {@required String key}) async {
    var box = await getBox<T>(boxName);
    return box?.watch(key: key);
  }

  //获取容器
  @protected
  Future<Box<T>> getBox<T>(String name) => Hive.openBox<T>(name);
}
