import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
import 'package:bt_service_manager/model/response.dart';
import 'package:dio/dio.dart';

/*
* 授权相关接口
* @author jtechjh
* @Time 2021/4/29 5:40 PM
*/
class AuthAPI {
  final QBAPI _api;

  AuthAPI(this._api);

  //登录接口
  Future<ResponseModel> login(String username, String password) async {
    return _api.handleResponse(() async {
      var response = await _api.httpPost(
        "/auth/login",
        data: FormData.fromMap({
          "username": username,
          "password": password,
        }),
      );
      return response.data;
    });
  }

  //注销接口
  Future<ResponseModel> logout() async {
    return _api.handleResponse(() async {
      var response = await _api.httpPost(
        "/auth/logout",
      );
      return response.data;
    });
  }
}
