import 'package:dio/dio.dart';

/*
* 网络请求接口
* @author jtech
* @Time 2020/6/8 10:17 AM
*/
class BaseAPI {
  //dio对象
  final Dio _dio = Dio();

  //记录基础地址
  final String baseUrl;

  //主构造初始化
  BaseAPI(
    this.baseUrl, {
    List<InterceptorsWrapper> interceptors = const [],
  }) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
    );
    //添加拦截器
    _dio.interceptors
      ..add(InterceptorsWrapper(
        //请求拦截
        onRequest: (op, han) {
          ///实现请求拦截方法
          return op;
        },
        //响应拦截
        onResponse: (op, han) {
          //实现响应拦截方法
          return op;
        },
        //错误拦截
        onError: (e, han) {
          Response response = e.response;
          if (null != response) {
            ///拦截请求失败
          }
          return e;
        },
      ))
      ..addAll(interceptors);
  }

  //基础请求，需设定响应值类型
  Future<Response> request(String path,
          {data,
          Map<String, dynamic> query,
          CancelToken cancelToken,
          Options options,
          ProgressCallback onSendProgress,
          ProgressCallback onReceiveProgress}) =>
      _dio.request(path,
          data: data,
          queryParameters: query,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

  //get请求
  Future<Response> httpGet(
    String path, {
    Map<String, dynamic> query,
    Map<String, dynamic> headers,
    CancelToken cancelToken,
  }) {
    return request(path,
        query: query,
        cancelToken: cancelToken,
        options: Options(
          method: "GET",
          headers: headers ?? {},
        ));
  }

  //post请求
  Future<Response> httpPost<T>(
    String path, {
    data,
    Map<String, dynamic> query,
    Map<String, dynamic> headers,
    CancelToken cancelToken,
  }) {
    return request(path,
        data: data,
        query: query,
        cancelToken: cancelToken,
        options: Options(
          method: "POST",
          headers: headers ?? {},
        ));
  }

  //post请求
  Future<Response> httpPut<T>(
    String path, {
    data,
    Map<String, dynamic> query,
    Map<String, dynamic> headers,
    CancelToken cancelToken,
  }) {
    return request(path,
        data: data,
        query: query,
        cancelToken: cancelToken,
        options: Options(
          method: "PUT",
          headers: headers ?? {},
        ));
  }

  //post请求
  Future<Response> httpDelete<T>(
    String path, {
    data,
    Map<String, dynamic> query,
    Map<String, dynamic> headers,
    CancelToken cancelToken,
  }) {
    return request(path,
        data: data,
        query: query,
        cancelToken: cancelToken,
        options: Options(
          method: "DELETE",
          headers: headers ?? {},
        ));
  }
}
