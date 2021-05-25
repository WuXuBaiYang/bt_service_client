import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/material.dart';

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
    return FormField(
      builder: (field) => InputDecorator(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            _buildProtocolItem(),
            _buildHostnameItem(),
            _buildPortItem(),
          ],
        ),
        decoration: InputDecoration(
          errorText: "",
        ),
      ),
      validator: (value) {},
      onSaved: widget.onSaved,
    );
  }

  //协议项
  _buildProtocolItem() {
    return Container();
  }

  //控制器
  TextEditingController _hostController;

  //错误文本
  String _hostErrText;

  //域名/ip
  _buildHostnameItem() {
    if (null == _hostController) {
      _hostController = TextEditingController(
        text: widget.urlAddress.hostname,
      );
    }
    return Flexible(
      flex: 5,
      child: TextField(
        controller: _hostController,
        decoration: InputDecoration(
          hintText: "域名/IP",
        )..applyDefaults(null != _hostErrText ? errorTheme : enableTheme),
      ),
    );
  }

  //端口号
  _buildPortItem() {
    return Container();
  }

  //错误状态边框
  final errorTheme = InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
  );

  //常态边框
  final enableTheme = InputDecorationTheme(
    enabledBorder: InputBorder.none,
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

  //域名/ip
  String hostname;

  //端口号
  num port;

  UrlAddressModel.build({this.protocol, this.hostname, this.port});
}
