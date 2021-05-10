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
          key: widget.controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                snap.data.length,
                (i) => _buildSettingItem(i, snap.data[i]),
              ),
            ),
          ),
        );
      },
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
  _buildSettingItemDefault(
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
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_getTextByLang(item)),
        action: SnackBarAction(
          label: "确定",
          onPressed: () {},
        ),
      )),
    );
  }

  //输入框输入类型表
  final Map<String, TextInputType> _inputType = {
    "num": TextInputType.number,
    "pwd": TextInputType.visiblePassword,
  };

  //构建配置子项-文本
  _buildSettingTextItem(Map item, int index) {
    var cmd = item["cmd"];
    var unit = item["unit"];
    var value = widget.globalSetting[cmd] ?? "";
    var type = item["txtTp"];
    if (type == "li") {
      var split = item["txtSp"];
      List<String> values = [];
      if (split == "li") {
        values.addAll(value.split("\n"));
      } else {
        values.addAll(value.split(split));
      }
      values.removeWhere((it) => it.isEmpty);
      return FormField<List<String>>(
        initialValue: values,
        builder: (f) => _buildSettingItemDefault(item,
            isDark: index.isOdd,
            isEdited: false,
            child: Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    List<String> result = await _showMultiTextSheet(
                        "${_getTextByLang(item["name"])}(${f.value.length})",
                        f.value);
                    if (null != result) {
                      result.removeWhere((it) => it.isEmpty);
                      f.didChange(result);
                    }
                  },
                ),
              ),
            )),
      );
    } else {
      return FormField<String>(
        initialValue: value,
        builder: (f) => _buildSettingItemDefault(
          item,
          isDark: index.isOdd,
          direction: Axis.vertical,
          isEdited: f.value != value,
          child: TextField(
            controller: TextEditingController(text: f.value),
            obscureText: type == "pwd",
            keyboardType: _inputType[type],
            decoration: InputDecoration(
              suffixText: _getTextByLang(unit),
              suffixStyle: TextStyle(color: Colors.blueAccent),
            ),
            onChanged: (v) => f.didChange(v),
          ),
        ),
        onSaved: (v) {
          if (v != value) {
            widget.controller.saveFormField(cmd, v);
          }
        },
      );
    }
  }

  //展示多行文本弹出窗口
  _showMultiTextSheet(String title, List<String> values) {
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
                          Navigator.pop(c, temp);
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
                        return await showDialog(
                          context: c,
                          builder: (_) => AlertDialog(
                            content: Text("共产生 $editCount 处编辑，继续退出将丢失未保存的数据"),
                            actions: [
                              TextButton(
                                child: Text("取消"),
                                onPressed: () => Navigator.pop(c, false),
                              ),
                              TextButton(
                                child: Text("继续"),
                                onPressed: () => Navigator.pop(c, true),
                              ),
                            ],
                          ),
                        );
                      }
                      return true;
                    },
                  )),
                ],
              )),
    );
  }

  //构建配置子项-bool
  _buildSettingBoolItem(Map item, int index) {
    var cmd = item["cmd"];
    var value = widget.globalSetting[cmd] ?? "false";
    return FormField<bool>(
      initialValue: "true" == value,
      builder: (f) => _buildSettingItemDefault(
        item,
        isDark: index.isOdd,
        isEdited: "${f.value}" != value,
        child: Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Switch(
              value: f.value,
              onChanged: (v) {
                FocusScope.of(context).unfocus();
                f.didChange(v);
              },
            ),
          ),
        ),
      ),
      onSaved: (v) {
        if ("$v" != value) {
          widget.controller.saveFormField(cmd, "$v");
        }
      },
    );
  }

  //构建配置子项-选择
  _buildSettingSelectItem(Map item, int index) {
    var cmd = item["cmd"];
    var value = widget.globalSetting[cmd];
    var items = item["select"];
    return FormField<String>(
      initialValue: value,
      builder: (f) => _buildSettingItemDefault(
        item,
        isDark: index.isOdd,
        isEdited: f.value != value,
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
              onChanged: (v) => f.didChange(v),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
          ),
        ),
      ),
      onSaved: (v) {
        if (v != value) {
          widget.controller.saveFormField(cmd, v);
        }
      },
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
  saveFormField(String key, dynamic value) {
    _optionsMap[key] = value;
  }

  //提交已修改的配置并返回表
  commitOption() {
    _optionsMap.clear();
    _formKey.currentState
      ..validate()
      ..save();
    return _optionsMap;
  }
}
