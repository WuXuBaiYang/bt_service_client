import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
* url组合控件
* @author jtechjh
* @Time 2021/5/21 5:07 下午
*/
class UrlAddressFormField extends StatefulWidget {
  //支持的协议类型
  final List<Protocol> protocols;

  //服务器地址信息对象
  final UrlAddress address;

  const UrlAddressFormField({
    Key key,
    @required this.address,
    this.protocols = const [],
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UrlAddressFormFieldState();
}

/*
* url组合控件
* @author jtechjh
* @Time 2021/5/21 5:08 下午
*/
class _UrlAddressFormFieldState extends State<UrlAddressFormField> {

  @override
  Widget build(BuildContext context) {
    return FormField<UrlAddress>(
      initialValue: widget.address,
      builder: (f) => InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          errorText: f.errorText,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            _buildProtocolItem(f),
            _buildHostnameItem(f),
            _buildPortItem(f),
          ],
        ),
      ),
      validator: (v) {
        if (null == v.protocol) {
          return "协议不能为空";
        }
        if (v.hostname?.isEmpty ?? true) {
          return "域名/IP不能为空";
        }
        if (!RegExp(r"^\d{0,3}\.\d{0,3}\.\d{0,3}\.\d{0,3}$")
                .hasMatch(v.hostname) &&
            !RegExp(r"^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$")
                .hasMatch(v.hostname)) {
          return "域名/IP格式错误";
        }
        if ((v?.port ?? 0) <= 0) {
          return "端口号错误";
        }
        return null;
      },
      onSaved: (v) {},
    );
  }

  //协议项
  _buildProtocolItem(FormFieldState<UrlAddress> f) {
    return Flexible(
      flex: 2,
      child: PopupMenuButton<Protocol>(
        child: InputDecorator(
          isEmpty: null == f.value.protocol,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            labelText: "协议",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                // width: 20
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2
              ),
            ),
          ),
          child: Text(f.value.protocol?.text ?? ""),
        ),
        itemBuilder: (_) => List.generate(widget.protocols.length, (i) {
          var item = widget.protocols[i];
          return PopupMenuItem(
            child: Text("${item.text}://"),
            value: item,
          );
        }),
        onSelected: (v) {
          f.value.protocol = v;
          f.didChange(f.value);
        },
      ),
    );
  }

  //域名/ip输入框控制器
  final hostnameController = TextEditingController();

  //域名/IP项
  _buildHostnameItem(FormFieldState<UrlAddress> f) {
    if (hostnameController.text.isEmpty) {
      hostnameController.text = f.value.hostname;
    }
    return Flexible(
      flex: 10,
      child: TextField(
        controller: hostnameController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9]|\.|[a-zA-Z]")),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: "域名/IP",
        ),
      ),
    );
  }

  //域名/ip输入框控制器
  final portController = TextEditingController();

  //端口号
  _buildPortItem(FormFieldState<UrlAddress> f) {
    if (portController.text.isEmpty) {
      portController.text = "${f.value.port ?? ""}";
    }
    return Flexible(
      flex: 2,
      child: TextField(
        controller: portController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(5),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: "端口号",
        ),
      ),
    );
  }
}

/*
* 服务器路径对象
* @author jtechjh
* @Time 2021/5/21 2:09 下午
*/
class UrlAddress {
  //协议
  Protocol protocol;

  //域名/ip地址
  String hostname;

  //端口号
  num port;

  UrlAddress.build({
    @required this.protocol,
    @required this.hostname,
    @required this.port,
  });
}
