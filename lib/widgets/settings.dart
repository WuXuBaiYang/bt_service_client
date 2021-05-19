import 'package:bt_service_manager/model/settings_model.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/route.dart';
import 'package:bt_service_manager/tools/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//获取设置项值
typedef GetSettingValue = dynamic Function(String key);

//自定义子项构建器
typedef CustomItemBuilder = CustomBuilder Function(SettingItemModel item);

/*
* 通用设置页面视图
* @author jtechjh
* @Time 2021/5/8 12:31 PM
*/
class SettingsView extends StatefulWidget {
  //控制器
  final SettingsViewController controller;

  //设置项集合
  final List<SettingItemModel> settings;

  //获取设置项值
  final GetSettingValue getSettingValue;

  //自定义构建方法
  final CustomItemBuilder customItemBuilder;

  const SettingsView({
    Key key,
    @required this.controller,
    @required this.settings,
    @required this.getSettingValue,
    this.customItemBuilder,
  }) : super(key: key);

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
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller?.formKey,
      child: ListView.builder(
          itemCount: widget.settings.length,
          itemBuilder: (_, i) {
            var item = widget.settings[i];
            if (item.isText) return _buildTextItem(item, i);
            if (item.isSelect) return _buildSelectItem(item, i);
            if (item.isSwitch) return _buildSwitchItem(item, i);
            if (item.isCustom) return _buildCustomItem(item, i);
            return Container();
          }),
    );
  }

  //输入框输入类型表
  final Map<String, TextInputType> _inputType = {
    "num": TextInputType.number,
    "pwd": TextInputType.visiblePassword,
  };

  //构建配置子项-文本
  _buildTextItem(SettingItemModel item, int index) {
    TextSettingParam textParam = item.param;
    return FormField<_TextObject>(
      initialValue: _TextObject(
        _getItemValue(item.key, def: ""),
        _getItemValue(textParam?.enableKey ?? "", def: "true"),
      ),
      builder: (f) {
        var text = textParam?.isList ?? false
            ? "#共有 ${f.value.text.split(textParam.split).length} 条数据"
            : f.value.text;
        return _buildDefaultItem(
          item,
          isDark: index.isOdd,
          isEdited: (_hasEdited(item.key, f.value.text, def: "") ||
              ((textParam?.hasEnableKey ?? false)
                  ? _hasEdited(textParam?.enableKey ?? "", f.value.enable,
                      def: true)
                  : false)),
          endChildren: [
            (textParam?.hasEnableKey ?? false)
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Switch(
                      value: f.value.isEnable,
                      onChanged: (v) {
                        var obj = f.value;
                        obj.enable = "$v";
                        widget.controller
                            ?.saveFormField(textParam.enableKey, obj.enable);
                        f.didChange(obj);
                      },
                    ),
                  )
                : Container(),
          ],
          bottomChildren: [
            f.value.isEnable
                ? TextField(
                    readOnly: true,
                    enabled: f.value.isEnable,
                    obscureText: textParam?.isPassword ?? false,
                    controller: TextEditingController(text: text),
                    keyboardType: _inputType[textParam?.type ?? ""],
                    decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: Text(
                        item.unit?.text ?? "",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      suffixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                    onTap: () async {
                      var result = f.value;
                      if (textParam?.isList ?? false) {
                        result.text =
                            await _showMultiTextSheet(item, f.value.text);
                      } else {
                        result.text =
                            await _showTextEditSheet(item, f.value.text);
                      }
                      widget.controller?.saveFormField(item.key, result.text);
                      f.didChange(result);
                    },
                  )
                : Container(),
          ],
        );
      },
      onSaved: (v) {
        if ((_hasEdited(item.key, v.text, def: "") ||
            ((textParam?.hasEnableKey ?? false)
                ? _hasEdited(textParam?.enableKey ?? "", v.enable, def: true)
                : false))) {
          widget.controller?.saveFormField(item.key, v.text);
          if (textParam?.hasEnableKey ?? false) {
            widget.controller?.saveFormField(textParam.enableKey, v.enable);
          }
        }
      },
    );
  }

  //展示多行文本弹出窗口
  Future _showMultiTextSheet(SettingItemModel item, String value) {
    TextSettingParam textParam = item.param;
    List<String> values = value.split(textParam.split);
    List<FocusNode> nodes = List.generate(values.length, (_) => FocusNode());
    var controller = ScrollController();
    return AlertTools.bottomSheet<String>(
      content: StatefulBuilder(
        builder: (c, state) {
          return WillPopScope(
            child: _buildDefaultItem(
              item,
              bottomChildren: [
                FocusScope(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: values.length,
                    itemBuilder: (_, i) =>
                        _buildMultiTextItem(c, item, values, nodes, i, state),
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
                        RouteTools.pop(
                            values.join(textParam.split).toString());
                      },
                    ),
                  ],
                ),
              ],
            ),
            onWillPop: () async {
              values.removeWhere((v) => v.isEmpty);
              RouteTools.pop(values.join(textParam.split).toString());
              return true;
            },
          );
        },
      ),
    );
  }

  //构建多行文本列表子项
  _buildMultiTextItem(BuildContext c, SettingItemModel item,
      List<String> values, List<FocusNode> nodes, int i, StateSetter refresh) {
    TextSettingParam textParam = item.param;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: values[i]),
            focusNode: nodes[i],
            keyboardType: _inputType[textParam.type],
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
              RouteTools.pop(values.join(textParam.split).toString());
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
  Future _showTextEditSheet(SettingItemModel item, String value) {
    TextSettingParam textParam = item.param;
    return AlertTools.bottomSheet<String>(
      content: StatefulBuilder(
        builder: (_, state) {
          var controller = TextEditingController(text: value);
          return WillPopScope(
            child: SingleChildScrollView(
              child: _buildDefaultItem(
                item,
                bottomChildren: [
                  TextField(
                    autofocus: true,
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    keyboardType: _inputType[textParam?.type ?? ""],
                    decoration: InputDecoration(
                      suffixText: item.unit?.text ?? "",
                      suffixStyle: TextStyle(color: Colors.blueAccent),
                      suffixIcon: IconButton(
                        color: Colors.blueAccent,
                        icon: Icon(Icons.done),
                        onPressed: () => RouteTools.pop(controller.text),
                      ),
                    ),
                    onSubmitted: (v) => RouteTools.pop(v),
                  ),
                ],
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

  //构建配置子项-switch
  _buildSwitchItem(SettingItemModel item, int index) {
    var value = _getItemValue(item.key, def: "false");
    return FormField<bool>(
      initialValue: "true" == "$value",
      builder: (f) => _buildDefaultItem(
        item,
        isDark: index.isOdd,
        isEdited: _hasEdited(item.key, "${f.value}"),
        endChildren: [
          Align(
            alignment: Alignment.centerRight,
            child: Switch(
              value: f.value,
              onChanged: (v) {
                widget.controller?.saveFormField(item.key, "$v");
                f.didChange(v);
              },
            ),
          ),
        ],
      ),
      onSaved: (v) {
        if (_hasEdited(item.key, "$v")) {
          widget.controller?.saveFormField(item.key, "$v");
        }
      },
    );
  }

  //构建配置子项-选择
  _buildSelectItem(SettingItemModel item, int index) {
    SelectSettingParam selectParam = item.param;
    return FormField<dynamic>(
      initialValue: _getItemValue(item.key),
      builder: (f) => _buildDefaultItem(
        item,
        isDark: index.isOdd,
        isEdited: _hasEdited(item.key, f.value),
        endChildren: [
          Align(
            alignment: Alignment.centerRight,
            child: DropdownButton(
              value: f.value,
              items: selectParam.items.map<DropdownMenuItem>((it) {
                return DropdownMenuItem<dynamic>(
                  value: it.value,
                  child: Text(it.name?.text ?? it.value),
                );
              }).toList(),
              onChanged: (v) {
                widget.controller?.saveFormField(item.key, v);
                f.didChange(v);
              },
            ),
          ),
        ],
      ),
      onSaved: (v) {
        if (_hasEdited(item.key, v)) {
          widget.controller?.saveFormField(item.key, v);
        }
      },
    );
  }

  //构建配置子项-自定义
  _buildCustomItem(SettingItemModel item, int index) {
    if (null == widget.customItemBuilder) return Container();
    var builder = widget.customItemBuilder(item);
    if (null == builder) return Container();
    return FormField<dynamic>(
      initialValue: builder.initialValue,
      builder: (f) => _buildDefaultItem(
        item,
        isDark: index.isOdd,
        isEdited: builder.hasEdited(f.value),
        endChildren: builder.buildEndChildren?.call(f.value) ?? [],
        bottomChildren: builder.buildBottomChildren?.call(f.value) ?? [],
      ),
      onSaved: (v) {
        if (builder.hasEdited(v)) {
          builder.onSaved(widget.controller, v);
        }
      },
    );
  }

  //根据key获取对应的值
  _getItemValue(String key, {def}) =>
      widget.controller?.getFormField(key) ??
      widget.getSettingValue(key) ??
      def;

  //根据当前值与原值进行比较，得出是否已计算的结果
  bool _hasEdited(String key, value, {def}) =>
      (widget.getSettingValue(key) ?? def) != value;

  //构建默认子项结构
  _buildDefaultItem(
    SettingItemModel item, {
    List<Widget> endChildren = const [],
    List<Widget> bottomChildren = const [],
    bool isEdited = false,
    bool isDark = false,
  }) {
    return Container(
      color: isDark ? Colors.grey[200] : Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${isEdited ? "* " : ""}${item.name?.text ?? ""}",
                          style: TextStyle(
                              color: isEdited ? Colors.blueAccent : null),
                        ),
                        _buildSettingItemAction(Icons.message, item.alert),
                        _buildSettingItemAction(Icons.info, item.info),
                      ],
                    ),
                    Text(
                      "(${item.key})",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            ]..addAll(endChildren),
          )
        ]..addAll(bottomChildren),
      ),
    );
  }

  //构建子项的功能按钮
  _buildSettingItemAction(IconData icon, SettingTextModel item) {
    if (null == item) return Container();
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
      onTap: () => AlertTools.snack(item.text,
          button: TextButton(
            child: Text("确定"),
            onPressed: () {},
          )),
    );
  }
}

/*
* aria2参数设置组件-控制器
* @author jtechjh
* @Time 2021/5/8 3:44 PM
*/
class SettingsViewController {
  //表单控制key
  final GlobalKey<FormState> _formKey = GlobalKey();

  //已修改配置表
  Map<String, dynamic> _optionsMap = {};

  //获取表单key
  @protected
  GlobalKey<FormState> get formKey => _formKey;

  //保存表单元素内容
  saveFormField(String key, dynamic value) => _optionsMap[key] = value;

  //获取已编辑的元素内容
  @protected
  getFormField(String key) => _optionsMap[key];

  //提交已修改的配置并返回表
  commitOption({List<String> keys}) {
    _optionsMap.clear();
    _formKey.currentState
      ..validate()
      ..save();
    return _optionsMap;
  }
}

//自定义视图构建工具
class CustomBuilder {
  //初始值
  dynamic initialValue;

  //是否编辑回调
  bool Function(dynamic value) hasEdited;

  //构建尾部子视图集合
  List<Widget> Function(dynamic value) buildEndChildren;

  //构建底部子视图集合
  List<Widget> Function(dynamic value) buildBottomChildren;

  //保存事件
  void Function(SettingsViewController controller, dynamic value) onSaved;

  CustomBuilder({
    @required this.initialValue,
    @required this.hasEdited,
    @required this.onSaved,
    this.buildEndChildren,
    this.buildBottomChildren,
  });
}

/*
* 文本对象
* @author jtechjh
* @Time 2021/5/17 4:11 下午
*/
class _TextObject {
  String text;
  String enable;

  //判断是否可用
  bool get isEnable => enable == "true";

  _TextObject(this.text, this.enable);
}
