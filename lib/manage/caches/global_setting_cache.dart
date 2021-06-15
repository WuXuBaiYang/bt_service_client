import 'dart:convert';

import 'package:bt_service_manager/manage/caches/cache_manager.dart';
import 'package:bt_service_manager/model/global_settings_model.dart';
import 'package:flutter/services.dart';

/*
* 全局设置缓存
* @author wuxubaiyang
* @Time 2021/6/11 上午11:18
*/
class GlobalSettingCache extends BaseCache {
  //全局设置缓存key
  final globalSettingsKey = "globalSettingsKey";

  //记录全局设置缓存
  GlobalSettingsModel globalSettings;

  @override
  Future<void> initCache() async {
    await super.initCache();
    var json = getJsonMap(globalSettingsKey);
    if (null == json) {
      json = jsonDecode(await rootBundle
          .loadString("lib/assets/config/global_settings.json", cache: true));
    }
    globalSettings = GlobalSettingsModel.fromJson(json);
  }

  //更新或存储全局设置
  Future<bool> updateGlobalSetting(GlobalSettingsModel model) async {
    var flag = false;
    if (!await setJsonMap(globalSettingsKey, model.toJson())) {
      this.globalSettings = model;
      flag = true;
    }
    return flag;
  }
}
