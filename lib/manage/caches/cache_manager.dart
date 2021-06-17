import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'global_setting_cache.dart';

/*
* 缓存管理
* @author wuxubaiyang
* @Time 2021/6/11 上午11:15
*/
class CacheManage {
  static final _instance = CacheManage._internal();

  factory CacheManage() => _instance;

  CacheManage._internal();

  //全局设置
  final globalSettingCache = GlobalSettingCache();

  //初始化
  Future<void> init() async {
    //初始化子缓存
    await globalSettingCache.initCache();
  }
}

final cacheManage = CacheManage();

/*
* 缓存管理基类
* @author wuxubaiyang
* @Time 2021/6/11 上午11:19
*/
abstract class BaseCache {
  //数据有效期key值后缀
  final expirationSuffix = "_expiration";

  //持有SharedPreferences对象
  SharedPreferences _sp;

  //初始化方法
  Future<void> initCache() async {
    _sp = await SharedPreferences.getInstance();
  }

  //获取有效期字段key
  String _getExpirationKey(String key) => "$key$expirationSuffix";

  //检查数据有效期
  bool _checkExpiration(String key) {
    var expirationKey = _getExpirationKey(key);
    if (!_sp.containsKey(expirationKey)) return true;
    var microsecondsSinceEpoch = _sp.getInt(expirationKey);
    var expirationDate =
        DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);
    return expirationDate.isAfter(DateTime.now());
  }

  //写入数据有效期微秒数
  Future<void> _setupValueExpiration(String key, Duration expiration) async {
    if (null == expiration || expiration.inMicroseconds <= 0) return;
    var expirationKey = _getExpirationKey(key);
    var expirationDate = DateTime.now().add(expiration);
    await _sp.setInt(expirationKey, expirationDate.microsecondsSinceEpoch);
  }

  //移除有效期字段
  Future<bool> _removeValueExpiration(String key) async {
    var expirationKey = _getExpirationKey(key);
    return await _sp.remove(expirationKey);
  }

  //获取数据检查
  bool _getValueCheck(String key) =>
      _sp.containsKey(key) || _checkExpiration(key);

  //存储数据检查
  bool _setValueCheck(value) => null != value;

  //删除数据
  Future<bool> remove(String key) async {
    await _removeValueExpiration(key);
    return await _sp.remove(key);
  }

  //获取数据
  T get<T>(String key, {T def}) {
    if (!_getValueCheck(key)) return def;
    return _sp.get(key) as T;
  }

  //获取string类型数据
  String getString(String key, {String def}) {
    if (!_getValueCheck(key)) return def;
    return _sp.getString(key);
  }

  //获取jsonMap对象
  Map getJsonMap(String key, {Map def}) {
    var json = getString(key);
    if (null == json || json.isEmpty) return def;
    return jsonDecode(json) ?? def;
  }

  //获取jsonList对象
  List getJsonList(String key, {List def}) {
    var json = getString(key);
    if (null == json || json.isEmpty) return def;
    return jsonDecode(json) ?? def;
  }

  //获取stringList类型数据
  List<String> getStringList(String key, {List<String> def}) {
    if (!_getValueCheck(key)) return def;
    return _sp.getStringList(key);
  }

  //获取int类型数据
  int getInt(String key, {int def}) {
    if (!_getValueCheck(key)) return def;
    return _sp.getInt(key);
  }

  //获取double类型数据
  double getDouble(String key, {double def}) {
    if (!_getValueCheck(key)) return def;
    return _sp.getDouble(key);
  }

  //获取bool类型数据
  bool getBool(String key, {bool def}) {
    if (!_getValueCheck(key)) return def;
    return _sp.getBool(key);
  }

  //存储数据
  Future<bool> set<T>(String key, T value, {Duration expiration}) async {
    if (!_setValueCheck(value)) return false;
    await _setupValueExpiration(key, expiration);
    if (value is String) {
      return await _sp.setString(key, value);
    } else if (value is int) {
      return await _sp.setInt(key, value);
    } else if (value is bool) {
      return await _sp.setBool(key, value);
    } else if (value is double) {
      return await _sp.setDouble(key, value);
    } else if (value is List<String>) {
      return await _sp.setStringList(key, value);
    }
    return false;
  }

  //存储string类型数据
  Future<bool> setString(String key, String value,
      {Duration expiration}) async {
    if (!_setValueCheck(value)) return false;
    await _setupValueExpiration(key, expiration);
    return await _sp.setString(key, value);
  }

  //存储jsonMap对象
  Future<bool> setJsonMap(String key, Map value, {Duration expiration}) async {
    return setString(key, jsonEncode(value), expiration: expiration);
  }

  //存储jsonList对象
  Future<bool> setJsonList(String key, List value,
      {Duration expiration}) async {
    return setString(key, jsonEncode(value), expiration: expiration);
  }

  //存储stringList类型数据
  Future<bool> setStringList(String key, List<String> value,
      {Duration expiration}) async {
    if (!_setValueCheck(value)) return false;
    await _setupValueExpiration(key, expiration);
    return await _sp.setStringList(key, value);
  }

  //存储int类型数据
  Future<bool> setInt(String key, int value, {Duration expiration}) async {
    if (!_setValueCheck(value)) return false;
    await _setupValueExpiration(key, expiration);
    return await _sp.setInt(key, value);
  }

  //存储double类型数据
  Future<bool> setDouble(String key, double value,
      {Duration expiration}) async {
    if (!_setValueCheck(value)) return false;
    await _setupValueExpiration(key, expiration);
    return await _sp.setDouble(key, value);
  }

  //存储bool类型数据
  Future<bool> setBool(String key, bool value, {Duration expiration}) async {
    if (!_setValueCheck(value)) return false;
    await _setupValueExpiration(key, expiration);
    return await _sp.setBool(key, value);
  }
}
