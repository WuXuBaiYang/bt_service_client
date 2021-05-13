import 'package:bt_service_manager/model/base_model.dart';

/*
* 通用设置视图，设置组数据对象
* @author jtechjh
* @Time 2021/5/12 5:04 下午
*/
class SettingGroupModel {
  //组名-索引标记
  Aria2Group _group;

  //组名
  SettingTextModel _groupName;

  //组内设置列表
  List<SettingItemModel> _settings;

  Aria2Group get group => _group;

  SettingTextModel get groupName => _groupName;

  List<SettingItemModel> get settings => _settings;

  SettingGroupModel.fromJson(data) {
    _group = _getGroupEnum(data["group"]);
    if (null != data["groupName"]) {
      _groupName = SettingTextModel.fromJson(data["groupName"]);
    }
    _settings = [];
    (data["settings"] ?? []).forEach((it) {
      _settings.add(SettingItemModel.fromJson(it));
    });
  }

  //转换组类别的枚举类型
  _getGroupEnum(String text) {
    switch (text) {
      case "base":
        return Aria2Group.Base;
      case "httpFtpSFtp":
        return Aria2Group.HttpFtpSFtp;
      case "http":
        return Aria2Group.Http;
      case "ftpSFtp":
        return Aria2Group.FtpSFtp;
      case "bitTorrent":
        return Aria2Group.BitTorrent;
      case "metaLink":
        return Aria2Group.MetaLink;
      case "rpc":
        return Aria2Group.RPC;
      case "advanced":
        return Aria2Group.Advanced;
      case "all":
        return Aria2Group.ALL;
    }
  }
}

//设置项类型参数表
final Map<String, Function> _itemParams = {
  "txt": (json) => TextSettingParam.fromJson(json),
  "sel": (json) => SelectSettingParam.fromJson(json),
  "swt": (json) => SwitchSettingParam.fromJson(json),
};

/*
* 通用设置视图，设置项数据对象
* @author jtechjh
* @Time 2021/5/12 5:05 下午
*/
class SettingItemModel extends BaseModel {
  //项目名称
  SettingTextModel _name;

  //关键字
  String _key;

  //设置类型
  String _type;

  //提醒文本
  SettingTextModel _alert;

  //信息文本
  SettingTextModel _info;

  //单位文本
  SettingTextModel _unit;

  //子项详情相关
  dynamic _param;

  SettingTextModel get name => _name;

  String get key => _key;

  String get type => _type;

  SettingTextModel get alert => _alert;

  SettingTextModel get info => _info;

  SettingTextModel get unit => _unit;

  dynamic get param => _param;

  //判断类型是否为文本
  bool get isText => _type == "txt";

  //判断类型是否为选择
  bool get isSelect => _type == "sel";

  //判断类型是否为开关
  bool get isSwitch => _type == "swt";

  SettingItemModel.fromJson(data) {
    _key = data["key"];
    _type = data["type"];
    if (null != data["name"]) {
      _name = SettingTextModel.fromJson(data["name"]);
    }
    if (null != data["alert"]) {
      _alert = SettingTextModel.fromJson(data["alert"]);
    }
    if (null != data["info"]) {
      _info = SettingTextModel.fromJson(data["info"]);
    }
    if (null != data["unit"]) {
      _unit = SettingTextModel.fromJson(data["unit"]);
    }
    try {
      _param = _itemParams[_type](data["param"] ?? {});
    } catch (e) {
      print("");
    }
  }
}

/*
* 文本类型的子项详细参数
* @author jtechjh
* @Time 2021/5/12 5:24 下午
*/
class TextSettingParam extends _BaseItemParam {
  //文本类型
  String _type;

  //文本分割方式
  String _split;

  String get type => _type;

  String get split => _split;

  //判断是否为集合
  bool get isList => _type == "li";

  //判断是否为密码
  bool get isPassword => _type == "pwd";

  TextSettingParam.fromJson(data) {
    _type = data["type"];
    _split = data["split"];
  }
}

/*
* 选择类型的子项详细参数
* @author jtechjh
* @Time 2021/5/12 5:26 下午
*/
class SelectSettingParam extends _BaseItemParam {
  //选项集合
  List<SelectSettingParamItem> _items;

  List<SelectSettingParamItem> get items => _items;

  SelectSettingParam.fromJson(data) {
    _items = [];
    (data["items"] ?? []).forEach((it) {
      _items.add(SelectSettingParamItem.fromJson(it));
    });
  }
}

/*
* 开关类型的子项详细参数
* @author jtechjh
* @Time 2021/5/13 2:52 下午
*/
class SwitchSettingParam extends _BaseItemParam {
  SwitchSettingParam.fromJson(data) {}
}

/*
* 选择类型的子项详细参数-子项
* @author jtechjh
* @Time 2021/5/12 5:29 下午
*/
class SelectSettingParamItem extends BaseModel {
  //名称
  SettingTextModel _name;

  //值
  dynamic _value;

  SettingTextModel get name => _name;

  dynamic get value => _value;

  SelectSettingParamItem.fromJson(data) {
    if (null != data["name"]) {
      _name = SettingTextModel.fromJson(data["name"]);
    }
    _value = data["value"];
  }
}

/*
* 设置子项的详细参数基类
* @author jtechjh
* @Time 2021/5/12 5:24 下午
*/
abstract class _BaseItemParam extends BaseModel {}

/*
* 设置文本对象-国际化
* @author jtechjh
* @Time 2021/5/12 5:08 下午
*/
class SettingTextModel extends BaseModel {
  //中文
  String _cn;

  //英文
  String _en;

  //获取文本
  ///待完善国际化部分
  String get text => _cn;

  String get cn => _cn;

  String get en => _en;

  SettingTextModel.fromJson(data) {
    _cn = data["cn"];
    _en = data["en"];
  }
}

/*
* aria2设置项分组
* @author jtechjh
* @Time 2021/5/13 1:35 下午
*/
enum Aria2Group {
  Base,
  HttpFtpSFtp,
  Http,
  FtpSFtp,
  BitTorrent,
  MetaLink,
  RPC,
  Advanced,
  ALL,
}

/*
* 扩展aria2设置项分组
* @author jtechjh
* @Time 2021/5/13 1:39 下午
*/
extension Aria2GroupExtension on Aria2Group {
  //获取枚举对应的文本
  String get text {
    switch (this) {
      case Aria2Group.Base:
        return "base";
      case Aria2Group.HttpFtpSFtp:
        return "httpFtpSFtp";
      case Aria2Group.Http:
        return "http";
      case Aria2Group.FtpSFtp:
        return "ftpSFtp";
      case Aria2Group.BitTorrent:
        return "bitTorrent";
      case Aria2Group.MetaLink:
        return "metaLink";
      case Aria2Group.RPC:
        return "rpc";
      case Aria2Group.Advanced:
        return "advanced";
      case Aria2Group.ALL:
        return "all";
    }
    return "";
  }
}
