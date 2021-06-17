import 'package:dio/dio.dart';

/*
* 网络请求接口
* @author jtech
* @Time 2020/6/8 10:17 AM
*/
abstract class BaseAPI {
  //dio对象
  final _dio = Dio();

  BaseAPI(String baseUrl) {
    init(baseUrl);
  }

  //初始化网络请求
  init(String baseUrl) {
    //设置参数
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
    );
    //添加拦截器
    _dio.interceptors
      ..clear()
      ..add(InterceptorsWrapper(
        onRequest: (op, handle) => handle.next(op),
        onResponse: (re, handle) => handle.next(re),
        onError: (e, handle) => handle.next(e),
      ));
  }

  //添加拦截器
  void addInterceptors(List<Interceptor> interceptors) {
    if (null == interceptors || interceptors.isEmpty) return;
    _dio.interceptors.addAll(interceptors);
  }

  //移除拦截器
  void removeInterceptors(Interceptor interceptor) {
    if (null == interceptor) return;
    _dio.interceptors.remove(interceptor);
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
