import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
import 'package:bt_service_manager/manage/routes/page_manage.dart';
import 'package:bt_service_manager/model/global_settings_model.dart';
import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:bt_service_manager/net/api.dart';
import 'package:bt_service_manager/pages/home/server_controller.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/jimage.dart';
import 'package:bt_service_manager/tools/route.dart';
import 'package:bt_service_manager/tools/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reorderables/reorderables.dart';

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
  final serverItemHeight = 110.0;

  //服务器列表子项logo尺寸
  final serverItemLogoSize = 60.0;

  //刷新控制器
  final refreshController = RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        onRefresh: () => widget.serverController
            .loadServerList()
            .whenComplete(() => refreshController.refreshCompleted()),
        child: CustomScrollView(
          slivers: [
            ReorderableSliverList(
              delegate: ReorderableSliverChildBuilderDelegate(
                (_, i) {
                  var model = widget.serverController.servers[i];
                  return _buildServerItem(model, i);
                },
                childCount: widget.serverController.servers.length,
              ),
              onReorder: (oldIndex, newIndex) =>
                  widget.serverController.switchConfig(oldIndex, newIndex),
              buildDraggableFeedback: (_, constraints, child) => child,
            ),
          ],
        ),
      ),
    );
  }

  //构建服务器子项
  _buildServerItem(ServerConfigModel config, int index) {
    return Dismissible(
      key: Key(config.id),
      direction: DismissDirection.endToStart,
      child: _buildServerItemContent(config),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 35),
        margin: EdgeInsets.only(bottom: 8),
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) async {
        await widget.serverController.removeServer(config);
        var confirm = await AlertTools.snack<bool>(
          "${config.currentName} 已移除",
          button: TextButton(
            child: Text("撤销删除"),
            onPressed: () => RouteTools.pop(false),
          ),
        );
        if (!confirm ?? true) {
          widget.serverController.resumeServer(index, config);
        }
      },
    );
  }

  //构建服务子项logo
  _buildServerItemLogo(ServerConfigModel config) {
    return SizedBox.fromSize(
      size: Size.square(serverItemLogoSize),
      child: Card(
        margin: EdgeInsets.zero,
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
                  // size: serverItemLogoSize,
                  circle: config.logoCircle,
                  radius: 4,
                )
              : JImage.assetsIcon(
                  config.defaultAssetsIcon,
                  // size: serverItemLogoSize,
                  circle: true,
                ),
        ),
      ),
    );
  }

  //构建服务子项内容
  _buildServerItemContent(ServerConfigModel config) {
    double iconSize = 14;
    TextStyle textStyle = TextStyle(
      fontSize: 16,
    );

    ///这里需要查询到当前服务信息
    var downSpeed = 0;
    var upSpeed = 0;
    var state = ServerState.Connected;

    ///这里需要查询到当前服务信息
    var stateModel = widget.serverController.getServerStateModel(state);
    return Material(
      child: Container(
        margin: EdgeInsets.only(bottom: 8, left: 8),
        width: Tools.screenWidth,
        height: serverItemHeight,
        child: Stack(
          children: [
            Card(
              margin: EdgeInsets.only(left: serverItemLogoSize / 2),
              child: SizedBox(
                width: Tools.screenWidth,
                height: serverItemHeight,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _buildServerItemLogo(config),
              title: Row(
                children: [
                  Icon(
                    _getServerStateIcon(stateModel.state),
                    color: stateModel.color,
                    size: stateModel.size,
                  ),
                  SizedBox(width: 8),
                  Expanded(child: Text(config.currentName, maxLines: 1)),
                  IconButton(
                    iconSize: 15,
                    splashRadius: 20,
                    color: Colors.grey,
                    icon: Icon(Icons.edit_outlined),
                    visualDensity: VisualDensity.comfortable,
                    onPressed: () async {
                      if (null != await _goModifyPage(config)) {
                        widget.serverController.loadServerList();
                      }
                    },
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(config.baseUrl),
                  Row(
                    children: [
                      Icon(
                        Icons.download_sharp,
                        size: iconSize,
                        color: widget.serverController
                            .getDownSpeedColor(downSpeed),
                      ),
                      Text(" $downSpeed  |  ", style: textStyle),
                      Icon(
                        Icons.upload_sharp,
                        size: iconSize,
                        color: widget.serverController.getUpSpeedColor(upSpeed),
                      ),
                      Text(" $upSpeed", style: textStyle),
                      Expanded(child: SizedBox()),
                      Visibility(
                        visible: _needLogin(config),
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: IconButton(
                          iconSize: 15,
                          splashRadius: 20,
                          color: Colors.grey,
                          icon: Icon(Icons.login),
                          visualDensity: VisualDensity.comfortable,
                          onPressed: () => _goLoginPage(config),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //判断是否需要登录
  bool _needLogin(ServerConfigModel config) {
    if (config.type == ServerType.QBitTorrent) {
      return !api.getClientApi<QBAPI>(config).hasCookie;
    }
    return false;
  }

  //需要登录的服务页面跳转
  _goLoginPage(ServerConfigModel config) async {
    if (config.type == ServerType.QBitTorrent) {
      await pageManage.qb.goLogin(config);
    }
    widget.serverController.loadServerList();
  }

  //根据连接状态获取图标
  IconData _getServerStateIcon(ServerState state) {
    switch (state) {
      case ServerState.Disconnected:
        return Icons.link_off;
      case ServerState.Connected:
        return Icons.link;
      case ServerState.Connecting:
        return Icons.link;
    }
    return Icons.error;
  }

  //跳转到编辑页面
  _goModifyPage(ServerConfigModel config) {
    switch (config.type) {
      case ServerType.Aria2:
        return pageManage.app.goModifyAria2Service(config: config);
      case ServerType.Transmission:
        return pageManage.app.goModifyTMService(config: config);
      case ServerType.QBitTorrent:
        return pageManage.app.goModifyQBService(config: config);
      default:
        return;
    }
  }
}
