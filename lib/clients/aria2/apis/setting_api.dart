import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';

/*
* 设置相关接口
* @author jtechjh
* @Time 2021/5/7 4:55 PM
*/
class SettingAPI {
  final Aria2API _api;

  SettingAPI(this._api);

  //获取全局配置参数
  getGlobalOption() => _api.rpcRequest("aria2.getGlobalOption");
}
