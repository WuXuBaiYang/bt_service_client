import 'package:bt_service_manager/clients/aria2/routes/aria2_page.dart';
import 'package:bt_service_manager/clients/qbittorrent/routes/qb_page.dart';
import 'package:bt_service_manager/clients/transmission/routes/tm_page.dart';
import 'package:bt_service_manager/manage/routes/app_page.dart';
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

  //应用内通用页面路由
  final app = AppPageRoute();

  //qBittorrent路由
  final qb = QBPageRoute();

  //aria2页面路由
  final aria2 = Aria2PageRoute();

  //transmission页面路由
  final tm = TMPageRoute();
}

final pageManage = PageManage();

/*
* 页面路由基类
* @author wuxubaiyang
* @Time 2021/6/17 下午1:54
*/
abstract class BasePageRoute {
  //页面跳转
  Future<T> go<T>(dynamic page, {dynamic arguments}) =>
      RouteTools.push(page, arguments: arguments);

  //页面跳转并退出当前页面
  Future<T> goOff<T>(dynamic page, {dynamic arguments}) =>
      RouteTools.pushOff(page, arguments: arguments);
}
