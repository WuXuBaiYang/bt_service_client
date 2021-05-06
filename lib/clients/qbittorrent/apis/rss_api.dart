import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';

/*
* 订阅相关接口
* @author jtechjh
* @Time 2021/5/6 3:30 PM
*/
class RSSAPI {
  final QBAPI _api;

  RSSAPI(this._api);

  //添加目录
  addFolder(String path) => _api.requestPost("/rss/addFolder", form: {
        "path": path,
      });

  //添加feed
  addFeed(String path, String url) => _api.requestPost("/rss/addFeed", form: {
        "url": url,
        "path": path,
      });

  //移除项目
  removeItem(String path) => _api.requestPost("/rss/removeItem", form: {
        "path": path,
      });

  //移动项目
  moveItem(String itemPath, String destPath) =>
      _api.requestPost("/rss/moveItem", form: {
        "itemPath": itemPath,
        "destPath": destPath,
      });

  //标记已读
  markAsRead(
    String itemPath, {
    String articleId = "",
  }) =>
      _api.requestPost("/rss/markAsRead", form: {
        "itemPath": itemPath,
        "articleId": articleId,
      });

  //刷新项目
  refreshItem(String itemPath) => _api.requestPost("/rss/refreshItem", form: {
        "itemPath": itemPath,
      });

  //添加/修改自动下载规则
  //规则字段参考 https://github.com/qbittorrent/qBittorrent/wiki/WebUI-API-(qBittorrent-4.1)#set-auto-downloading-rule
  setRule(String ruleName, String ruleDef) =>
      _api.requestPost("/rss/setRule", form: {
        "ruleName": ruleName,
        "ruleDef": ruleDef,
      });

  //重命名规则
  renameRule(String ruleName, String newRuleName) =>
      _api.requestPost("/rss/renameRule", form: {
        "ruleName": ruleName,
        "newRuleName": newRuleName,
      });

  //移除自动下载规则
  removeRule(String ruleName) => _api.requestPost("/rss/removeRule", form: {
        "ruleName": ruleName,
      });

  //获取全部项目
  getItems({bool withData = false}) => _api.requestGet("/rss/items", query: {
        "withData": withData,
      });

  //获取自动下载规则列表
  getRules() => _api.requestGet("/rss/rules");

  //获取规则匹配的内容集合
  getMatchingArticles(String ruleName) =>
      _api.requestGet("/rss/matchingArticles", query: {
        "ruleName": ruleName,
      });
}
