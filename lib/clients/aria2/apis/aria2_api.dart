import 'dart:async';
import 'dart:convert';

import 'package:bt_service_manager/clients/aria2/apis/setting_api.dart';
import 'package:bt_service_manager/clients/aria2/model/request.dart';
import 'package:bt_service_manager/clients/aria2/model/response.dart';
import 'package:bt_service_manager/net/base_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'download_api.dart';

/*
* aria2总分流渠道
* @author jtechjh
* @Time 2021/5/6 11:02 AM
*/
class Aria2API {
  //http请求方法
  BaseAPI _http;

  //json-rpc请求地址
  final String _url;

  //json-rpc请求方法
  final String _method;

  //json-rpc授权信息
  final String _secretToken;

  //记录当前请求状态，是否为http请求
  RequestType type;

  //下载相关接口
  DownloadAPI download;

  //设置相关接口
  SettingAPI setting;

  Aria2API(this._url, this._method, this._secretToken) {
    //判断请求类型
    type = _handleRequestType(_url);
    if (type == RequestType.HTTP) {
      //初始化http请求
      _http = BaseAPI(_url);
      //添加拦截器
      _http.addInterceptors([_aria2Interceptor]);
    } else {
      ///待完成
    }
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
          "token:$_secretToken",
          paramsJson,
          options,
        ],
      ).toJson();
      if (type == RequestType.HTTP) {
        var response;
        if (_method == "POST") {
          response = await _http.httpPost("", data: requestData);
        } else if (_method == "GET") {
          response = await _http.httpGet("", query: requestData);
        }
        return response.data;
      } else if (type == RequestType.WS) {
        ///待完成
        return;
      }
      return;
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

  //处理请求类型
  RequestType _handleRequestType(String url) {
    if (url.startsWith(RegExp("http://|https://"))) {
      return RequestType.HTTP;
    } else if (url.startsWith(RegExp("ws://|wss://"))) {
      return RequestType.WS;
    }
    return RequestType.NONE;
  }
}

/*
* 请求类型
* @author jtechjh
* @Time 2021/5/7 11:05 AM
*/
enum RequestType {
  //http请求（post）
  HTTP,
  //webSocket请求
  WS,
  //未知类型
  NONE,
}
