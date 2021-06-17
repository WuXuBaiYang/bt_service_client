import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';

/*
* 搜索相关接口
* @author jtechjh
* @Time 2021/5/6 3:32 PM
*/
class SearchAPI {
  final QBAPI api;

  SearchAPI(this.api);

  //启动一个搜索任务
  //Plugins to use for searching (e.g. "legittorrents").
  //Supports multiple plugins separated by |.
  //Also supports all and enabled

  // Categories to limit your search to (e.g. "legittorrents").
  // Available categories depend on the specified plugins.
  // Also supports all
  startSearch(
    String pattern, {
    String plugins,
    String category,
  }) =>
      api.requestPost("/search/start", form: {
        "pattern": pattern,
        "plugins": plugins,
        "category": category,
      });

  //停止搜索
  stopSearch(String id) => api.requestPost("/search/stop", form: {
        "id": id,
      });

  //删除搜索
  deleteSearch(String id) => api.requestPost("/search/delete", form: {
        "id": id,
      });

  //安装插件
  //Url or file path of the plugin to install (e.g. "https://raw.githubusercontent.com/qbittorrent/search-plugins/master/nova3/engines/legittorrents.py").
  //Supports multiple sources separated by |
  installPlugin(String sources) =>
      api.requestPost("/search/installPlugin", form: {
        "sources": sources,
      });

  //卸载插件
  //Name of the plugin to uninstall (e.g. "legittorrents").
  //Supports multiple names separated by |
  uninstallPlugin(String names) =>
      api.requestPost("/search/uninstallPlugin", form: {
        "names": names,
      });

  //设置插件启动状态
  //Name of the plugin to enable/disable (e.g. "legittorrents").
  //Supports multiple names separated by |
  setPluginEnable(String names, bool enable) =>
      api.requestPost("/search/enablePlugin", form: {
        "names": names,
        "enable": enable,
      });

  //更新插件
  updatePlugins() => api.requestPost("/search/updatePlugins");

  //获取搜索状态
  getSearchStatus(String id) => api.requestGet("/search/status", query: {
        "id": id,
      });

  //获取搜索结果
  //max number of results to return.
  //0 or negative means no limit

  //result to start at.
  //A negative number means count backwards (e.g. -2 returns the 2 most recent results)
  getSearchResults(String id, {int limit = 0, int offset = 0}) =>
      api.requestGet("/search/results", query: {
        "id": id,
        "limit": limit,
        "offset": offset,
      });

  //获取插件
  getPlugins() => api.requestGet("/search/plugins");
}
