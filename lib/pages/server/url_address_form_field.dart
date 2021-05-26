import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
* url地址表单项
* @author jtechjh
* @Time 2021/5/25 5:07 下午
*/
class UrlAddressFormField extends StatefulWidget {
  //支持的协议类型集合
  final List<Protocol> protocols;

  //url地址数据对象
  final UrlAddressModel urlAddress;

  //保存事件
  final FormFieldSetter<UrlAddressModel> onSaved;

  UrlAddressFormField({
    @required Protocol protocol,
    @required String hostname,
    @required num port,
    this.protocols = const [],
    this.onSaved,
  }) : urlAddress = UrlAddressModel.build(
          protocol: protocol,
          hostname: hostname,
          port: port,
        );

  @override
  State<StatefulWidget> createState() => _UrlAddressFormFieldState();
}

class _UrlAddressFormFieldState extends State<UrlAddressFormField> {
  @override
  Widget build(BuildContext context) {
    return FormField<UrlAddressModel>(
      initialValue: widget.urlAddress,
      builder: (field) {
        bool isEmpty = field.value.isEmpty;
        bool hasFocus = field.value.hasFocus;
        bool hasHolder = hasFocus || !isEmpty;
        return InputDecorator(
          isEmpty: isEmpty,
          isFocused: hasFocus,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            border: OutlineInputBorder(),
            errorText: field.errorText,
            errorMaxLines: 999,
            labelText: "协议://域名IP:端口号",
          ),
          child: FocusScope(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _buildProtocolItem(field, 3, hasHolder),
                _buildHostnameItem(field, 5, hasHolder),
                _buildPortItem(field, 2, hasHolder),
              ],
            ),
          ),
        );
      },
      validator: _validator,
      onSaved: widget.onSaved,
    );
  }

  //ip地址正则
  final _ipReg = RegExp(r"^\d{0,3}\.\d{0,3}\.\d{0,3}\.\d{0,3}$");

  //域名正则
  final _hostReg = RegExp(
      r"^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$");

  //校验表单数据
  String _validator(UrlAddressModel value) {
    value.clearErr();
    if (null == value.protocol) {
      value.protocolErr = "协议不能为空";
    }
    if (value.hostname?.isEmpty ?? true) {
      value.hostnameErr = "域名/IP不能为空";
    } else if (!_ipReg.hasMatch(value.hostname) &&
        !_hostReg.hasMatch(value.hostname)) {
      value.hostnameErr = "域名/IP格式错误";
    }
    if ((value?.port ?? 0) <= 0) {
      value.portErr = "端口号错误";
    }
    return value.validResult;
  }

  //协议弹出窗口字段
  final _protocolKey = GlobalKey<PopupMenuButtonState>();

  //协议项
  _buildProtocolItem(
      FormFieldState<UrlAddressModel> field, int flex, bool hasHolder) {
    var model = field.value;
    return Flexible(
      flex: flex,
      child: PopupMenuButton<Protocol>(
        key: _protocolKey,
        child: TextField(
          readOnly: true,
          focusNode: model.protocolFocus,
          textInputAction: TextInputAction.next,
          controller: TextEditingController(
            text: model.protocol?.text?.toUpperCase() ?? "",
          ),
          decoration: InputDecoration(
            hintText: hasHolder ? "协议" : "",
          ).applyDefaults(enableTheme),
          onTap: () => _protocolKey.currentState.showButtonMenu(),
        ),
        itemBuilder: (_) => List.generate(widget.protocols.length, (i) {
          var item = widget.protocols[i];
          return PopupMenuItem(
            child: Text(item.text),
            value: item,
          );
        }),
        onSelected: (value) {
          model.protocol = value;
          field.didChange(model);
          //移动到下一个焦点
          FocusScope.of(context).requestFocus(model.hostFocus);
        },
      ),
    );
  }

  //控制器
  TextEditingController _hostController;

  //输入内容正则
  final _hostFilterReg = RegExp(r"[0-9]|\.|[a-zA-Z]");

  //域名/ip
  _buildHostnameItem(
      FormFieldState<UrlAddressModel> field, int flex, bool hasHolder) {
    var model = field.value;
    if (null == _hostController) {
      _hostController = TextEditingController(
        text: model.hostname ?? "",
      );
      model.hostFocus.addListener(() {
        field.didChange(model);
      });
    }
    return Flexible(
      flex: flex,
      child: TextField(
        focusNode: model.hostFocus,
        controller: _hostController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          FilteringTextInputFormatter.allow(_hostFilterReg),
        ],
        decoration: InputDecoration(
          hintText: hasHolder ? "域名/IP" : "",
        ).applyDefaults(enableTheme),
        onChanged: (value) {
          model.hostname = value;
          field.didChange(model);
        },
        onEditingComplete: () {
          //移动到下一个焦点
          FocusScope.of(context).requestFocus(model.portFocus);
        },
      ),
    );
  }

  //控制器
  TextEditingController _portController;

  //端口号
  _buildPortItem(
      FormFieldState<UrlAddressModel> field, int flex, bool hasHolder) {
    var model = field.value;
    if (null == _portController) {
      _portController = TextEditingController(
        text: "${model.port ?? ""}",
      );
      model.portFocus.addListener(() {
        field.didChange(model);
      });
    }
    return Flexible(
      flex: flex,
      child: TextField(
        focusNode: model.portFocus,
        controller: _portController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(5),
        ],
        decoration: InputDecoration(
          hintText: hasHolder ? "端口号" : "",
        ).applyDefaults(enableTheme),
        onChanged: (value) {
          model.port = num.tryParse(value);
          field.didChange(model);
        },
        onEditingComplete: () {
          //移动到下一个焦点或提交
          model.portFocus.unfocus();
        },
      ),
    );
  }

  //常态边框
  final enableTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.zero,
    enabledBorder: InputBorder.none,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 3, color: Colors.blue),
    ),
  );
}

/*
* url地址表单项数据对象
* @author jtechjh
* @Time 2021/5/25 5:06 下午
*/
class UrlAddressModel {
  //协议
  Protocol protocol;

  //错误提示
  @protected
  String protocolErr;

  //焦点
  @protected
  FocusNode protocolFocus = FocusNode();

  //域名/ip地址
  String hostname;

  //错误提示
  @protected
  String hostnameErr;

  //焦点
  @protected
  FocusNode hostFocus = FocusNode();

  //端口号
  num port;

  //错误提示
  @protected
  String portErr;

  //焦点
  @protected
  FocusNode portFocus = FocusNode();

  UrlAddressModel.build({this.protocol, this.hostname, this.port});

  //判断全部是否为空
  bool get isEmpty =>
      null == protocol && (hostname?.isEmpty ?? true) && null == port;

  //判断是否有一个获取焦点
  bool get hasFocus =>
      protocolFocus.hasFocus || hostFocus.hasFocus || portFocus.hasFocus;

  //清除所有提示
  void clearErr() {
    protocolErr = null;
    hostnameErr = null;
    portErr = null;
  }

  //编辑错误提示
  String get validResult {
    List<String> errors = [];
    if (null != protocolErr) errors.add(protocolErr);
    if (null != hostnameErr) errors.add(hostnameErr);
    if (null != portErr) errors.add(portErr);
    return errors.isNotEmpty ? errors.join("；") : null;
  }
}
