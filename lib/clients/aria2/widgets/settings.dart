import 'dart:convert';

import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/route.dart';
import 'package:bt_service_manager/tools/tools.dart';
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
    //监听过滤条件变化
    widget.controller?.filterCallback = (text) {
      setState(() => this._filterText = text);
    };
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
      builder: (f) {
        var text = "li" != type
            ? f.value
            : "#共有 ${f.value.split(item["txtSp"]).length} 条数据";
        return _buildDefaultItem(
          item,
          isDark: index.isOdd,
          direction: Axis.vertical,
          isEdited: _hasEdited(cmd, f.value, def: ""),
          child: TextField(
            readOnly: true,
            obscureText: type == "pwd",
            controller: TextEditingController(text: text),
            keyboardType: _inputType[type],
            decoration: InputDecoration(
              isDense: true,
              suffixIcon: Text(
                _getTextByLang(item["unit"]),
                style: TextStyle(color: Colors.blueAccent),
              ),
              suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
            onTap: () async {
              var result = f.value;
              if (type == "li") {
                result = await _showMultiTextSheet(item, f.value);
              } else {
                result = await _showTextEditSheet(item, f.value);
              }
              widget.controller?.saveFormField(cmd, result);
              f.didChange(result);
            },
          ),
        );
      },
      onSaved: (v) {
        if (_hasEdited(cmd, v, def: "")) {
          widget.controller?.saveFormField(cmd, v);
        }
      },
    );
  }

  //展示多行文本弹出窗口
  Future _showMultiTextSheet(Map item, String value) {
    var textSplit = item["txtSp"];
    List<String> values = value.split(textSplit);
    List<FocusNode> nodes = List.generate(values.length, (_) => FocusNode());
    var controller = ScrollController();
    return AlertTools.bottomSheet<String>(
      content: StatefulBuilder(
        builder: (c, state) {
          return WillPopScope(
            child: Card(
              child: _buildDefaultItem(
                item,
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: FocusScope(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: values.length,
                        itemBuilder: (_, i) => _buildMultiTextItem(
                            c, item, values, nodes, i, state),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => state(() {
                          values.add("");
                          nodes
                            ..add(FocusNode())
                            ..last.requestFocus();
                          Future.delayed(Duration(milliseconds: 100)).then(
                              (value) => controller.animateTo(
                                  controller.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.ease));
                        }),
                      ),
                      IconButton(
                        icon: Icon(Icons.done_all),
                        onPressed: () {
                          values.removeWhere((v) => v.isEmpty);
                          RouteTools.pop(values.join(textSplit).toString());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onWillPop: () async {
              values.removeWhere((v) => v.isEmpty);
              RouteTools.pop(values.join(textSplit).toString());
              return true;
            },
          );
        },
      ),
    );
  }

  //构建多行文本列表子项
  _buildMultiTextItem(BuildContext c, Map item, List<String> values,
      List<FocusNode> nodes, int i, StateSetter refresh) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: values[i]),
            focusNode: nodes[i],
            keyboardType: _inputType[item["type"]],
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: Text(
                "$i. ",
                style: TextStyle(color: Colors.blueAccent),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
            onChanged: (v) => values[i] = v,
            onSubmitted: (v) {
              values.removeWhere((v) => v.isEmpty);
              RouteTools.pop(values.join(item["txtSp"]).toString());
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.copy_rounded),
          onPressed: () =>
              Tools.clipboard(values[i], message: "已将 ${values[i]} 复制到剪切板"),
        ),
        IconButton(
          icon: Icon(Icons.close),
          color: Colors.redAccent,
          onPressed: () => refresh(() {
            values.removeAt(i);
            nodes.removeAt(i);
            FocusScope.of(c).unfocus();
          }),
        ),
      ],
    );
  }

  //显示文本编辑弹窗
  Future _showTextEditSheet(Map item, String value) {
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
    Widget child,
    List<Widget> children = const [],
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
          child ?? Container(),
        ]..addAll(children),
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

  //存储已记录的设置列表
  final Map<String, List> _settings = {};

  //加载配置文件参数
  Future<List> _loadSettingsConfig() async {
    var type = widget.types.join(",");
    if (!_settings.containsKey(type)) {
      var json = await rootBundle.loadString(widget.settingsConfig);
      var config = jsonDecode(json);
      List temp = [];
      widget.types.forEach((k) {
        if (k == SettingType.all) {
          config.values.forEach((v) {
            temp.addAll(v);
          });
        } else {
          temp.addAll(config[k]);
        }
      });
      _settings[type] = temp;
    }
    return _filterSettingList(_settings[type]);
  }

  //过滤条件
  String _filterText;

  //过滤设置列表
  _filterSettingList(List settings) {
    if (null == _filterText || _filterText.isEmpty) return settings;
    List temp = [];
    settings.forEach((it) {
      var cmd = it["cmd"];
      var name = _getTextByLang(it["name"]);
      if (cmd.contains(_filterText) || name.contains(_filterText)) {
        temp.add(it);
      }
    });
    return temp;
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

//过滤条件回调
typedef FilterCallback = void Function(String text);

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

  //过滤方法回调
  FilterCallback _filterCallback;

  //获取表单key
  @protected
  GlobalKey<FormState> get formKey => _formKey;

  //设置过滤方法监听
  @protected
  set filterCallback(FilterCallback value) => _filterCallback = value;

  //保存表单元素内容
  @protected
  saveFormField(String key, dynamic value) => _optionsMap[key] = value;

  //获取已编辑的元素内容
  @protected
  getFormField(String key) => _optionsMap[key];

  //过滤设置列表
  filterSettingList(String text) => _filterCallback(text);

  //提交已修改的配置并返回表
  commitOption() {
    _optionsMap.clear();
    _formKey.currentState
      ..validate()
      ..save();
    return _optionsMap;
  }
}
