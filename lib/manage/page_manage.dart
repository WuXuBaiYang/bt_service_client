import 'package:bt_service_manager/pages/home/home.dart';
import 'package:bt_service_manager/tools/route.dart';

/*
* 页面路由管理
* @author jtechjh
* @Time 2021/5/11 4:33 下午
*/
class PageManage {
  //跳转到首页
  static goHomePage() => RouteTools.go(HomePage());

  //添加aria2服务器
  static goAddAria2Service() {}

  //添加qBittorrent服务器
  static goAddQBService() {}

  //添加transmission服务器
  static goAddTMService() {}
}
