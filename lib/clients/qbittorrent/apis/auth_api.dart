import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';

/*
* 授权相关接口
* @author jtechjh
* @Time 2021/4/29 5:40 PM
*/
class AuthAPI {
  final QBAPI _api;

  AuthAPI(this._api);

  //登录接口
  login(String username, String password) =>
      _api.requestPost("/auth/login", form: {
        "username": username,
        "password": password,
      });

  //注销接口
  logout() => _api.requestPost("/auth/logout");
}
