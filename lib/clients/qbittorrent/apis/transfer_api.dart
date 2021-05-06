import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';

/*
* 传输相关接口
* @author jtechjh
* @Time 2021/5/6 3:23 PM
*/
class TransferAPI {
  final QBAPI _api;

  TransferAPI(this._api);

  //获取传输信息
  getTransferInfo() => _api.requestGet("/transfer/info");

  //获取速度限制模式
  getSpeedLimitsMode() => _api.requestGet("/transfer/speedLimitsMode");

  //获取下载速度限制
  getDownloadLimit() => _api.requestGet("/transfer/downloadLimit");

  //获取上载速度限制
  getUploadLimit() => _api.requestGet("/transfer/uploadLimit");

  //切换速度限制模式
  toggleSpeedLimitsMode() =>
      _api.requestPost("/transfer/toggleSpeedLimitsMode");

  //设置全局下载速度限制
  setDownloadLimit(int limit) =>
      _api.requestPost("/transfer/setDownloadLimit", form: {
        "limit": limit,
      });

  //设置全局上载速度限制
  setUploadLimit(int limit) =>
      _api.requestPost("/transfer/setUploadLimit", form: {
        "limit": limit,
      });

  //封禁peers信息
  //The peer to ban, or multiple peers separated by a pipe |.
  //Each peer is a colon-separated host:port
  banPeers(String peers) => _api.requestPost("/transfer/banPeers", form: {
        "peers": peers,
      });
}
