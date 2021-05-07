import 'package:bt_service_manager/clients/aria2/apis/aria2_api.dart';
import 'package:bt_service_manager/net/api.dart';
import 'package:flutter/material.dart';

import 'clients/qbittorrent/apis/qb_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BT服务管理",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}

/*
* 启动页
* @author jtechjh
* @Time 2021/4/29 4:06 PM
*/
class SplashPage extends StatelessWidget {
  QBAPI qbAPI;
  Aria2API aria2API;

  SplashPage() {
    //执行初始化方法
    qbAPI = api.getQB("https://www.jtechnas.club:8090/api/v2");
    aria2API = api.getAria2(
        "https://www.jtechnas.club:6811/jsonrpc", "POST", "18600574971");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: Text("登录"),
                onPressed: () {
                  // qbAPI.auth.login("wuxubaiyang", "JTechJh31858530_");
                  // aria2API.rpcRequest("aria2.getGlobalStat", paramsJson: ["token:18600574971"]);
                  aria2API.download.addUri([
                    "https://th.bing.com/th/id/OIP.UeHraOSVVtS0mwZD6te8DgHaEK?pid=ImgDet&rs=1"
                  ]);
                },
              ),
              TextButton(
                child: Text("注销"),
                onPressed: () {
                  // qbAPI.auth.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
