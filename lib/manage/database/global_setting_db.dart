import 'package:bt_service_manager/model/global_settings_model.dart';
import 'package:hive/hive.dart';

import 'database_manage.dart';

/*
* 全局设置数据库管理
* @author wuxubaiyang
* @Time 2021/6/11 上午10:28
*/
class GlobalSettingDatabase extends BaseDatabase {
  //全局设置项
  final String _globalSetting = "global_setting_box";

  @override
  Future<void> initDB() async {}
}
