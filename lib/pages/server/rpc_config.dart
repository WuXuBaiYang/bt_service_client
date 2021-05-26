import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/server/modify_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* 创建/编辑服务器RPC配置
* @author jtechjh
* @Time 2021/5/19 4:56 下午
*/
class ModifyRPCConfig<T extends RPCServerConfigModel> extends StatelessWidget {
  //编辑服务控制器
  final ModifyServerController<T> controller;

  //支持的请求方法集合
  final List<HTTPMethod> methods;

  //表单项样式
  final InputDecorationTheme decorationTheme;

  //间隔大小
  final double separatorSize;

  ModifyRPCConfig({
    Key key,
    @required this.controller,
    @required this.methods,
    @required this.decorationTheme,
    this.separatorSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List items = [
      _buildHTTPMethodItem(),
      _buildPathItem(),
      _buildTokenItem(),
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

  //构建请求方法选择
  _buildHTTPMethodItem() {
    return DropdownButtonFormField<HTTPMethod>(
      value: controller.config.method,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: List.generate(methods.length, (i) {
        var method = methods[i];
        return DropdownMenuItem(
          child: Text(method.text),
          value: method,
        );
      }),
      decoration: InputDecoration(
        labelText: "请求方法",
      ).applyDefaults(decorationTheme),
      onChanged: (v) {},
      validator: (v) {
        if (null == v) {
          return "请求方法不能为空";
        }
        return null;
      },
      onSaved: (v) => controller.config.method = v,
    );
  }

  //构建json-rpc路径
  _buildPathItem() {
    return TextFormField(
      initialValue: controller.config.path ?? "jsonrpc",
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: "路径",
        prefixText: "/",
      ).applyDefaults(decorationTheme),
      validator: (v) {
        if (v.isEmpty) {
          return "RPC路径不能为空";
        }
        return null;
      },
      onSaved: (v) => controller.config.path = v,
    );
  }

  //构建授权密钥
  _buildTokenItem() {
    return Obx(() => TextFormField(
          initialValue: controller.config.secretToken ?? "",
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: controller.rpcTokenVisible.value,
          decoration: InputDecoration(
            labelText: "授权密钥",
            suffixIcon: IconButton(
              icon: Icon(controller.rpcTokenVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () => controller.toggleRPCTokenVisible(),
            ),
          ).applyDefaults(decorationTheme),
          validator: (v) {
            if (v.isEmpty) {
              return "授权密钥不能为空";
            }
            return null;
          },
          onSaved: (v) => controller.config.secretToken = v,
        ));
  }
}
