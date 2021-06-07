import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/home/server_controller.dart';
import 'package:bt_service_manager/tools/jimage.dart';
import 'package:bt_service_manager/tools/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*
* 服务器列表视图
* @author jtechjh
* @Time 2021/5/19 2:15 下午
*/
class ServerListView extends StatefulWidget {
  //首页控制器
  final ServerController serverController;

  const ServerListView({
    Key key,
    @required this.serverController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ServerListViewState();
}

/*
* 服务器列表视图-状态
* @author jtechjh
* @Time 2021/5/19 2:16 下午
*/
class _ServerListViewState extends State<ServerListView> {
  //服务器列表子项高度
  final double serverItemHeight = 120;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterInfo(),
        Expanded(
          child: Obx(
            () => SmartRefresher(
              controller: widget.serverController.refreshController,
              onRefresh: () => widget.serverController.loadServerList(),
              enablePullDown: true,
              child: ListView.builder(
                shrinkWrap: true,
                cacheExtent: serverItemHeight,
                itemCount: widget.serverController.servers.length,
                itemBuilder: (_, i) {
                  var model = widget.serverController.servers[i];
                  return _buildServerItem(model);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  //记录当前过滤类型
  FilterType _filterType = FilterType.List;

  //构建顶部过滤信息
  _buildFilterInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.cloud,
                  size: 15,
                  color: Colors.blueAccent,
                ),
                SizedBox(width: 6),
                Text("${widget.serverController.servers.length}"),
                SizedBox(width: 6),
              ]..addAll(_buildServerItemsCount()),
            ),
          ),
          DropdownButton<FilterType>(
            value: _filterType,
            items: List.generate(_filterMenu.length, (i) {
              var item = _filterMenu[i];
              return DropdownMenuItem(
                value: item["type"],
                child: Row(children: [
                  Icon(item["icon"]),
                  SizedBox(width: 8),
                  Text(item["name"]),
                ]),
              );
            }),
            onChanged: (v) {
              setState(() => _filterType = v);
            },
          ),
        ],
      ),
    );
  }

  //构建服务器子项数量
  _buildServerItemsCount() {
    Map counter = {};
    widget.serverController.servers.forEach((item) {
      counter[item.type] = (counter[item.type] ?? 0) + 1;
    });
    var children = List<Widget>.generate(counter.length, (i) {
      var key = counter.keys.elementAt(i);
      var value = counter[key];
      return Row(
        children: [
          JImage.assetsIcon(ServerConfigModel.getServerAssetsIcon(key),
              size: 15),
          Text("$value "),
        ],
      );
    });
    if (children.isNotEmpty) {
      children
        ..insert(0, Text("( "))
        ..add(Text(")"));
    }
    return children;
  }

  //构建服务器子项
  _buildServerItem(ServerConfigModel config) {
    return Container(
      height: serverItemHeight,
      margin: EdgeInsets.symmetric(
        horizontal: 15,
      ).copyWith(left: 30, bottom: 8),
      child: Card(
        child: OverflowBox(
          alignment: Alignment.centerRight,
          maxHeight: serverItemHeight,
          maxWidth: Tools.screenWidth,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                _buildServerItemLogo(config),
                SizedBox(width: 8),
                _buildServerItemContent(config),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //构建服务子项logo
  _buildServerItemLogo(ServerConfigModel config) {
    return Card(
      shape: config.logoCircle
          ? CircleBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
      child: Padding(
        padding: EdgeInsets.all(3),
        child: config.hasCustomLogo
            ? JImage.file(
                config.logoPath,
                size: 45,
                circle: config.logoCircle,
                radius: 4,
              )
            : JImage.assetsIcon(
                config.defaultAssetsIcon,
                size: 45,
              ),
      ),
    );
  }

  //构建服务子项内容
  _buildServerItemContent(ServerConfigModel config) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8).copyWith(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(config.alias)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//过滤方法表
final List<Map<String, dynamic>> _filterMenu = [
  {
    "name": "列表",
    "icon": Icons.list,
    "type": FilterType.List,
  }
];

//过滤类型枚举
enum FilterType {
  List,
}
