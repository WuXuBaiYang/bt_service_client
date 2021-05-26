import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/server/modify_controller.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/jimage.dart';
import 'package:bt_service_manager/tools/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      initialValue: config.currentLogoPath,
      builder: (field) => InkWell(
        child: InputDecorator(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("从相册或拍照中选择"),
            trailing: config.hasCustomLogo
                ? JImage.file(field.value, size: 45)
                : JImage.assetsIcon(field.value, size: 45),
            dense: true,
          ),
          decoration: InputDecoration(
            labelText: "自定义图标",
          ).applyDefaults(decorationTheme),
        ),
        onTap: () async {
          var result = await JAlert.pickFilesSheet(filterTypes: [
            JFileType.Image,
            // JFileType.TakeImage,
          ]);
          if (result.isNotEmpty) {
            field.didChange(result.first.path);
          }
        },
      ),
      onSaved: (v) => controller.config.logoPath = v,
    );
  }
}
