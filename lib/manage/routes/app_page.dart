import 'package:bt_service_manager/manage/routes/page_manage.dart';
import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/model/server_config/qb_config_model.dart';
import 'package:bt_service_manager/model/server_config/tm_config_model.dart';
import 'package:bt_service_manager/pages/home/home.dart';
import 'package:bt_service_manager/pages/server/modify_pages/modify_aria2.dart';
import 'package:bt_service_manager/pages/server/modify_pages/modify_qb.dart';
import 'package:bt_service_manager/pages/server/modify_pages/modify_tm.dart';

/*
* 应用通用页面
* @author wuxubaiyang
* @Time 2021/6/17 下午2:28
*/
class AppPageRoute extends BasePageRoute {
  //跳转到首页
  goHomePage() => goOff(HomePage());

  //添加/编辑aria2服务器
  goModifyAria2Service({Aria2ConfigModel config}) =>
      go(ModifyAria2ConfigPage(config));

  //添加/编辑qBittorrent服务器
  goModifyQBService({QBConfigModel config}) => go(ModifyQBConfigPage(config));

  //添加/编辑transmission服务器
  goModifyTMService({TMConfigModel config}) => go(ModifyTMConfigPage(config));

  //跳转到应用设置页面
  goAppSetting() {}
}
