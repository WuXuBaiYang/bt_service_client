import 'dart:io';

import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
import 'package:dio/dio.dart';

/*
* 种子相关接口
* @author jtechjh
* @Time 2021/5/6 3:31 PM
*/
class TorrentAPI {
  final QBAPI api;

  TorrentAPI(this.api);

  //暂停任务
  pause(List<String> hashes) => api.requestPost("/torrents/pause", form: {
        "hashes": hashes.join("|"),
      });

  //恢复任务
  resume(List<String> hashes) => api.requestPost("/torrents/resume", form: {
        "hashes": hashes.join("|"),
      });

  //删除任务
  delete(List<String> hashes, bool deleteFiles) =>
      api.requestPost("/torrents/delete", form: {
        "hashes": hashes.join("|"),
        "deleteFiles": deleteFiles,
      });

  //重查任务
  recheck(List<String> hashes) => api.requestPost("/torrents/recheck", form: {
        "hashes": hashes.join("|"),
      });

  //放弃种子
  reannounce(List<String> hashes) => api.requestPost("/torrents/reannounce", form: {
        "hashes": hashes.join("|"),
      });

  //添加种子
  //tags：,号分割
  add({
    List<String> urls = const [],
    List<File> files = const [],
    String savePath,
    String cookie,
    String category,
    List<String> tags,
    bool skipChecking = false,
    bool paused = false,
    bool rootFolder,
    String rename,
    int upLimit,
    int dlLimit,
    double ratioLimit,
    int seedingTimeLimit,
    bool autoTMM,
    bool sequentialDownload = false,
    bool firstLastPiecePrio = false,
  }) async {
    List<MultipartFile> torrents = [];
    for (var it in files) {
      var path = it.path;
      var name = path.substring(path.lastIndexOf("/"), path.length);
      torrents.add(await MultipartFile.fromFile(it.path, filename: name));
    }
    return api.requestPost("/torrents/add", form: {
      "urls": urls.join(r"\n"),
      "torrents": torrents,
      "savepath": savePath,
      "cookie": cookie,
      "category": category,
      "tags": tags.join(","),
      "skip_checking": skipChecking,
      "paused": paused,
      "root_folder": rootFolder,
      "rename": rename,
      "upLimit": upLimit,
      "dlLimit": dlLimit,
      "ratioLimit": ratioLimit,
      "seedingTimeLimit": seedingTimeLimit,
      "autoTMM": autoTMM,
      "sequentialDownload": sequentialDownload,
      "firstLastPiecePrio": firstLastPiecePrio,
    });
  }

  //添加tracker服务器
  //This adds two trackers to torrent with hash 8c212779b4abde7c6bc608063a0d008b7e40ce32.
  //Note %0A (aka LF newline) between trackers.
  //Ampersand in tracker urls MUST be escaped.
  addTrackers(String hash, List<String> urls) =>
      api.requestPost("/torrents/addTrackers", form: {
        "hash": hash,
        "urls": urls.join(r"\n"),
      });

  //编辑tracker服务器
  editTracker(String hash, String origUrl, String newUrl) =>
      api.requestPost("/torrents/editTracker", form: {
        "hash": hash,
        "origUrl": origUrl,
        "newUrl": newUrl,
      });

  //移除tracker服务器
  removeTrackers(String hash, List<String> urls) =>
      api.requestPost("/torrents/removeTrackers", form: {
        "hash": hash,
        "urls": urls.join("|"),
      });

  //添加peers
  addPeers(List<String> hashes, String peers) =>
      api.requestPost("/torrents/addPeers", form: {
        "hashes": hashes.join("|"),
        "peers": peers,
      });

  //提高优先级
  increasePrio(List<String> hashes) =>
      api.requestPost("/torrents/increasePrio", form: {
        "hashes": hashes.join("|"),
      });

  //降低优先级
  decreasePrio(List<String> hashes) =>
      api.requestPost("/torrents/decreasePrio", form: {
        "hashes": hashes.join("|"),
      });

  //最大化优先级
  topPrio(List<String> hashes) => api.requestPost("/torrents/topPrio", form: {
        "hashes": hashes.join("|"),
      });

  //最小化优先级
  bottomPrio(List<String> hashes) => api.requestPost("/torrents/bottomPrio", form: {
        "hashes": hashes.join("|"),
      });

  //设置文件优先级
  //id：｜分割
  post(String hash, List<String> ids, int priority) =>
      api.requestPost("/torrents/filePrio", form: {
        "hash": hash,
        "id": ids,
        "priority": priority,
      });

  //设置下载速度限制
  setDownloadLimit(List<String> hashes, int limit) =>
      api.requestPost("/torrents/setDownloadLimit", form: {
        "hashes": hashes.join("|"),
        "limit": limit,
      });

  //设置分享率限制
  setShareLimits(List<String> hashes, double seedingTimeLimit) =>
      api.requestPost("/torrents/setShareLimits", form: {
        "hashes": hashes.join("|"),
        "seedingTimeLimit": seedingTimeLimit,
      });

  //设置上载速度限制
  setUploadLimit(List<String> hashes, int limit) =>
      api.requestPost("/torrents/setUploadLimit", form: {
        "hashes": hashes.join("|"),
        "limit": limit,
      });

  //设置位置
  setLocation(List<String> hashes) =>
      api.requestPost("/torrents/setLocation", form: {
        "hashes": hashes.join("|"),
      });

  //重命名
  rename(String hash, String name) =>
      api.requestPost("/torrents/rename", form: {
        "hash": hash,
        "name": name,
      });

  //设置分类
  setCategory(List<String> hashes, String category) =>
      api.requestPost("/torrents/setCategory", form: {
        "hashes": hashes.join("|"),
        "category": category,
      });

  //创建分类
  createCategory(String category, String savePath) =>
      api.requestPost("/torrents/createCategory", form: {
        "category": category,
        "savePath": savePath,
      });

  //编辑分类
  editCategory(String category, String savePath) =>
      api.requestPost("/torrents/editCategory", form: {
        "category": category,
        "savePath": savePath,
      });

  //移除分类
  //categories：\n分割
  removeCategories(List<String> categories) =>
      api.requestPost("/torrents/removeCategories", form: {
        "categories": categories.join(r"\n"),
      });

  //添加标签
  //tags：,分割
  addTags(List<String> hashes, List<String> tags) =>
      api.requestPost("/torrents/addTags", form: {
        "hashes": hashes.join("|"),
        "tags": tags.join(","),
      });

  //移除标签
  removeTags(List<String> hashes, List<String> tags) =>
      api.requestPost("/torrents/removeTags", form: {
        "hashes": hashes.join("|"),
        "tags": tags.join(","),
      });

  //创建标签
  createTags(List<String> tags) => api.requestPost("/torrents/createTags", form: {
        "tags": tags.join(","),
      });

  //删除标签
  deleteTags(List<String> tags) => api.requestPost("/torrents/deleteTags", form: {
        "tags": tags.join(","),
      });

  //设置自动管理
  setAutoManagement(List<String> hashes, bool enable) =>
      api.requestPost("/torrents/setAutoManagement", form: {
        "hashes": hashes.join("|"),
        "enable": enable,
      });

  //切换顺序下载
  toggleSequentialDownload(List<String> hashes) =>
      api.requestPost("/torrents/toggleSequentialDownload", form: {
        "hashes": hashes.join("|"),
      });

  //切换头尾随便优先级
  toggleFirstLastPiecePrio(List<String> hashes) =>
      api.requestPost("/torrents/toggleFirstLastPiecePrio", form: {
        "hashes": hashes.join("|"),
      });

  //设置强制启动
  setForceStart(List<String> hashes, bool enable) =>
      api.requestPost("/torrents/setForceStart", form: {
        "hashes": hashes.join("|"),
        "value": enable,
      });

  //设置超级做种模式
  setSuperSeeding(List<String> hashes, bool enable) =>
      api.requestPost("/torrents/setSuperSeeding", form: {
        "hashes": hashes.join("|"),
        "value": enable,
      });

  //文件重命名
  renameFile(String hash, String oldPath, String newPath) =>
      api.requestPost("/torrents/renameFile", form: {
        "hash": hash,
        "oldPath": oldPath,
        "newPath": newPath,
      });

  //文件夹重命名
  renameFolder(String hash, String oldPath, String newPath) =>
      api.requestPost("/torrents/renameFolder", form: {
        "hash": hash,
        "oldPath": oldPath,
        "newPath": newPath,
      });

  //获取种子列表
  //Filter torrent list by state.
  //Allowed state filters: all, downloading, completed, paused, active, inactive, resumed, stalled, stalled_uploading, stalled_downloading

  //Get torrents with the given category (empty string means "without category";
  //no "category" parameter means "any category" <- broken until #11748 is resolved).
  //Remember to URL-encode the category name. For example, My category becomes My%20category

  //Sort torrents by given key.
  //They can be sorted using any field of the response's JSON array (which are documented below) as the sort key.

  //Filter by hashes. Can contain multiple hashes separated by |
  getInfoList({
    String filter = "all",
    String category = "",
    String sort = "",
    bool reverse = false,
    int limit = 0,
    int offset = 0,
    List<String> hashes,
  }) =>
      api.requestGet("/torrents/info", query: {
        "filter": filter,
        "category": category,
        "sort": sort,
        "reverse": reverse,
        "limit": limit,
        "offset": offset,
        "hashes": hashes.join("|"),
      });

  //获取属性信息
  getProperties(String hash) => api.requestGet("/torrents/properties", query: {
        "hash": hash,
      });

  //获取trackers信息
  getTrackers(String hash) => api.requestGet("/torrents/trackers", query: {
        "hash": hash,
      });

  //获取网络种子信息
  getWebSeeds(String hash) => api.requestGet("/torrents/webseeds", query: {
        "hash": hash,
      });

  //获取文件信息
  getFiles(String hash) => api.requestGet("/torrents/files", query: {
        "hash": hash,
      });

  //获取碎片信息
  getPieceStates(String hash) =>
      api.requestGet("/torrents/pieceStates", query: {
        "hash": hash,
      });

  //获取碎片hashes信息
  getPieceHashes(String hash) =>
      api.requestGet("/torrents/pieceHashes", query: {
        "hash": hash,
      });

  //获取下载速度限制
  getDownloadLimit(List<String> hashes) =>
      api.requestGet("/torrents/downloadLimit", query: {
        "hashes": hashes.join("|"),
      });

  //获取上载速度限制
  getUploadLimit(List<String> hashes) =>
      api.requestGet("/torrents/uploadLimit", query: {
        "hashes": hashes.join("|"),
      });

  //获取全部分类
  getCategories() => api.requestGet("/torrents/categories");

  //获取全部标签
  getTags() => api.requestGet("/torrents/tags");
}
