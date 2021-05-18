import 'dart:convert';

import 'package:bt_service_manager/model/settings_model.dart';
import 'package:bt_service_manager/widgets/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//异步加载设置项的值
typedef LoadSettingValues = Future<Map> Function();

/*
* aria2设置列表视图
* @author jtechjh
* @Time 2021/5/13 1:04 下午
*/
class QBSettingsView extends StatelessWidget {
  //控制器
  final SettingsViewController controller;

  //要展示的设置项组名集合
  final List<QBGroup> groups;

  //加载设置项的值
  final LoadSettingValues loadSettingValues;

  QBSettingsView({
    Key key,
    @required this.controller,
    @required this.groups,
    @required this.loadSettingValues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SettingItemModel>>(
      future: _loadQBSettings(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return SettingsView(
          controller: controller,
          settings: snap.data,
          getSettingValue: (k) => _settingValues[k],
          customItemBuilder: (item) {
            if (item.key == "scan_dirs") {
              return _buildScanDirsBuilder(item);
            }
            return null;
          },
        );
      },
    );
  }

  //构建文件路径监听选项
  _buildScanDirsBuilder(SettingItemModel item) {
    return null;
    // return CustomBuilder(
    //   initialValue: initialValue,
    //   hasEdited: (v) {
    //     return true;
    //   },
    //   onSaved: (controller, v) {
    //     controller.saveFormField(key, value);
    //   },
    // );
  }

  //缓存当前设置表
  final Map _settingValues = {};

  //缓存当前设置项集合
  final List<SettingItemModel> _settings = [];

  //加载QBitTorrent设置配置集合
  Future<List<SettingItemModel>> _loadQBSettings() async {
    //加载设置项的值
    _settingValues.addAll(await loadSettingValues());
    //加载配置项
    if (_settings.isEmpty) {
      var json = jsonDecode(await rootBundle.loadString(
          "lib/assets/config/qbittorrent_settings.json",
          cache: true));
      var groupStr = groups.map<String>((it) => it.text).join(",");
      (json ?? []).forEach((it) {
        var item = SettingGroupModel.fromJson(it);
        if (groupStr.contains(QBGroup.ALL.text) ||
            groupStr.contains(item.group)) {
          _settings.addAll(item.settings);
        }
      });
    }
    return _settings;
  }
}

/*
* QBitTorrent设置项分组
* @author jtechjh
* @Time 2021/5/13 1:35 下午
*/
enum QBGroup {
  Download,
  Connect,
  Speed,
  BitTorrent,
  RSS,
  WebUI,
  Advance,
  ALL,
}

/*
* 扩展QBitTorrent设置项分组
* @author jtechjh
* @Time 2021/5/13 1:39 下午
*/
extension QBGroupExtension on QBGroup {
  //获取枚举对应的文本
  String get text {
    switch (this) {
      case QBGroup.Download:
        return "download";
      case QBGroup.Connect:
        return "connect";
      case QBGroup.Speed:
        return "speed";
      case QBGroup.BitTorrent:
        return "bitTorrent";
      case QBGroup.RSS:
        return "rss";
      case QBGroup.WebUI:
        return "webui";
      case QBGroup.Advance:
        return "advance";
      case QBGroup.ALL:
        return "all";
    }
    return "";
  }
}
