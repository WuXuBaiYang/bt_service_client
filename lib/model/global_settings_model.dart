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
  GlobalSettingsModel.fromJson(json) {
    globalDownSpeedLevel = fromList(json["globalDownSpeedLevel"],
        from: (it) => SpeedLevelItem.fromJson(it));
    globalUpSpeedLevel = fromList(json["globalUpSpeedLevel"],
        from: (it) => SpeedLevelItem.fromJson(it));
    downSpeedLevel = fromList(json["downSpeedLevel"],
        from: (it) => SpeedLevelItem.fromJson(it));
    upSpeedLevel = fromList(json["upSpeedLevel"],
        from: (it) => SpeedLevelItem.fromJson(it));
    serverStates = fromMap(json["serverStates"],
        from: (k, v) => {convertState(k): ServerStateItem.fromJson(v)});
  }

  @override
  toJson() => {
        "globalDownSpeedLevel": toList(globalDownSpeedLevel),
        "globalUpSpeedLevel": toList(globalUpSpeedLevel),
        "downSpeedLevel": toList(downSpeedLevel),
        "upSpeedLevel": toList(upSpeedLevel),
        "serverStates": toMap<ServerState, ServerStateItem>(serverStates,
            to: (k, v) => {k.text: v.toJson()}),
      };
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
  Color color;

  SpeedLevelItem({
    this.speed,
    this.color,
  });

  SpeedLevelItem.fromJson(json) {
    speed = json["speed"];
    color = Color(json["color"]);
  }

  @override
  toJson() => {
        "speed": speed,
        "color": color.value,
      };
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
  Color color;

  //线条宽度
  double width;

  ServerStateItem({
    this.state,
    this.color,
    this.width,
  });

  ServerStateItem.fromJson(json) {
    state = convertState(json["state"]);
    color = Color(json["color"]);
    width = json["width"];
  }

  @override
  toJson() => {
        "state": state.text,
        "color": color.value,
        "width": width,
      };
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

//转换text
ServerState convertState(String text) {
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
