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
  final globalSetting = GlobalSettingCache();

  //初始化
  Future<void> init() async {
    //初始化子缓存
    await globalSetting.initCache();

    SharedPreferences.getInstance();
  }
}

final cacheManage = CacheManage();

/*
* 缓存管理基类
* @author wuxubaiyang
* @Time 2021/6/11 上午11:19
*/
abstract class BaseCache {
  //初始化方法
  Future<void> initCache();
}
