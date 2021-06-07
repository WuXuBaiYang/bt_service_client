import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/server/modify_controller.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/jimage.dart';
import 'package:bt_service_manager/tools/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'url_address_form_field.dart';

/*
* 创建/编辑常用服务器配置
* @author jtechjh
* @Time 2021/5/19 4:56 下午
*/
class ModifyCommonConfig<T extends ServerConfigModel> extends StatelessWidget {
  //编辑服务控制器
  final ModifyServerController<T> controller;

  //支持的协议集合
  final List<Protocol> protocols;

  //表单项样式
  final InputDecorationTheme decorationTheme;

  //间隔大小
  final double separatorSize;

  ModifyCommonConfig({
    Key key,
    @required this.controller,
    @required this.protocols,
    @required this.decorationTheme,
    this.separatorSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List items = [
      _buildAliasItem(),
      _buildAddressItem(),
      _buildLogoSelectItem(),
      _buildFlagColorItem(),
      _buildTagsItem(),
    ];
    return Container(
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (_, i) => items[i],
        separatorBuilder: (_, i) => SizedBox(height: separatorSize),
      ),
    );
  }

  //构建别名项
  _buildAliasItem() {
    var config = controller.config;
    return TextFormField(
      initialValue: config.alias ?? "",
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: "服务器别名",
      ).applyDefaults(decorationTheme),
      onSaved: (v) => config.alias = v,
    );
  }

  //构建地址子项
  _buildAddressItem() {
    var config = controller.config;
    return UrlAddressFormField(
      protocol: config.protocol,
      hostname: config.hostname,
      port: config.port,
      protocols: protocols,
      onSaved: (v) {
        config.protocol = v.protocol;
        config.hostname = v.hostname;
        config.port = v.port;
      },
      decorationTheme: decorationTheme,
    );
  }

  //构建图表选择子项
  _buildLogoSelectItem() {
    var config = controller.config;
    return FormField<String>(
      initialValue: config.logoPath ?? "",
      builder: (field) => InkWell(
        child: InputDecorator(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("从相册或拍照中选择"),
            trailing: config.hasCustomLogo
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogoRadioItem(config, field, false),
                      SizedBox(width: 8),
                      _buildLogoRadioItem(config, field, true),
                    ],
                  )
                : JImage.assetsIcon(config.defaultAssetsIcon, size: 45),
            dense: true,
          ),
          decoration: InputDecoration(
            labelText: "自定义图标",
          ).applyDefaults(decorationTheme),
        ),
        onTap: () async {
          var result = await JAlert.pickSingleImage();
          if (null != result) {
            config.logoPath = result.path;
            field.didChange(result.path);
          }
        },
      ),
      onSaved: (v) => controller.config.logoPath = v,
    );
  }

  //图标单选项
  _buildLogoRadioItem(config, field, bool circle) {
    return GestureDetector(
      child: JImage.file(
        field.value,
        size: 45,
        borderWidth: 3,
        borderColor: circle == config.logoCircle
            ? Colors.blueAccent
            : Colors.transparent,
        circle: circle,
      ),
      onTap: () {
        config.logoCircle = circle;
        field.didChange(field.value);
      },
    );
  }

  //标记颜色选择
  _buildFlagColorItem() {
    var config = controller.config;
    return FormField<Color>(
      initialValue: Color(config.flagColor ?? Colors.red.value),
      builder: (field) => InkWell(
        child: InputDecorator(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("选择一个颜色作为主要标记"),
            trailing: ClipOval(
              child: Container(
                width: 15,
                height: 15,
                color: field.value,
              ),
            ),
            dense: true,
          ),
          decoration: InputDecoration(
            labelText: "标记颜色",
          ).applyDefaults(decorationTheme),
        ),
        onTap: () async {
          var result = await JAlert.showColorPicker(
            selectColor: field.value,
          );
          if (null != result) field.didChange(result);
        },
      ),
      onSaved: (v) => controller.config.flagColor = v.value,
    );
  }

  //标签组选项
  _buildTagsItem() {
    var config = controller.config;
    return FormField<List<String>>(
      initialValue: config.tags ?? [],
      builder: (field) => InputDecorator(
        child: Wrap(
          spacing: 8,
          children: List.generate(
            field.value.length,
            (i) => RawChip(
              label: Text(field.value[i]),
              onDeleted: () => field.didChange(field.value..removeAt(i)),
            ),
          ),
        ),
        decoration: InputDecoration(
          labelText: "标签",
          suffixIcon: IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () async {
              var result = await _showAddTagSheet();
              if (null != result) field.didChange(field.value..add(result));
            },
          ),
        ).applyDefaults(decorationTheme),
      ),
      onSaved: (v) => controller.config.tags = v,
    );
  }

  //添加标签输入框
  _showAddTagSheet() {
    final controller = TextEditingController();
    return AlertTools.bottomSheet<String>(
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: "添加标签",
            suffixIcon: IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                var text = controller.text.trim();
                if (text.isEmpty) {
                  return AlertTools.snack("无法添加空标签");
                }
                RouteTools.pop(text);
              },
            ),
          ),
        ),
      ),
    );
  }
}
