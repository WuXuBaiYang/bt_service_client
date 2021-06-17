import 'dart:async';
import 'dart:convert';

import 'package:bt_service_manager/clients/transmission/model/request.dart';
import 'package:bt_service_manager/clients/transmission/model/response.dart';
import 'package:bt_service_manager/model/client_info_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/model/server_config/tm_config_model.dart';
import 'package:bt_service_manager/net/client_api.dart';
import 'package:dio/dio.dart';

/*
* transmission服务器接口
* @author jtechjh
* @Time 2021/5/14 2:54 下午
*/
class TMAPI extends BaseClientAPI<TMConfigModel> {
  TMAPI(TMConfigModel config) : super(config);

  @override
  initAPI() {
    //实例化接口分类
  }

  @override
  Future<ClientInfoModel> loadClientInfo() {}

  @override
  List<Interceptor> get interceptors => [];

  //rpc请求
  Future<TMResponseModel> rpcRequest(String method,
      {dynamic params, Map<String, dynamic> options = const {}}) async {
    return _handleResponse(() async {
      var requestData = TMRequestModel.build(
        method: method,
        arguments: params,
      ).toJson();
      var response;
      if (config.method == HTTPMethod.POST) {
        response = await httpPost(
          config.path,
          data: requestData,
        );
      } else if (config.method == HTTPMethod.GET) {
        response = await httpGet(
          config.path,
          query: requestData,
        );
      }
      return response.data;
    });
  }

  //处理请求结果，异常拦截等
  Future<TMResponseModel> _handleResponse(Function fun) async {
    try {
      var result = await fun?.call();
      if (result is String) {
        result = jsonDecode(result);
      }
      return TMResponseModel.fromJson(result);
    } on DioError catch (e) {
      if (null != e.response.data) {
        return TMResponseModel.fromJson(e.response.data);
      }
      return TMResponseModel.failure(e.toString());
    } catch (e) {
      return TMResponseModel.failure("系统异常，请重试");
    }
  }
}
