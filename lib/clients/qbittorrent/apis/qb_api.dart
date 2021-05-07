import 'package:bt_service_manager/clients/qbittorrent/apis/app_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/auth_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/log_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/rss_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/search_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/sync_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/torrent_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/transfer_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/model/response.dart';
import 'package:bt_service_manager/net/base_api.dart';
import 'package:bt_service_manager/tools/tools.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

/*
* aria2总分流渠道
* @author jtechjh
* @Time 2021/5/6 11:02 AM
*/
class QBAPI extends BaseAPI {
  //授权相关接口
  AuthAPI auth;

  //应用相关接口
  APPAPI app;

  //日志相关接口
  LogAPI log;

  //同步相关接口
  SyncAPI sync;

  //传输相关接口
  TransferAPI transfer;

  //种子相关接口
  TorrentAPI torrent;

  //订阅相关接口
  RSSAPI rss;

  //搜索相关接口
  SearchAPI search;

  QBAPI(String baseUrl) : super(baseUrl) {
    //添加拦截器
    addInterceptors([_qbInterceptor]);
    //实例化接口分类
    auth = AuthAPI(this);
    app = APPAPI(this);
    log = LogAPI(this);
    sync = SyncAPI(this);
    transfer = TransferAPI(this);
    rss = RSSAPI(this);
    torrent = TorrentAPI(this);
    search = SearchAPI(this);
  }

  //qb接口请求拦截
  get _qbInterceptor => InterceptorsWrapper(
        onError: (e, handle) {
          //cookie失效则跳转到服务器信息录入页/自动登录
          if (e.response.statusCode == 403) {
            ///待实现
            handle.reject(e);
          } else {
            handle.next(e);
          }
        },
      );

  //初始化cookie管理
  Future initCookieManager() async {
    var docDir = await getApplicationDocumentsDirectory();
    var path = Tools.toMD5(baseUrl);
    var s = FileStorage("${docDir.path}/.cookies/$path/");
    var cookieJar = PersistCookieJar(storage: s);
    addInterceptors([CookieManager(cookieJar)]);
  }

  //qb接口通用post方法
  Future<QBResponseModel> requestPost(String path,
      {Map<String, dynamic> form = const {}}) async {
    return _handleResponse(() async {
      var response = await httpPost(
        path,
        data: FormData.fromMap(form),
      );
      return response.data;
    });
  }

  //qb接口通用get方法
  Future<QBResponseModel> requestGet(String path,
      {Map<String, dynamic> query = const {}}) async {
    return _handleResponse(() async {
      var response = await httpGet(
        path,
        query: query,
      );
      return response.data;
    });
  }

  //处理请求结果，异常拦截等
  Future<QBResponseModel> _handleResponse(Function fun) async {
    try {
      var result = await fun?.call();
      return QBResponseModel.success(result);
    } on DioError catch (e) {
      return QBResponseModel.failure(-1, e.message);
    } catch (e) {
      return QBResponseModel.failure(-2, "系统异常，请重试");
    }
  }
}
