import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/model/server_config/qb_config_model.dart';
import 'package:bt_service_manager/model/server_config/tm_config_model.dart';
import 'package:bt_service_manager/pages/home/home.dart';
import 'package:bt_service_manager/pages/server/modify_pages/modify_aria2.dart';
import 'package:bt_service_manager/pages/server/modify_pages/modify_qb.dart';
import 'package:bt_service_manager/pages/server/modify_pages/modify_tm.dart';
import 'package:bt_service_manager/tools/route.dart';

/*
* 页面路由管理
* @author jtechjh
* @Time 2021/5/11 4:33 下午
*/
class PageManage {
  static final _instance = PageManage._internal();

  factory PageManage() => _instance;

  PageManage._internal();

  //跳转到首页
  goHomePage() => RouteTools.pushOff(HomePage());

  //添加/编辑aria2服务器
  goModifyAria2Service({Aria2ConfigModel config}) =>
      RouteTools.push(ModifyAria2ConfigPage(config));

  //添加/编辑qBittorrent服务器
  goModifyQBService({QBConfigModel config}) =>
      RouteTools.push(ModifyQBConfigPage(config));

  //添加/编辑transmission服务器
  goModifyTMService({TMConfigModel config}) =>
      RouteTools.push(ModifyTMConfigPage(config));

  //跳转到应用设置页面
  goAppSetting() {}
}

final pageManage = PageManage();

/*
* 页面路由基类
* @author wuxubaiyang
* @Time 2021/6/17 下午1:54
*/
abstract class BasePageRoute {

}
