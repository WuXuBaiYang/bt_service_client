import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';

/*
* 设置相关接口
* @author jtechjh
* @Time 2021/5/7 4:55 PM
*/
class SettingAPI {
  final Aria2API api;

  SettingAPI(this.api);

  //获取全局配置参数
  getGlobalOption() => api.rpcRequest("aria2.getGlobalOption");
}
