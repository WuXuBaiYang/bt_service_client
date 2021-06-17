import 'package:bt_service_manager/clients/qbittorrent/apis/app_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/auth_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/log_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/rss_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/search_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/sync_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/torrent_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/transfer_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/model/response.dart';
import 'package:bt_service_manager/manage/routes/page_manage.dart';
import 'package:bt_service_manager/model/client_info_model.dart';
import 'package:bt_service_manager/model/server_config/qb_config_model.dart';
import 'package:bt_service_manager/net/client_api.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

/*
* aria2总分流渠道
* @author jtechjh
* @Time 2021/5/6 11:02 AM
*/
class QBAPI extends BaseClientAPI<QBConfigModel> {
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

  QBAPI(QBConfigModel config) : super(config);

  //初始化接口
  @override
  initAPI() {
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

  @override
  Future<ClientInfoModel> loadClientInfo() {}

  @override
  List<Interceptor> get interceptors => [_qbInterceptor];

  //qb接口请求拦截
  get _qbInterceptor => InterceptorsWrapper(
        onError: (e, handle) {
          //cookie失效则跳转到服务器信息录入页/自动登录
          if (e.response.statusCode == 403) {
            //拒绝请求并跳转qb登录页面
            cookieManager.cookieJar.deleteAll();
            pageManage.qb.goLogin(config);
            return handle.reject(e);
          }
          return handle.next(e);
        },
      );

  //维护cookie管理
  CookieManager cookieManager;

  //判断是否存在cookie
  bool get hasCookie {
    PersistCookieJar cookieJar = cookieManager.cookieJar;
    return cookieJar.hostCookies.isNotEmpty ||
        cookieJar.domainCookies.isNotEmpty;
  }

  //初始化cookie管理
  Future initCookieManager() async {
    if (null == cookieManager) {
      var docDir = await getApplicationDocumentsDirectory();
      var cookieJar = PersistCookieJar(
          storage: FileStorage("${docDir.path}/.cookies/${config.id}/"));
      cookieManager = CookieManager(cookieJar);
      addInterceptors([cookieManager]);
    }
  }

  //qb接口通用post方法
  Future<QBResponseModel> requestPost(String path,
      {Map<String, dynamic> form = const {}}) async {
    await initCookieManager();
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
    await initCookieManager();
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
