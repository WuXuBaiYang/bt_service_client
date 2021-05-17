import 'package:bt_service_manager/clients/aria2/model/response.dart';
import 'package:bt_service_manager/clients/aria2/widgets/aria2_settings.dart';
import 'package:bt_service_manager/clients/transmission/widgets/tm_settings.dart';
import 'package:bt_service_manager/widgets/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 首页
* @author jtechjh
* @Time 2021/4/29 4:22 PM
*/
class HomePage extends StatelessWidget {
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
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {},
      ),
      // body: Container(),
      body: Container(
        child: FutureBuilder<Aria2ResponseModel>(
          // future: aria2API.setting.getGlobalOption(),
          builder: (_, snap) {
            return TMSettingsView(
              controller: controller,
              groups: [
                TMGroup.ALL,
              ],
              loadSettingValues: () async {
                // var response = await aria2API.setting.getGlobalOption();
                // return response.result;
                return {};
              },
            );
          },
        ),
      ),
    );
  }
}
