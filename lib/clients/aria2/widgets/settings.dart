import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
* aria2参数设置组件
* @author jtechjh
* @Time 2021/5/8 12:31 PM
*/
class SettingsView extends StatefulWidget {
  //设置的配置文件地址
  final String settingsConfig = "lib/assets/config/aria2_option.json";

  //记录设置类型，可以是一个集合
  final List<String> types;

  //控制器
  final SettingsViewController controller;

  //全局配置参数获取方法
  final Map<String, dynamic> globalSetting;

  const SettingsView(
      {Key key,
      @required this.types,
      @required this.globalSetting,
      this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsViewState();
}

/*
* aria2参数设置组件，状态
* @author jtechjh
* @Time 2021/5/8 12:33 PM
*/
class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    //从配置文件中加载所需设置参数
    _loadSettingsConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            _settings.length,
            (i) => _buildSettingItem(i, _settings[i]),
          ),
        ),
      ),
    );
  }

  //构建配置子项
  _buildSettingItem(int index, Map item) {
    switch (item["type"]) {
      case "txt":
        return _buildSettingTextItem(item, index);
      case "sel":
        return _buildSettingSelectItem(item, index);
      case "bol":
        return _buildSettingBoolItem(item, index);
      default:
        return Container();
    }
  }

  //构建默认子项结构
  _buildSettingItemDefault(int index, Map item, Axis direction, Widget child) {
    var alert = item["alert"];
    var info = item["info"];
    return Container(
      color: index.isOdd ? Colors.grey[200] : Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Flex(
        direction: direction,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(_getTextByLang(item["name"])),
                  _buildSettingItemAction(Icons.message, alert),
                  _buildSettingItemAction(Icons.info, info),
                ],
              ),
              Text(
                "(${item["cmd"]})",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  //构建子项的功能按钮
  _buildSettingItemAction(IconData icon, Map item) {
    if (null == item) return SizedBox();
    return InkResponse(
      radius: 18,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Icon(
          icon,
          size: 14,
          color: Colors.blueAccent,
        ),
      ),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_getTextByLang(item)),
        action: SnackBarAction(
          label: "确定",
          onPressed: () {},
        ),
      )),
    );
  }

  //构建配置子项-文本
  _buildSettingTextItem(Map item, int index) {
    var cmd = item["cmd"];
    var value = widget.globalSetting[cmd];
    var textType = item["txtTp"];
    if (textType == "li") {
      var textSplit = item["txtSp"];
      //构建多行输入
      return Container();
    } else {
      //构建常规输入框
      return _buildSettingItemDefault(
        index,
        item,
        Axis.vertical,
        TextField(),
      );
    }
  }

  //构建配置子项-bool
  _buildSettingBoolItem(Map item, int index) {
    var cmd = item["cmd"];
    var value = widget.globalSetting[cmd];
    return _buildSettingItemDefault(
      index,
      item,
      Axis.horizontal,
      Expanded(
          child: Align(
        alignment: Alignment.centerRight,
        child: Switch(
          value: value == "true",
          onChanged: (v) => _modifyGlobalSetting(cmd, "$v"),
        ),
      )),
    );
  }

  //构建配置子项-选择
  _buildSettingSelectItem(Map item, int index) {
    var cmd = item["cmd"];
    var value = widget.globalSetting[cmd];
    var items = item["select"];
    return _buildSettingItemDefault(
      index,
      item,
      Axis.horizontal,
      Expanded(
          child: Align(
        alignment: Alignment.centerRight,
        child: DropdownButton(
          value: value,
          items: items.map<DropdownMenuItem<String>>((it) {
            var v = it["value"];
            var name = _getTextByLang(it["name"]);
            return DropdownMenuItem<String>(
              value: v,
              child: Text(name),
            );
          }).toList(),
          onChanged: (v) => _modifyGlobalSetting(cmd, v),
        ),
      )),
    );
  }

  //修改全局配置参数
  _modifyGlobalSetting(String key, dynamic value) {
    setState(() {
      if (widget.globalSetting.containsKey(key)) {
        widget.globalSetting[key] = value;
      }
      widget.controller?.updateOption(key, value);
    });
  }

  //记录要加载的配置列表
  List _settings = [];

  //加载配置文件参数
  _loadSettingsConfig() async {
    var json = await rootBundle.loadString(widget.settingsConfig);
    var config = jsonDecode(json);
    widget.types.forEach((k) {
      if (k == SettingType.all) {
        config.values.forEach((v) {
          _settings.addAll(v);
        });
      } else {
        _settings.addAll(config[k]);
      }
    });
    setState(() {});
  }

  //根据当前语言选择文本
  _getTextByLang(Map map) {
    ///待完善
    return map["cn"];
  }
}

/*
* 设置类型
* @author jtechjh
* @Time 2021/5/8 12:36 PM
*/
class SettingType {
  static final base = "base";
  static final httpFtpSftp = "httpFtpSftp";
  static final http = "http";
  static final ftpSftp = "ftpSftp";
  static final bitTorrent = "bitTorrent";
  static final metaLink = "metaLink";
  static final rpc = "rpc";
  static final advanced = "advanced";
  static final all = "all";
}

/*
* aria2参数设置组件-控制器
* @author jtechjh
* @Time 2021/5/8 3:44 PM
*/
class SettingsViewController extends ChangeNotifier {
  //维护修改的配置记录
  List<Map<String, dynamic>> _options = [];

  //更新参数属性
  void updateOption(String key, dynamic value) {
    _options.add({key: value});
    notifyListeners();
  }

  //获取最新的参数属性更新
  get lastOption => _options.isNotEmpty ? _options.last : {};

  //获取全部参数属性
  get allOption {
    Map<String, dynamic> temp = {};
    _options.forEach((it) => temp.addAll(it));
    return temp;
  }
}
