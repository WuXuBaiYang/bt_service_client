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
class Aria2SettingsView extends StatelessWidget {
  //控制器
  final SettingsViewController controller;

  //要展示的设置项组名集合
  final List<Aria2Group> groups;

  //加载设置项的值
  final LoadSettingValues loadSettingValues;

  Aria2SettingsView({
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
          getSettingValue: (key) {
            return _settingValues[key];
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
      var json = jsonDecode(await rootBundle
          .loadString("lib/assets/config/aria2_settings.json", cache: true));
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
* aria2设置项分组
* @author jtechjh
* @Time 2021/5/13 1:35 下午
*/
enum Aria2Group {
  Base,
  HttpFtpSFtp,
  Http,
  FtpSFtp,
  BitTorrent,
  MetaLink,
  RPC,
  Advanced,
  ALL,
}

/*
* 扩展aria2设置项分组
* @author jtechjh
* @Time 2021/5/13 1:39 下午
*/
extension Aria2GroupExtension on Aria2Group {
  //获取枚举对应的文本
  String get text {
    switch (this) {
      case Aria2Group.Base:
        return "base";
      case Aria2Group.HttpFtpSFtp:
        return "httpFtpSFtp";
      case Aria2Group.Http:
        return "http";
      case Aria2Group.FtpSFtp:
        return "ftpSFtp";
      case Aria2Group.BitTorrent:
        return "bitTorrent";
      case Aria2Group.MetaLink:
        return "metaLink";
      case Aria2Group.RPC:
        return "rpc";
      case Aria2Group.Advanced:
        return "advanced";
      case Aria2Group.ALL:
        return "all";
    }
    return "";
  }
}
