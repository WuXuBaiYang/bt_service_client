import 'package:bt_service_manager/manage/caches/cache_manager.dart';
import 'package:bt_service_manager/manage/database/database_manage.dart';
import 'package:bt_service_manager/model/global_settings_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* 服务器状态/列表控制器
* @author jtechjh
* @Time 2021/5/18 4:08 下午
*/
class ServerController extends GetxController {
  ServerController() {
    //加载服务器列表
    loadServerList();
  }

  //全局下载速度
  var totalDownloadSpeed = 0.0.obs;

  //全局上传速度
  var totalUploadSpeed = 0.0;

  //更新汇总信息
  void updateTotalInfo(num downSpeed, num upSpeed) {
    this.totalDownloadSpeed.value = downSpeed;
    this.totalUploadSpeed = upSpeed;
  }

  //记录服务器列表
  final servers = [].obs;

  //加载服务器列表
  Future<List> loadServerList() async {
    return servers
      ..clear()
      ..addAll(await dbManage.server.loadAllServerConfig())
      ..sort((l, r) => l.orderNum.compareTo(r.orderNum));
  }

  //删除服务器
  Future<void> removeServer(ServerConfigModel config) async {
    await dbManage.server.removeServerConfig(config.id);
    servers.remove(config);
  }

  //恢复服务器
  Future<void> resumeServer(int index, ServerConfigModel config) async {
    await dbManage.server.addServerConfig(config);
    servers.insert(index, config);
  }

  //交换两个配置的位置
  void switchConfig(int oldIndex, int newIndex) async {
    var item = servers.removeAt(oldIndex);
    servers.insert(newIndex, item);
    //重新排序并存储
    int index = 0;
    servers.forEach((config) {
      config.orderNum = index++;
      config.save();
    });
  }

  //缓存全局设置对象
  GlobalSettingsModel _globalSettings;

  //获取全局设置对象
  GlobalSettingsModel get globalSettings {
    if (null == _globalSettings) {
      _globalSettings = cacheManage.globalSettingCache.globalSettings;
    }
    return _globalSettings;
  }

  //遍历速度区间并返回符合区间的颜色
  Color _handleSpeedColor(
    List<SpeedLevelItem> levels, {
    num speed,
    Color def = Colors.transparent,
  }) {
    for (var item in levels) {
      if (speed >= item.speed) {
        return item.color;
      }
    }
    return def;
  }

  //获取全局下行速度对应颜色
  Color get globalDownSpeedColor =>
      _handleSpeedColor(globalSettings.globalDownSpeedLevel,
          speed: totalDownloadSpeed.value);

  //获取全局上行速度对应颜色
  Color get globalUpSpeedColor =>
      _handleSpeedColor(globalSettings.globalUpSpeedLevel,
          speed: totalUploadSpeed);

  //获取下行速度对应颜色
  Color getDownSpeedColor(num speed) =>
      _handleSpeedColor(globalSettings.downSpeedLevel, speed: speed);

  //获取上行速度对应颜色
  Color getUpSpeedColor(num speed) =>
      _handleSpeedColor(globalSettings.upSpeedLevel, speed: speed);

  //获取服务器链接状态对应的颜色
  ServerStateItem getServerStateModel(ServerState state) =>
      globalSettings.serverStates[state];
}
