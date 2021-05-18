import 'package:bt_service_manager/manage/page_manage.dart';
import 'package:bt_service_manager/pages/home/server_controller.dart';
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
  final serverControl = Get.put(ServerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitleInfo(),
        actions: [
          //添加服务器按钮
          _buildAddServerAction(),
        ],
      ),
      body: Container(),
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
        serverControl.totalDownloadSpeed.value,
      );
      var upSpeed = Tools.convertByte(
        serverControl.totalUploadSpeed,
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
      child: Container(
        // color: Colors.red,
      ),
    );
  }

  //添加服务按钮功能表
  final List<Map<String, dynamic>> _addServerList = [
    {
      "name": "Aria2",
      "icon": "server_aria2.png",
      "fun": () async => PageManage.goAddAria2Service(),
    },
    {
      "name": "QBitTorrent",
      "icon": "server_qbittorrent.png",
      "fun": () async => PageManage.goAddQBService(),
    },
    {
      "name": "Transmission",
      "icon": "server_transmission.png",
      "fun": () async => PageManage.goAddTMService(),
    }
  ];

  //构建添加服务器按钮
  _buildAddServerAction() {
    return PopupMenuButton<int>(
      tooltip: "添加服务器",
      icon: Icon(Icons.add),
      itemBuilder: (_) => List.generate(_addServerList.length, (i) {
        var item = _addServerList[i];
        return PopupMenuItem<int>(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: JImage.assetsIcon(
              item["icon"],
              size: 25,
            ),
            title: Text(item["name"]),
          ),
          value: i,
        );
      }),
      onSelected: (i) async {
        await _addServerList[i]["fun"]();

        ///刷新列表
      },
    );
  }
}
