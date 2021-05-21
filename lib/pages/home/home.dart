import 'package:bt_service_manager/manage/page_manage.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/home/server_controller.dart';
import 'package:bt_service_manager/pages/home/server_list.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/jimage.dart';
import 'package:bt_service_manager/tools/route.dart';
import 'package:bt_service_manager/tools/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* 首页
* @author jtechjh
* @Time 2021/4/29 4:22 PM
*/
class HomePage extends StatelessWidget {
  //服务控制器
  final controller = Get.put(ServerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitleInfo(),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCreateServerMenu(),
          ),
        ],
      ),
      body: FutureBuilder<List<ServerConfigModel>>(
        future: controller.loadServerList(),
        builder: (_, snap) {
          if (!snap.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ServerListView(
            serverList: snap.data,
          );
        },
      ),
      drawer: _buildDrawerMenu(),
    );
  }

  //构建标题信息
  _buildTitleInfo() {
    double iconSize = 15;
    TextStyle textStyle = TextStyle(
      fontSize: 18,
    );
    return Obx(() {
      var downSpeed = Tools.convertByte(
        controller.totalDownloadSpeed.value,
      );
      var upSpeed = Tools.convertByte(
        controller.totalUploadSpeed,
      );
      return Row(
        children: [
          Icon(
            Icons.download_sharp,
            size: iconSize,
            color: Colors.greenAccent,
          ),
          Text(" $downSpeed  |  ", style: textStyle),
          Icon(
            Icons.upload_sharp,
            size: iconSize,
            color: Colors.amberAccent,
          ),
          Text(" $upSpeed", style: textStyle),
        ],
      );
    });
  }

  //构建侧滑面板
  _buildDrawerMenu() {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Text("aaa"),
            ),
          ]..addAll(List<Widget>.generate(
              _drawerMenuList.length,
              (i) {
                var item = _drawerMenuList[i];
                return ListTile(
                  leading: Icon(item["icon"]),
                  title: Text(item["name"]),
                  onTap: () => item["fun"]?.call(),
                );
              },
            )),
        ),
      ),
    );
  }

  //展示添加服务器菜单
  _showCreateServerMenu() {
    AlertTools.bottomSheet(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_addServerList.length, (i) {
          var item = _addServerList[i];
          return ListTile(
            leading: JImage.assetsIcon(
              item["icon"],
              size: 25,
            ),
            title: Text(item["name"]),
            onTap: () async {
              RouteTools.pop();
              await item["fun"]?.call();

              ///返回的时候判断是否需要刷新列表
            },
          );
        }),
      ),
    );
  }
}

//添加服务按钮功能表
final List<Map<String, dynamic>> _addServerList = [
  {
    "name": "Aria2",
    "icon": serverIcon[ServerType.Aria2],
    "fun": () => PageManage.goCreateAria2Service(),
  },
  {
    "name": "QBitTorrent",
    "icon": serverIcon[ServerType.QBitTorrent],
    "fun": () => PageManage.goCreateQBService(),
  },
  {
    "name": "Transmission",
    "icon": serverIcon[ServerType.Transmission],
    "fun": () => PageManage.goCreateTMService(),
  }
];

//侧滑菜单列表
final List<Map<String, dynamic>> _drawerMenuList = [
  {
    "name": "应用设置",
    "icon": Icons.settings,
    "fun": () async => PageManage.goAppSetting(),
  }
];

//服务器类型与对应的图标
final Map<ServerType, String> serverIcon = {
  ServerType.Aria2: "server_aria2.png",
  ServerType.QBitTorrent: "server_qbittorrent.png",
  ServerType.Transmission: "server_transmission.png",
};
