import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/*
* 路由工具类
* @author jtechjh
* @Time 2021/5/11 4:26 下午
*/
class RouteTools {
  //进入页面
  static Future<T> go<T>(Widget page, {dynamic arguments}) => Get.to<T>(
        () => page,
        arguments: arguments,
      );

  //退出页面/弹窗等
  static pop<T>([result]) => Get.back<T>(result: result);
}
