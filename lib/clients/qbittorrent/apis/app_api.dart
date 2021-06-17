import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';

/*
* 应用相关信息
* @author jtechjh
* @Time 2021/5/6 2:52 PM
*/
class APPAPI {
  final QBAPI api;

  APPAPI(this.api);

  //获取版本号
  getVersion() => api.requestGet("/app/version");

  //获取webAPI版本号
  getWebAPIVersion() => api.requestGet("/app/webapiVersion");

  //获取构建信息
  getBuildInfo() => api.requestGet("/app/buildInfo");

  //获取配置项
  getPreferences() => api.requestGet("/app/preferences");

  //获取默认存储路径
  getDefaultSavePath() => api.requestGet("/app/defaultSavePath");

  //关闭服务
  shutdown() => api.requestPost("/app/shutdown");

  //设置配置项 (json格式)
  setupPreferences(String preferences) =>
      api.requestPost("/app/setPreferences", form: {"json": preferences});
}
