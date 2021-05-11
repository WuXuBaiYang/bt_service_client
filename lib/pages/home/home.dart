import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';
import 'package:bt_service_manager/clients/aria2/model/response.dart';
import 'package:bt_service_manager/clients/aria2/widgets/settings.dart';
import 'package:bt_service_manager/net/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 首页
* @author jtechjh
* @Time 2021/4/29 4:22 PM
*/
class HomePage extends StatelessWidget {
  // QBAPI qbAPI = api.getQB("https://www.jtechnas.club:8090/api/v2");
  Aria2API aria2API = api.getAria2(
      "https://www.jtechnas.club:6811/jsonrpc", "POST", "18600574971");

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
              var m = controller.commitOption();
              print("");
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<Aria2ResponseModel>(
          future: aria2API.setting.getGlobalOption(),
          builder: (_, snap) {
            if (!snap.hasData) return Container();
            return SettingsView(
              types: [
                SettingType.all,
                // SettingType.base,
                // SettingType.bitTorrent,
              ],
              globalSetting: snap.data.result,
              controller: controller,
            );
          },
        ),
      ),
    );
  }
}
