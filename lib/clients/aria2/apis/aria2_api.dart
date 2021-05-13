import 'dart:async';
import 'dart:convert';

import 'package:bt_service_manager/clients/aria2/apis/setting_api.dart';
import 'package:bt_service_manager/clients/aria2/model/request.dart';
import 'package:bt_service_manager/clients/aria2/model/response.dart';
import 'package:bt_service_manager/model/base_model.dart';
import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/net/base_api.dart';
import 'package:dio/dio.dart';

import 'download_api.dart';

/*
* aria2总分流渠道
* @author jtechjh
* @Time 2021/5/6 11:02 AM
*/
class Aria2API {
  //http请求方法
  BaseAPI _baseAPI;

  //配置信息对象
  Aria2ConfigModel _config;

  //下载相关接口
  DownloadAPI download;

  //设置相关接口
  SettingAPI setting;

  Aria2API(this._config) {
    //初始化http请求
    _baseAPI = BaseAPI(_config.baseUrl);
    _baseAPI.addInterceptors([_aria2Interceptor]);
    //实例化接口分类
    download = DownloadAPI(this);
    setting = SettingAPI(this);
  }

  //aria2接口请求拦截
  get _aria2Interceptor => InterceptorsWrapper(
        onError: (e, handle) {
          //cookie失效则跳转到服务器信息录入页/自动登录
          if (e.response.statusCode == 400) {
            ///待实现
            handle.reject(e);
          } else {
            handle.next(e);
          }
        },
      );

  //aria2只使用post方法
  Future<Aria2ResponseModel> rpcRequest(String method,
      {List<dynamic> paramsJson = const [],
      Map<String, dynamic> options = const {}}) async {
    return _handleResponse(() async {
      var requestData = Aria2RequestModel.build(
        method: method,
        params: [
          "token:${_config.secretToken}",
          paramsJson,
          options,
        ],
      ).toJson();
      var response;
      if (_config.method == HTTPMethod.POST) {
        response = await _baseAPI.httpPost(
          _config.path,
          data: requestData,
        );
      } else if (_config.method == HTTPMethod.GET) {
        response = await _baseAPI.httpGet(
          _config.path,
          query: requestData,
        );
      }
      return Aria2ResponseModel.fromJson(response.data);
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
