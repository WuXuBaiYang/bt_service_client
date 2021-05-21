import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/pages/home/home.dart';
import 'package:bt_service_manager/pages/server/modify_aria2.dart';
import 'package:bt_service_manager/tools/route.dart';

/*
* 页面路由管理
* @author jtechjh
* @Time 2021/5/11 4:33 下午
*/
class PageManage {
  //跳转到首页
  static goHomePage() => RouteTools.pushOff(HomePage());

  //添加aria2服务器
  static goCreateAria2Service({Aria2ConfigModel config}) {
    return RouteTools.push(ModifyAria2ConfigPage(config));
  }

  //添加qBittorrent服务器
  static goCreateQBService() {}

  //添加transmission服务器
  static goCreateTMService() {}

  //跳转到应用设置页面
  static goAppSetting() {}
}
