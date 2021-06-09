import 'package:bt_service_manager/manage/page_manage.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/home/server_controller.dart';
import 'package:bt_service_manager/pages/home/server_list.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/jimage.dart';
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
      // appBar: AppBar(
      //   title: _buildTitleInfo(),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.add),
      //       onPressed: () => _showCreateServerMenu(),
      //     ),
      //   ],
      // ),
      // body: ServerListView(
      //   serverController: controller,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: _buildTitleInfo(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showCreateServerMenu(),
              ),
            ],
          ),
          ServerListView(
            serverController: controller,
          ),
        ],
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

  //构建顶部过滤信息
  _buildFilterInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(
            Icons.cloud,
            size: 15,
            color: Colors.blueAccent,
          ),
          SizedBox(width: 6),
          Obx(() => Text("${controller.servers.length}")),
          SizedBox(width: 6),
          _buildServerItemsCount(),
        ],
      ),
    );
  }

  //构建服务器子项数量
  _buildServerItemsCount() {
    return Obx(() => FutureBuilder<List<Widget>>(
          future: Future<List<Widget>>.sync(() {
            Map counter = {};
            controller.servers.forEach((item) {
              counter[item.type] = (counter[item.type] ?? 0) + 1;
            });
            List<Widget> children = [];
            counter.forEach((k, v) => children.addAll([
                  JImage.assetsIcon(
                    ServerConfigModel.getServerAssetsIcon(k),
                    size: 15,
                    circle: true,
                  ),
                  Text("$v "),
                ]));
            if (children.isNotEmpty) {
              children
                ..insert(0, Text("( "))
                ..add(Text(")"));
            }
            return children;
          }),
          builder: (_, snap) {
            if (!snap.hasData) return Container();
            return Row(children: snap.data);
          },
        ));
  }

  //展示添加服务器菜单
  _showCreateServerMenu() {
    JAlert.showBottomSheetMenu(
      items: List.generate(_addServerList.length, (i) {
        var item = _addServerList[i];
        return BottomSheetMenuItem(
          leading: JImage.assetsIcon(
            item["icon"],
            size: 25,
          ),
          title: item["name"],
          onTap: (i) async {
            await item["fun"]?.call();
            controller.loadServerList();
          },
        );
      }),
    );
  }
}

//添加服务按钮功能表
final List<Map<String, dynamic>> _addServerList = [
  {
    "name": "Aria2",
    "icon": ServerConfigModel.getServerAssetsIcon(ServerType.Aria2),
    "fun": () => PageManage.goModifyAria2Service(),
  },
  {
    "name": "QBitTorrent",
    "icon": ServerConfigModel.getServerAssetsIcon(ServerType.QBitTorrent),
    "fun": () => PageManage.goModifyQBService(),
  },
  {
    "name": "Transmission",
    "icon": ServerConfigModel.getServerAssetsIcon(ServerType.Transmission),
    "fun": () => PageManage.goModifyTMService(),
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
