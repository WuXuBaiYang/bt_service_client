import 'dart:convert';

import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/route.dart';
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
      @required this.controller})
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: _loadSettingsConfig(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Form(
          key: widget.controller?.formKey,
          child: ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (_, i) {
                var item = snap.data[i];
                var type = item["type"];
                if ("txt" == type) return _buildTextItem(item, i);
                if ("sel" == type) return _buildSelectItem(item, i);
                if ("bol" == type) return _buildBoolItem(item, i);
                return Container();
              }),
        );
      },
    );
  }

  //输入框输入类型表
  final Map<String, TextInputType> _inputType = {
    "num": TextInputType.number,
    "pwd": TextInputType.visiblePassword,
  };

  //构建配置子项-文本
  _buildTextItem(Map item, int index) {
    var cmd = item["cmd"];
    var type = item["txtTp"];
    return FormField<String>(
      initialValue: _getItemValue(cmd, def: ""),
      builder: (f) => _buildDefaultItem(
        item,
        isDark: index.isOdd,
        direction: Axis.vertical,
        isEdited: _hasEdited(cmd, f.value, def: ""),
        child: TextField(
          readOnly: true,
          obscureText: type == "pwd",
          controller: TextEditingController(text: f.value),
          keyboardType: _inputType[type],
          decoration: InputDecoration(
            suffixText: _getTextByLang(item["unit"]),
            suffixStyle: TextStyle(color: Colors.blueAccent),
          ),
          onTap: () async {
            var result = f.value;
            if (type == "li") {
              result = _showMultiTextSheet("", []);
            } else {
              result = await _showTextEditSheet(item, f.value);
            }
            widget.controller?.saveFormField(cmd, result);
            f.didChange(result);
          },
        ),
      ),
      onSaved: (v) {
        if (_hasEdited(cmd, v)) {
          widget.controller?.saveFormField(cmd, v);
        }
      },
    );
  }

  //展示多行文本弹出窗口
  _showMultiTextSheet(String title, List<String> values) {
    // var split = item["txtSp"];
    // List<String> values = [];
    // if (split == "li") {
    //   values.addAll(value.split("\n"));
    // } else {
    //   values.addAll(value.split(split));
    // }
    // values.removeWhere((it) => it.isEmpty);
    List<String> temp = []..addAll(values);
    int editCount = 0;
    GlobalKey<FormState> _formKey = GlobalKey();
    return showModalBottomSheet<List<String>>(
      context: context,
      builder: (c) => StatefulBuilder(
          builder: (_, state) => Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      CloseButton(),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_box_outlined),
                        onPressed: () => state(() => temp.add("")),
                      ),
                      IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () {
                          _formKey.currentState
                            ..validate()
                            ..save();
                          editCount = 0;
                          RouteTools.pop(temp);
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                      child: Form(
                    key: _formKey,
                    child: ListView.builder(
                      itemCount: temp.length,
                      itemBuilder: (_, i) {
                        var controller = TextEditingController(text: temp[i]);
                        return TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => state(() => temp.removeAt(i)),
                            ),
                          ),
                          onSaved: (v) {
                            temp[i] = v;
                            if (i >= values.length || v != values[i]) {
                              editCount++;
                            }
                          },
                        );
                      },
                    ),
                    onWillPop: () async {
                      editCount = 0;
                      _formKey.currentState
                        ..validate()
                        ..save();
                      if (editCount > 0) {
                        return AlertTools.alertDialog(
                          "共产生 $editCount 处编辑，继续退出将丢失未保存的数据",
                          cancel: "取消",
                          onCancel: () => RouteTools.pop(false),
                          confirm: "继续",
                          onConfirm: () => RouteTools.pop(true),
                        );
                      }
                      return true;
                    },
                  )),
                ],
              )),
    );
  }

  //显示文本编辑弹窗
  _showTextEditSheet(Map item, String value) {
    return AlertTools.bottomSheet<String>(
      content: StatefulBuilder(
        builder: (_, state) {
          var controller = TextEditingController(text: value);
          return WillPopScope(
            child: SingleChildScrollView(
              child: Card(
                child: _buildDefaultItem(
                  item,
                  direction: Axis.vertical,
                  child: TextField(
                    autofocus: true,
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    keyboardType: _inputType[item["type"]],
                    decoration: InputDecoration(
                      suffixText: _getTextByLang(item["unit"]),
                      suffixStyle: TextStyle(color: Colors.blueAccent),
                      suffixIcon: IconButton(
                        color: Colors.blueAccent,
                        icon: Icon(Icons.done),
                        onPressed: () => RouteTools.pop(controller.text),
                      ),
                    ),
                    onSubmitted: (v) => RouteTools.pop(v),
                  ),
                ),
              ),
            ),
            onWillPop: () async {
              RouteTools.pop(controller.text);
              return true;
            },
          );
        },
      ),
    );
  }

  //构建配置子项-bool
  _buildBoolItem(Map item, int index) {
    var cmd = item["cmd"];
    return FormField<bool>(
      initialValue: "true" == _getItemValue(cmd, def: "false"),
      builder: (f) => _buildDefaultItem(
        item,
        isDark: index.isOdd,
        isEdited: _hasEdited(cmd, "${f.value}"),
        child: Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Switch(
              value: f.value,
              onChanged: (v) {
                widget.controller?.saveFormField(cmd, "$v");
                f.didChange(v);
              },
            ),
          ),
        ),
      ),
      onSaved: (v) {
        if (_hasEdited(cmd, "$v")) {
          widget.controller?.saveFormField(cmd, "$v");
        }
      },
    );
  }

  //构建配置子项-选择
  _buildSelectItem(Map item, int index) {
    var cmd = item["cmd"];
    var items = item["select"];
    return FormField<String>(
      initialValue: _getItemValue(cmd),
      builder: (f) => _buildDefaultItem(
        item,
        isDark: index.isOdd,
        isEdited: _hasEdited(cmd, f.value),
        child: Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: DropdownButton<String>(
              value: f.value,
              items: items.map<DropdownMenuItem<String>>((it) {
                return DropdownMenuItem<String>(
                  value: it["value"],
                  child: Text(_getTextByLang(it["name"])),
                );
              }).toList(),
              onChanged: (v) {
                widget.controller?.saveFormField(cmd, v);
                f.didChange(v);
              },
            ),
          ),
        ),
      ),
      onSaved: (v) {
        if (_hasEdited(cmd, v)) {
          widget.controller?.saveFormField(cmd, v);
        }
      },
    );
  }

  //根据key获取对应的值
  _getItemValue(String key, {def}) =>
      widget.controller?.getFormField(key) ?? widget.globalSetting[key] ?? def;

  //根据当前值与原值进行比较，得出是否已计算的结果
  bool _hasEdited(String key, value, {def}) =>
      (widget.globalSetting[key] ?? def) != value;

  //构建默认子项结构
  _buildDefaultItem(
    Map item, {
    @required Widget child,
    Axis direction = Axis.horizontal,
    bool isEdited = false,
    bool isDark = false,
  }) {
    var alert = item["alert"];
    var info = item["info"];
    return Container(
      color: isDark ? Colors.grey[200] : Colors.transparent,
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
                  Text(
                    "${isEdited ? "* " : ""}${_getTextByLang(item["name"])}",
                    style:
                        TextStyle(color: isEdited ? Colors.blueAccent : null),
                  ),
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
      onTap: () => AlertTools.snack(_getTextByLang(item),
          button: TextButton(
            child: Text("确定"),
            onPressed: () {},
          )),
    );
  }

  //加载配置文件参数
  Future<List> _loadSettingsConfig() async {
    var json = await rootBundle.loadString(widget.settingsConfig);
    var config = jsonDecode(json);
    List settings = [];
    widget.types.forEach((k) {
      if (k == SettingType.all) {
        config.values.forEach((v) {
          settings.addAll(v);
        });
      } else {
        settings.addAll(config[k]);
      }
    });
    return settings;
  }

  //根据当前语言选择文本
  _getTextByLang(Map map) {
    if (null == map) return "";

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
class SettingsViewController {
  //已修改配置表
  Map<String, dynamic> _optionsMap = {};

  //表单控制key
  final GlobalKey<FormState> _formKey = GlobalKey();

  //获取表单key
  @protected
  GlobalKey<FormState> get formKey => _formKey;

  //保存表单元素内容
  @protected
  saveFormField(String key, dynamic value) => _optionsMap[key] = value;

  //获取已编辑的元素内容
  @protected
  getFormField(String key) => _optionsMap[key];

  //提交已修改的配置并返回表
  commitOption() {
    _optionsMap.clear();
    _formKey.currentState
      ..validate()
      ..save();
    return _optionsMap;
  }
}
