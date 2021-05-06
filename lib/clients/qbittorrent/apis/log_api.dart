import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';

/*
* 日志相关接口
* @author jtechjh
* @Time 2021/5/6 3:09 PM
*/
class LogAPI {
  final QBAPI _api;

  LogAPI(this._api);

  //获取主日志
  getMainLog({
    bool info = true,
    bool warning = true,
    bool critical = true,
    int lastKnownId = -1,
  }) =>
      _api.requestGet("/log/main", query: {
        "info": info,
        "warning": warning,
        "critical": critical,
        "last_known_id": lastKnownId,
      });

  //获取peers日志
  getPeersLog({
    int lastKnownId = -1,
  }) =>
      _api.requestGet("/log/peers", query: {
        "last_known_id": lastKnownId,
      });
}
