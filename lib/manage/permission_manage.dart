import 'package:permission_handler/permission_handler.dart';

/*
* 权限管理
* @author jtechjh
* @Time 2021/5/14 11:08 上午
*/
class PermissionManage {
  //初始化方法
  static Future<bool> required() async {
    var state = await Permission.storage.request();
    return state.isGranted;
  }
}
