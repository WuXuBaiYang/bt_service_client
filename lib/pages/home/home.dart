import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
import 'package:bt_service_manager/manage/database/database_manage.dart';
import 'package:bt_service_manager/model/base_model.dart';
import 'package:bt_service_manager/model/server_config/aria2_config_model.dart';
import 'package:bt_service_manager/model/server_config/qb_config_model.dart';
import 'package:bt_service_manager/net/api.dart';
import 'package:bt_service_manager/widgets/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
        onPressed: () async {
          try{
            var config = Aria2ConfigModel.create(
              Protocol.HTTPS,
              "www.jtechnas.club",
              6811,
              "/jsonrpc",
              HTTPMethod.POST,
              "18600574971",
            );
            await dbManage.server.addServerConfig(config);
            var a = api.getAria2(config);
           var b=await  a.setting.getGlobalOption();
           print("");
            // Future.delayed(Duration(milliseconds: 1000)).then((value)async{
            //   config.port = 100;
            //   await config.save();
            // });
          }catch(e){
            print("");
          }
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
