import 'package:bt_service_manager/clients/qbittorrent/apis/auth_api.dart';
import 'package:bt_service_manager/net/base_api.dart';
import 'package:bt_service_manager/tools/tools.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

/*
* aria2总分流渠道
* @author jtechjh
* @Time 2021/5/6 11:02 AM
*/
class QBAPI extends BaseAPI {
  //授权相关接口
  AuthAPI auth;

  QBAPI(String baseUrl) : super(baseUrl) {
    //初始化cookie管理
    _initCookieManager();
    //添加拦截器
    addInterceptors([_qbInterceptor]);
    //实例化接口分类
    auth = AuthAPI(this);
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
  _initCookieManager() async {
    var docDir = await getApplicationDocumentsDirectory();
    var path = Tools.toMD5(baseUrl);
    var s = FileStorage("${docDir.path}/.cookies/$path/");
    var cookieJar = PersistCookieJar(storage: s);
    addInterceptors([CookieManager(cookieJar)]);
  }
}
