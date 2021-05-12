import 'package:bt_service_manager/model/base_model.dart';

/*
* 通用设置视图，设置组数据对象
* @author jtechjh
* @Time 2021/5/12 5:04 下午
*/
class SettingGroupModel {
  //组名-索引标记
  String _group;

  //组名
  _SettingTextModel _groupName;

  //组内设置列表
  List<SettingItemModel> _settings;

  String get group => _group;

  _SettingTextModel get groupName => _groupName;

  List<SettingItemModel> get settings => _settings;

  SettingGroupModel.fromJson(data) {
    _group = data["group"];
    _groupName = _SettingTextModel().fromJson(data["groupName"] ?? {});
    _settings = (data["settings"] ?? [])
        .map<SettingItemModel>((it) => SettingItemModel().fromJson(it))
        .toList();
  }
}

//设置项类型参数表
final Map<String, dynamic> _itemParams = {
  "txt": TextSettingParam,
  "sel": SelectSettingParam,
};

/*
* 通用设置视图，设置项数据对象
* @author jtechjh
* @Time 2021/5/12 5:05 下午
*/
class SettingItemModel extends BaseModel {
  //项目名称
  _SettingTextModel _name;

  //关键字
  String _key;

  //设置类型
  String _type;

  //提醒文本
  _SettingTextModel _alert;

  //信息文本
  _SettingTextModel _info;

  //单位文本
  _SettingTextModel _unit;

  //子项详情相关
  dynamic _param;

  _SettingTextModel get name => _name;

  String get key => _key;

  String get type => _type;

  _SettingTextModel get alert => _alert;

  _SettingTextModel get info => _info;

  _SettingTextModel get unit => _unit;

  dynamic get param => _param;

  //判断类型是否为文本
  bool get isText => _type == "txt";

  //判断类型是否为选择
  bool get isSelect => _type == "sel";

  //判断类型是否为开关
  bool get isSwitch => _type == "swt";

  @override
  fromJson(data) {
    _name = _SettingTextModel().fromJson(data["name"] ?? {});
    _key = data["key"];
    _type = data["type"];
    _alert = _SettingTextModel().fromJson(data["alert"] ?? {});
    _info = _SettingTextModel().fromJson(data["info"] ?? {});
    _unit = _SettingTextModel().fromJson(data["unit"] ?? {});
    _param = _itemParams[_type]().formJson(data["param"]);
  }

  @override
  toJson() {}
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

  @override
  fromJson(data) {
    _type = data["type"];
    _split = data["split"];
  }

  @override
  toJson() {}
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

  @override
  fromJson(data) {
    _items = (data["items"] ?? [])
        .map<SelectSettingParamItem>(
            (it) => SelectSettingParamItem().fromJson(it))
        .toList();
  }

  @override
  toJson() {}
}

/*
* 选择类型的子项详细参数-子项
* @author jtechjh
* @Time 2021/5/12 5:29 下午
*/
class SelectSettingParamItem extends BaseModel {
  //名称
  _SettingTextModel _name;

  //值
  dynamic _value;

  _SettingTextModel get name => _name;

  dynamic get value => _value;

  @override
  fromJson(data) {
    _name = _SettingTextModel().fromJson(data["name"] ?? {});
    _value = data["value"];
  }

  @override
  toJson() {}
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
class _SettingTextModel extends BaseModel {
  //中文
  String _cn;

  //英文
  String _en;

  //获取文本
  ///待完善国际化部分
  String get text => _cn;

  String get cn => _cn;

  String get en => _en;

  @override
  fromJson(data) {
    _cn = data["cn"];
    _en = data["en"];
  }

  @override
  toJson() {}
}
