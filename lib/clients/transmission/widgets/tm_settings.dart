import 'dart:convert';

import 'package:bt_service_manager/clients/aria2/widgets/aria2_settings.dart';
import 'package:bt_service_manager/model/settings_model.dart';
import 'package:bt_service_manager/widgets/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//异步加载设置项的值
typedef LoadSettingValues = Future<Map> Function();

/*
* transmission设置列表视图
* @author jtechjh
* @Time 2021/5/13 1:04 下午
*/
class TMSettingsView extends StatelessWidget {
  //控制器
  final SettingsViewController controller;

  //要展示的设置项组名集合
  final List<TMGroup> groups;

  //加载设置项的值
  final LoadSettingValues loadSettingValues;

  TMSettingsView({
    Key key,
    @required this.controller,
    @required this.groups,
    @required this.loadSettingValues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SettingItemModel>>(
      future: _loadAria2Settings(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return SettingsView(
          controller: controller,
          settings: snap.data,
          getSettingValue: (k) {
            return _settingValues[k];
          },
        );
      },
    );
  }

  //缓存当前设置表
  final Map _settingValues = {};

  //缓存当前设置项集合
  final List<SettingItemModel> _settings = [];

  //加载aria2设置配置集合
  Future<List<SettingItemModel>> _loadAria2Settings() async {
    //加载设置项的值
    _settingValues.addAll(await loadSettingValues());
    //加载配置项
    if (_settings.isEmpty) {
      var json = jsonDecode(await rootBundle.loadString(
          "lib/assets/config/transmission_settings.json",
          cache: true));
      var groupStr = groups.map<String>((it) => it.text).join(",");
      (json ?? []).forEach((it) {
        var item = SettingGroupModel.fromJson(it);
        if (groupStr.contains(Aria2Group.ALL.text) ||
            groupStr.contains(item.group)) {
          _settings.addAll(item.settings);
        }
      });
    }
    return _settings;
  }
}

/*
* transmission设置项分组
* @author jtechjh
* @Time 2021/5/13 1:35 下午
*/
enum TMGroup {
  Torrents,
  Speed,
  Peers,
  Network,
  Queue,
  ALL,
}

/*
* 扩展transmission设置项分组
* @author jtechjh
* @Time 2021/5/13 1:39 下午
*/
extension TMGroupExtension on TMGroup {
  //获取枚举对应的文本
  String get text {
    switch (this) {
      case TMGroup.Torrents:
        return "torrents";
      case TMGroup.Speed:
        return "speed";
      case TMGroup.Peers:
        return "peers";
      case TMGroup.Network:
        return "network";
      case TMGroup.Queue:
        return "queue";
      case TMGroup.ALL:
        return "all";
    }
    return "";
  }
}
