import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';
import 'package:bt_service_manager/clients/aria2/widgets/settings.dart';
import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
import 'package:bt_service_manager/net/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 首页
* @author jtechjh
* @Time 2021/4/29 4:22 PM
*/
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

/*
* 首页状态
* @author jtechjh
* @Time 2021/4/29 4:24 PM
*/
class _HomePageState extends State<HomePage> {

  QBAPI qbAPI;
  Aria2API aria2API;
  final SettingsViewController _con = SettingsViewController();

  @override
  void initState() {
    super.initState();
    //执行初始化方法
    qbAPI = api.getQB("https://www.jtechnas.club:8090/api/v2");
    aria2API = api.getAria2(
        "https://www.jtechnas.club:6811/jsonrpc", "POST", "18600574971");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              var m = _con.commitOption();
              print("");
            },
          ),
        ],
      ),
      body: Container(
        child: SettingsView(
          controller: _con,
          types: [
            // SettingType.all,
            SettingType.bitTorrent,
          ],
          globalSetting: {
            "dir": "/etc/download",
          },
        ),
        // child: FutureBuilder<Map<String,dynamic>>(
        //   future: aria2API.setting.getGlobalOption(),
        //   builder: (_, snap) {
        //     if (!snap.hasData) return Container();
        //     return SettingsView(
        //       types: [
        //         SettingType.all,
        //         // SettingType.base,
        //       ],
        //       globalSetting: snap.data.result,
        //     );
        //   },
        // ),
      ),
      // body: Container(
      //   child: Center(
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         TextButton(
      //           child: Text("登录"),
      //           onPressed: () {
      //             // qbAPI.auth.login("wuxubaiyang", "JTechJh31858530_");
      //             // aria2API.rpcRequest("aria2.getGlobalStat", paramsJson: ["token:18600574971"]);
      //             aria2API.download.addUri([
      //               "https://th.bing.com/th/id/OIP.UeHraOSVVtS0mwZD6te8DgHaEK?pid=ImgDet&rs=1"
      //             ]);
      //           },
      //         ),
      //         TextButton(
      //           child: Text("注销"),
      //           onPressed: () {
      //             // qbAPI.auth.logout();
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
