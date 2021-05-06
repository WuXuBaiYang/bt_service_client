import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';

/*
* 同步数据接口
* @author jtechjh
* @Time 2021/5/6 3:15 PM
*/
class SyncAPI {
  final QBAPI _api;

  SyncAPI(this._api);

  //获取主要数据
  //Response ID. If not provided, rid=0 will be assumed.
  //If the given rid is different from the one of last server reply,
  //full_update will be true (see the server reply details for more info)
  getMainData({int rid = 0}) => _api.requestGet("/sync/maindata", query: {
        "rid": rid,
      });

  //获取种子peers信息
  getTorrentPeers(String hash, {int rid = 0}) =>
      _api.requestGet("/sync/torrentPeers", query: {
        "hash": hash,
        "rid": rid,
      });
}
