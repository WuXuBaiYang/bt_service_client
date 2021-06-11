import 'package:bt_service_manager/model/base_model.dart';
import 'package:flutter/cupertino.dart';

/*
* 全局设置对象
* @author wuxubaiyang
* @Time 2021/6/11 上午9:52
*/
// ignore: must_be_immutable
class GlobalSettingsModel extends BaseModel {
  //全局下行速度等级集合
  List<SpeedLevelItem> globalDownSpeedLevel;

  //全局上行速度等级集合
  List<SpeedLevelItem> globalUpSpeedLevel;

  //单服务下行速度等级集合
  List<SpeedLevelItem> downSpeedLevel;

  //单服务上行速度等级集合
  List<SpeedLevelItem> upSpeedLevel;

  //单服务状态集合
  Map<ServerState, ServerStateItem> serverStates;

  GlobalSettingsModel({
    this.globalDownSpeedLevel,
    this.globalUpSpeedLevel,
    this.downSpeedLevel,
    this.upSpeedLevel,
    this.serverStates,
  });

  @override
  fromJson(json) {}

  @override
  toJson() {
    // TODO: implement toJson
    return super.toJson();
  }
}

/*
* 速度等级对象
* @author wuxubaiyang
* @Time 2021/6/11 上午9:56
*/
// ignore: must_be_immutable
class SpeedLevelItem extends BaseModel {
  //速度
  num speed;

  //颜色
  int color;

  SpeedLevelItem({
    this.speed,
    this.color,
  });

  @override
  fromJson(json) {
    speed = json["speed"];
    color = json["color"];
  }

  @override
  toJson() {
    return {
      "speed": speed,
      "color": color,
    };
  }
}

/*
* 服务器状态项
* @author wuxubaiyang
* @Time 2021/6/11 上午9:56
*/
// ignore: must_be_immutable
class ServerStateItem extends BaseModel {
  //状态
  ServerState state;

  //颜色
  int color;

  ServerStateItem({
    this.state,
    this.color,
  });

  @override
  fromJson(json) {
    state = _convertState(json["state"]);
    color = json["color"];
  }

  //转换text
  ServerState _convertState(String text) {
    switch (text) {
      case "disconnected":
        return ServerState.Disconnected;
      case "connected":
        return ServerState.Connected;
      case "connecting":
        return ServerState.Connecting;
    }
    return ServerState.Disconnected;
  }

  @override
  toJson() {
    return {
      "state": state.text,
      "color": color,
    };
  }
}

/*
* 服务器连接状态
* @author wuxubaiyang
* @Time 2021/6/11 上午10:12
*/
enum ServerState {
  Disconnected,
  Connected,
  Connecting,
}

/*
* 服务器链接状态扩展
* @author wuxubaiyang
* @Time 2021/6/11 上午11:23
*/
extension ServerStateExtension on ServerState {
  String get text {
    switch (this) {
      case ServerState.Disconnected:
        return "disconnected";
      case ServerState.Connected:
        return "connected";
      case ServerState.Connecting:
        return "connecting";
    }
    return "";
  }
}
