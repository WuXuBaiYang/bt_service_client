import 'package:bt_service_manager/model/base_model.dart';
import 'package:flutter/widgets.dart';

/*
* 选项配置数据对象
* @author wuxubaiyang
* @Time 2021/6/10 下午4:51
*/
// ignore: must_be_immutable
class OptionItem extends BaseModel {
  //名称
  final String name;

  //图标
  final Widget icon;

  //点击事件
  final Function tapFun;

  //判断是否存在图标
  bool get hasIcon => null != icon;

  //判断是否存在点击事件
  bool get hasTapFun => null != tapFun;

  //执行点击事件
  runTapFun() => tapFun?.call();

  OptionItem({
    this.name,
    Widget icon,
    IconData iconData,
    double iconSize,
    Color iconColor,
    this.tapFun,
  }) : icon = icon ??
            (null != iconData
                ? Icon(iconData, size: iconSize, color: iconColor)
                : null);
}
