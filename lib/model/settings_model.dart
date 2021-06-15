/*
* 通用设置视图，设置组数据对象
* @author jtechjh
* @Time 2021/5/12 5:04 下午
*/
class SettingGroupModel {
  //组名-索引标记
  String _group;

  //组名
  SettingTextModel _groupName;

  //组内设置列表
  List<SettingItemModel> _settings;

  String get group => _group;

  SettingTextModel get groupName => _groupName;

  List<SettingItemModel> get settings => _settings;

  SettingGroupModel.fromJson(data) {
    _group = data["group"];
    if (null != data["groupName"]) {
      _groupName = SettingTextModel.fromJson(data["groupName"]);
    }
    _settings = [];
    (data["settings"] ?? []).forEach((it) {
      _settings.add(SettingItemModel.fromJson(it));
    });
  }
}

//设置项类型参数表
final Map<String, Function> _itemParams = {
  "txt": (json) => TextSettingParam.fromJson(json),
  "sel": (json) => SelectSettingParam.fromJson(json),
  "swt": (json) => SwitchSettingParam.fromJson(json),
  "ctm": (json) => json,
};

/*
* 通用设置视图，设置项数据对象
* @author jtechjh
* @Time 2021/5/12 5:05 下午
*/
class SettingItemModel {
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

  //判断类型是否为自定义
  bool get isCustom => _type == "ctm";

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
    if (null != data["param"]) {
      _param = _itemParams[_type](data["param"] ?? {});
    }
  }
}

/*
* 文本类型的子项详细参数
* @author jtechjh
* @Time 2021/5/12 5:24 下午
*/
// ignore: must_be_immutable
class TextSettingParam extends _BaseItemParam {
  //文本类型
  String _type;

  //文本分割方式
  String _split;

  //可控开关key
  String _enableKey;

  String get type => _type;

  String get split => _split;

  String get enableKey => _enableKey;

  //判断是否存在可控开关
  bool get hasEnableKey => null != _enableKey;

  //判断是否为集合
  bool get isList => _type == "li";

  //判断是否为密码
  bool get isPassword => _type == "pwd";

  TextSettingParam.fromJson(data) {
    _type = data["type"];
    _split = data["split"];
    _enableKey = data["enableKey"];
  }
}

/*
* 选择类型的子项详细参数
* @author jtechjh
* @Time 2021/5/12 5:26 下午
*/
// ignore: must_be_immutable
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
// ignore: must_be_immutable
class SwitchSettingParam extends _BaseItemParam {
  SwitchSettingParam.fromJson(data) {}
}

/*
* 选择类型的子项详细参数-子项
* @author jtechjh
* @Time 2021/5/12 5:29 下午
*/
class SelectSettingParamItem {
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
abstract class _BaseItemParam {}

/*
* 设置文本对象-国际化
* @author jtechjh
* @Time 2021/5/12 5:08 下午
*/
class SettingTextModel {
  //中文
  String _cn;

  //英文
  String _en;

  //默认值
  String _def;

  //获取文本
  ///待完善国际化部分
  String get text => _cn ?? _def;

  String get cn => _cn;

  String get en => _en;

  String get def => _def;

  SettingTextModel.fromJson(data) {
    _cn = data["cn"];
    _en = data["en"];
    _def = data["def"];
  }
}
