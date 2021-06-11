import 'package:bt_service_manager/model/base_model.dart';
import 'package:hive/hive.dart';

part 'global_settings_model.g.dart';

/*
* 全局设置对象
* @author wuxubaiyang
* @Time 2021/6/11 上午9:52
*/
@HiveType(typeId: 200)
// ignore: must_be_immutable
class GlobalSettingsModel extends BaseModel with HiveObjectMixin {
  //全局下行速度等级集合
  @HiveField(30, defaultValue: [])
  List<SpeedLevelItem> globalDownSpeedLevel;

  //全局上行速度等级集合
  @HiveField(31, defaultValue: [])
  List<SpeedLevelItem> globalUpSpeedLevel;

  //单服务下行速度等级集合
  @HiveField(32, defaultValue: [])
  List<SpeedLevelItem> downSpeedLevel;

  //单服务上行速度等级集合
  @HiveField(33, defaultValue: [])
  List<SpeedLevelItem> upSpeedLevel;

  //单服务状态集合
  @HiveField(34, defaultValue: [])
  Map<ServerState, ServerStateItem> serverStates;

  GlobalSettingsModel({
    this.globalDownSpeedLevel,
    this.globalUpSpeedLevel,
    this.downSpeedLevel,
    this.upSpeedLevel,
    this.serverStates,
  });
}

/*
* 速度等级对象
* @author wuxubaiyang
* @Time 2021/6/11 上午9:56
*/
@HiveType(typeId: 220)
// ignore: must_be_immutable
class SpeedLevelItem extends BaseModel {
  //速度
  @HiveField(30, defaultValue: 0)
  num speed;

  //颜色
  @HiveField(31, defaultValue: 0xffffffff)
  int color;

  SpeedLevelItem({
    this.speed,
    this.color,
  });
}

/*
* 服务器状态项
* @author wuxubaiyang
* @Time 2021/6/11 上午9:56
*/
@HiveType(typeId: 221)
// ignore: must_be_immutable
class ServerStateItem extends BaseModel {
  //状态
  @HiveField(30, defaultValue: 0)
  ServerState state;

  //颜色
  @HiveField(31, defaultValue: 0xffffffff)
  int color;

  ServerStateItem({
    this.state,
    this.color,
  });
}

/*
* 服务器连接状态
* @author wuxubaiyang
* @Time 2021/6/11 上午10:12
*/
@HiveType(typeId: 230)
enum ServerState {
  @HiveField(0)
  Disconnected,
  @HiveField(1)
  Connected,
  @HiveField(2)
  Connecting,
}
