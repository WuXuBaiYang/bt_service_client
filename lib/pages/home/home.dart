import 'package:bt_service_manager/manage/database/database_manage.dart';
import 'package:bt_service_manager/model/base_model.dart';
import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/widgets/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 首页
* @author jtechjh
* @Time 2021/4/29 4:22 PM
*/
class HomePage extends StatelessWidget {
  // QBAPI qbAPI = api.getQB("https://www.jtechnas.club:8090/api/v2");
  // Aria2API aria2API = api.getAria2(
  //     "https://www.jtechnas.club:6811/jsonrpc", "POST", "18600574971");

  final SettingsViewController controller = SettingsViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              // var m = controller.commitOption();
              print("");
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          var model = Aria2ConfigModel.create(
            Protocol.HTTPS,
            "www.jtechnas.club",
            6811,
            "jsonrpc",
            HTTPMethod.POST,
            "18600574971",
          );
          dbManage.server.addServerConfig("key", model).then((value) {
            print("");
            var a = dbManage.server.loadAllServerConfig();
            print("");
          });
        },
      ),
      // body: Container(
      //   child: FutureBuilder<Aria2ResponseModel>(
      //     future: aria2API.setting.getGlobalOption(),
      //     builder: (_, snap) {
      //       return Aria2SettingsView(
      //         controller: controller,
      //         groups: [
      //           Aria2Group.ALL,
      //         ],
      //         loadSettingValues: () async{
      //           var response = await aria2API.setting.getGlobalOption();
      //           return response.result;
      //         },
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
