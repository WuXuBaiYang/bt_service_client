import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
/*
* 种子相关接口
* @author jtechjh
* @Time 2021/5/6 3:31 PM
*/
class TorrentAPI {
  final QBAPI _api;

  TorrentAPI(this._api);

  //
  post() => _api.requestPost("", form: {});

  //
  get() => _api.requestGet("", query: {});
}
