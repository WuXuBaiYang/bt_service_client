import 'dart:async';
import 'dart:convert';

import 'package:bt_service_manager/clients/aria2/apis/setting_api.dart';
import 'package:bt_service_manager/clients/aria2/model/request.dart';
import 'package:bt_service_manager/clients/aria2/model/response.dart';
import 'package:bt_service_manager/model/client_info_model.dart';
import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/net/client_api.dart';
import 'package:dio/dio.dart';

import 'download_api.dart';

/*
* aria2总分流渠道
* @author jtechjh
* @Time 2021/5/6 11:02 AM
*/
class Aria2API extends BaseClientAPI<Aria2ConfigModel> {
  //下载相关接口
  DownloadAPI download;

  //设置相关接口
  SettingAPI setting;

  Aria2API(Aria2ConfigModel config) : super(config);

  @override
  initAPI() {
    //初始化接口对象
    download = DownloadAPI(this);
    setting = SettingAPI(this);
  }

  @override
  Future<ClientInfoModel> loadClientInfo() {
    ///
  }

  @override
  List<Interceptor> get interceptors => [];

  //rpc请求
  Future<Aria2ResponseModel> rpcRequest(String method,
      {dynamic params, Map<String, dynamic> options = const {}}) async {
    return _handleResponse(() async {
      var requestData = Aria2RequestModel.build(
        method: method,
        params: [
          "token:${config.secretToken}",
          params,
          options,
        ],
      ).toJson();
      var response;
      if (config.method == HTTPMethod.POST) {
        response = await httpPost(
          "/${config.path}",
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
  Future<Aria2ResponseModel> _handleResponse(Function fun) async {
    try {
      var result = await fun?.call();
      if (result is String) {
        result = jsonDecode(result);
      }
      return Aria2ResponseModel.fromJson(result);
    } on DioError catch (e) {
      if (null != e.response.data) {
        return Aria2ResponseModel.fromJson(e.response.data);
      }
      return Aria2ResponseModel.failure(-1, e.toString());
    } catch (e) {
      return Aria2ResponseModel.failure(-2, "系统异常，请重试");
    }
  }
}
