import 'package:bt_service_manager/net/base_api.dart';

/*
* 授权相关接口
* @author jtechjh
* @Time 2021/4/29 5:40 PM
*/
class AuthAPI extends BaseAPI {
  AuthAPI(String baseUrl) : super(baseUrl);

  //登录接口
  Future<bool> login(String username, String password) async {
    var response = await httpPost(
      "$baseUrl/auth/login",
    );
    return response.statusCode == 200;
  }
}
