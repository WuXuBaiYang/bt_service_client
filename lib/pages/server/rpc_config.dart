import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/server/modify_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* 创建/编辑RPC配置
* @author jtechjh
* @Time 2021/5/19 4:56 下午
*/
class ModifyRPCConfig extends StatelessWidget {
  //编辑服务控制器
  final ModifyServerController<RPCServerConfigModel> controller;

  //支持的请求方法集合
  final List<HTTPMethod> methods;

  const ModifyRPCConfig({
    Key key,
    @required this.controller,
    @required this.methods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: "0",
      items: List.generate(10, (i) {
        // var method = methods[i];
        return DropdownMenuItem(
          child: Text("aaa$i"),
          value: "$i",
        );
      }),
      onChanged: (v){},
      decoration: InputDecoration(
        prefixText: "aaaa",
      ),
      onSaved: (v) => controller.config.method = v,
      // onTap: (){},
    );
    // return Container(
    //   padding: EdgeInsets.all(8),
    //   child: Column(
    //     children: [
    //       TextFormField(
    //         initialValue: isEdited ? controller.config.path : "jsonrpc",
    //         decoration: InputDecoration(
    //           contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
    //           border: OutlineInputBorder(),
    //           labelText: "路径",
    //           prefixText: "/",
    //         ),
    //         validator: (v) {
    //           if (v.isEmpty) {
    //             return "RPC路径不能为空";
    //           }
    //           return null;
    //         },
    //         onSaved: (v) => controller.config.path = v,
    //       ),
    //       SizedBox(height: 8),
    //       // Row(
    //       //   children: [
    //       //     Text("请求方法"),
    //           DropdownButtonFormField<HTTPMethod>(
    //             value: controller.config.method,
    //             items: List.generate(methods.length, (i) {
    //               var method = methods[i];
    //               return DropdownMenuItem(
    //                 child: Text(method.text),
    //                 value: method,
    //               );
    //             }),
    //             onSaved: (v) => controller.config.method = v,
    //           ),
    //       //   ],
    //       // ),
    //       SizedBox(height: 8),
    //       Obx(() => TextFormField(
    //             initialValue: isEdited ? controller.config.secretToken : "",
    //             obscureText: controller.rpcTokenVisible.value,
    //             decoration: InputDecoration(
    //               contentPadding:
    //                   EdgeInsets.symmetric(vertical: 0, horizontal: 15),
    //               border: OutlineInputBorder(),
    //               labelText: "授权密钥",
    //               suffixIcon: IconButton(
    //                 icon: Icon(controller.rpcTokenVisible.value
    //                     ? Icons.visibility
    //                     : Icons.visibility_off),
    //                 onPressed: () => controller.toggleRPCTokenVisible(),
    //               ),
    //             ),
    //             validator: (v) {
    //               if (v.isEmpty) {
    //                 return "授权密钥不能为空";
    //               }
    //               return null;
    //             },
    //             onSaved: (v) => controller.config.secretToken = v,
    //           )),
    //     ],
    //   ),
    // );
  }

  //判断是否为编辑状态
  bool get isEdited => controller.config.isEdited;
}
