import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';

/*
* 下载相关接口
* @author jtechjh
* @Time 2021/5/7 4:55 PM
*/
class DownloadAPI {
  final Aria2API api;

  DownloadAPI(this.api);

  //添加下载地址
  addUri(List<String> uris, {Map<String, dynamic> options}) =>
      api.rpcRequest("aria2.addUri", params: uris, options: options);
}
