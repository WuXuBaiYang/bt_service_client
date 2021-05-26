import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/pages/home/home.dart';
import 'package:bt_service_manager/tools/jimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 服务器列表视图
* @author jtechjh
* @Time 2021/5/19 2:15 下午
*/
class ServerListView extends StatefulWidget {
  //服务器配置集合
  final List<ServerConfigModel> serverList;

  const ServerListView({Key key, @required this.serverList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ServerListViewState();
}

/*
* 服务器列表视图-状态
* @author jtechjh
* @Time 2021/5/19 2:16 下午
*/
class _ServerListViewState extends State<ServerListView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          _buildFilterInfo(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.serverList.length,
              itemBuilder: (_, i) => _buildServerItem(widget.serverList[i]),
            ),
          ),
        ],
      ),
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
                Text("${widget.serverList.length}"),
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
    widget.serverList.forEach((item) {
      counter[item.type] = (counter[item.type] ?? 0) + 1;
    });
    var children = List<Widget>.generate(counter.length, (i) {
      var key = counter.keys.elementAt(i);
      var value = counter[key];
      return Row(
        children: [
          JImage.assetsIcon(ServerConfigModel.getServerAssetsIcon(key),
              size: 15),
          Text("$value"),
        ],
      );
    });
    if (children.isNotEmpty) {
      children
        ..insert(0, Text("("))
        ..add(Text(")"));
    }
    return children;
  }

  //构建服务器子项
  _buildServerItem(ServerConfigModel model) {
    return Card(
      child: Text.rich(
        TextSpan(
          text: model.alias,
          children: [
            TextSpan(
                text: "(${model.type.text})",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                )),
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
