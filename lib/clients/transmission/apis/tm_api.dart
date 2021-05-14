import 'dart:async';
import 'dart:convert';

import 'package:bt_service_manager/clients/transmission/model/request.dart';
import 'package:bt_service_manager/clients/transmission/model/response.dart';
import 'package:bt_service_manager/manage/database/database_manage.dart';
import 'package:bt_service_manager/model/base_model.dart';
import 'package:bt_service_manager/model/server_config/tm_config_model.dart';
import 'package:bt_service_manager/net/base_api.dart';
import 'package:dio/dio.dart';

/*
* transmission服务器接口
* @author jtechjh
* @Time 2021/5/14 2:54 下午
*/
class TMAPI {
  //http请求方法
  BaseAPI _baseAPI;

  //配置信息对象
  TMConfigModel _config;

  TMAPI(this._config) {
    //监听配置变化
    _watchOnConfig();
    //初始化接口配置等
    _initAPI();
  }

  //初始化方法
  _initAPI() {
    //初始化http请求
    _baseAPI = BaseAPI(_config.baseUrl);
    _baseAPI.addInterceptors([_tmInterceptor]);
    //实例化接口分类
  }

  //监听配置变化
  _watchOnConfig() async {
    (await dbManage.server.watchOn(_config.id)).listen((event) {
      //重新初始化接口
      _initAPI();
    });
  }

  //transmission接口请求拦截
  get _tmInterceptor => InterceptorsWrapper(
        onError: (e, handle) {},
      );

  //rpc请求
  Future<TMResponseModel> rpcRequest(String method,
      {dynamic params, Map<String, dynamic> options = const {}}) async {
    return _handleResponse(() async {
      var requestData = TMRequestModel.build(
        method: method,
        arguments: params,
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
