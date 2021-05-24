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

  const ModifyRPCConfig({
    Key key,
    @required this.controller,
    @required this.methods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          _buildHTTPMethodItem(),
          SizedBox(height: 15),
          _buildPathItem(),
          SizedBox(height: 15),
          _buildTokenItem(),
        ],
      ),
    );
  }

  //判断是否为编辑状态
  bool get isEdited => controller.config.isEdited;

  //内容内间距
  final contentPadding =
      const EdgeInsets.symmetric(vertical: 0, horizontal: 15);

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
        contentPadding: contentPadding,
        // border: OutlineInputBorder(),
      ),
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
      initialValue: isEdited ? controller.config.path : "jsonrpc",
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        // border: OutlineInputBorder(),
        labelText: "路径",
        prefixText: "/",
      ),
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
          initialValue: isEdited ? controller.config.secretToken : "",
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: controller.rpcTokenVisible.value,
          decoration: InputDecoration(
            contentPadding: contentPadding,
            // border: OutlineInputBorder(),
            labelText: "授权密钥",
            suffixIcon: IconButton(
              icon: Icon(controller.rpcTokenVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () => controller.toggleRPCTokenVisible(),
            ),
          ),
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
