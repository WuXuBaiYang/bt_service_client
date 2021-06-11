import 'package:bt_service_manager/manage/caches/cache_manager.dart';
import 'package:bt_service_manager/model/global_settings_model.dart';

/*
* 全局设置缓存
* @author wuxubaiyang
* @Time 2021/6/11 上午11:18
*/
class GlobalSettingCache extends BaseCache {
  //记录全局设置缓存
  GlobalSettingsModel globalSettings;

  @override
  Future<void> initCache() async {}

  //获取全局配置
  GlobalSettingsModel getGlobalSetting() {
    if (null == globalSettings) {
    }
    return globalSettings;
  }
}
