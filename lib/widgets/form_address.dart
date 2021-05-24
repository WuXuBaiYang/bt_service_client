import 'package:bt_service_manager/model/server_config/server_config_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/*
* url组合控件
* @author jtechjh
* @Time 2021/5/21 5:07 下午
*/
class UrlAddressFormField extends StatefulWidget {
  //支持的协议类型
  final List<Protocol> protocols;

  //服务器地址信息对象
  final UrlAddressModel address;

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
    // return FormField<UrlAddressModel>(
    //   initialValue: widget.address,
    //   builder: (f) => InputDecorator(
    //     decoration: InputDecoration(
    //       contentPadding: EdgeInsets.zero,
    //       border: InputBorder.none,
    //       errorText: f.errorText,
    //       errorMaxLines: 10,
    //     ),
    //     child: Flex(
    //       direction: Axis.horizontal,
    //       children: [
    //         _buildProtocolItem(f),
    //         _buildHostnameItem(f),
    //         _buildPortItem(f),
    //       ],
    //     ),
    //   ),
    //   validator: (v) {
    //     v.clearErr();
    //     if (null == v.protocol) {
    //       v.protocolErr = "协议不能为空";
    //     }
    //     if (v.hostname?.isEmpty ?? true) {
    //       v.hostnameErr = "域名/IP不能为空";
    //     } else if (!RegExp(r"^\d{0,3}\.\d{0,3}\.\d{0,3}\.\d{0,3}$")
    //             .hasMatch(v.hostname) &&
    //         !RegExp(r"^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$")
    //             .hasMatch(v.hostname)) {
    //       v.hostnameErr = "域名/IP格式错误";
    //     }
    //     if ((v?.port ?? 0) <= 0) {
    //       v.portErr = "端口号错误";
    //     }
    //     return v.validResult;
    //   },
    //   onSaved: (v) {},
    // );
    return TextFormField(
      initialValue: "",
      decoration: InputDecoration(
        suffixIcon: SizedBox(
          child: TextField(),
          width: 50,
        ),
        prefixIcon: SizedBox(
          child: TextField(),
          width: 50,
        ),
        border: AddressUnderlineInputBorder(inputBorder: null),
        enabledBorder: AddressUnderlineInputBorder(inputBorder: null),
        focusedBorder: AddressUnderlineInputBorder(inputBorder: null),
      ),
    );
  }

  //输入框样式
  final decorationTheme = InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1)),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    labelStyle: TextStyle(color: Colors.red),
  );

  //报错边框
  final errorBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1));

  //报错焦点边框
  final errorBorderFocus =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2));

  //错误的提示文本
  final errorLabelStyle = TextStyle(color: Colors.red);

  //协议项
  _buildProtocolItem(FormFieldState<UrlAddressModel> f) {
    var hasErr = null != f.value.protocolErr;
    return Flexible(
      flex: 3,
      child: PopupMenuButton<Protocol>(
        child: InputDecorator(
          isEmpty: null == f.value.protocol,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            // floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: hasErr ? errorBorder : null,
            focusedBorder: hasErr ? errorBorderFocus : null,
            labelStyle: hasErr ? errorLabelStyle : null,
            labelText: "协议",
            suffixText: " :// ",
          ),
          child: Text(
            f.value.protocol?.text?.toUpperCase() ?? "",
            textAlign: TextAlign.end,
            maxLines: 1,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        itemBuilder: (_) => List.generate(widget.protocols.length, (i) {
          var item = widget.protocols[i];
          return PopupMenuItem(
            child: Text(item.text),
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
  _buildHostnameItem(FormFieldState<UrlAddressModel> f) {
    if (hostnameController.text.isEmpty) {
      hostnameController.text = f.value.hostname;
    }
    var hasErr = null != f.value.hostnameErr;
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
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: hasErr ? errorBorder : null,
          focusedBorder: hasErr ? errorBorderFocus : null,
          labelStyle: hasErr ? errorLabelStyle : null,
          labelText: "域名/IP",
        ),
        onChanged: (v) => f.value.hostname = v,
        onEditingComplete: () => f.didChange(f.value),
      ),
    );
  }

  //域名/ip输入框控制器
  final portController = TextEditingController();

  //端口号
  _buildPortItem(FormFieldState<UrlAddressModel> f) {
    if (portController.text.isEmpty) {
      portController.text = "${f.value.port ?? ""}";
    }
    var hasErr = null != f.value.portErr;
    return Flexible(
      flex: 3,
      child: TextField(
        controller: portController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(5),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: hasErr ? errorBorder : null,
          focusedBorder: hasErr ? errorBorderFocus : null,
          labelStyle: hasErr ? errorLabelStyle : null,
          labelText: "端口号",
          prefixText: " : ",
        ),
        onChanged: (v) => f.value.port = num.tryParse(v),
        onEditingComplete: () => f.didChange(f.value),
      ),
    );
  }
}

/*
* 服务器路径对象
* @author jtechjh
* @Time 2021/5/21 2:09 下午
*/
class UrlAddressModel {
  //协议
  Protocol protocol;

  //错误提示
  @protected
  String protocolErr;

  //域名/ip地址
  String hostname;

  //错误提示
  @protected
  String hostnameErr;

  //端口号
  num port;

  //错误提示
  @protected
  String portErr;

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
    return errors.isNotEmpty ? errors.join("，") : null;
  }

  UrlAddressModel.build({
    @required this.protocol,
    @required this.hostname,
    @required this.port,
  });
}

/*
* 地址组件使用的下划线样式
* @author jtechjh
* @Time 2021/5/24 5:57 下午
*/
class AddressUnderlineInputBorder extends InputBorder {
  //持有当前状态
  final UnderlineInputBorder inputBorder;

  //左侧空闲宽度
  final double startSpace;

  //右侧空闲宽度
  final double endSpace;

  const AddressUnderlineInputBorder({
    @required this.inputBorder,
    this.startSpace = 0,
    this.endSpace = 0,
  });

  @override
  bool get isOutline => false;

  @override
  UnderlineInputBorder copyWith(
      {BorderSide borderSide, BorderRadius borderRadius}) {
    return inputBorder;
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.only(bottom: inputBorder.borderSide.width);
  }

  @override
  UnderlineInputBorder scale(double t) {
    return UnderlineInputBorder(borderSide: inputBorder.borderSide.scale(t));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return inputBorder.getInnerPath(rect, textDirection: textDirection);
    // return Path()
    //   ..addRect(Rect.fromLTWH(rect.left, rect.top, rect.width,
    //       math.max(0.0, rect.height - inputBorder.borderSide.width)));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return inputBorder.getOuterPath(rect, textDirection: textDirection);
    // return Path()
    //   ..addRRect(inputBorder.borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  ShapeBorder lerpFrom(ShapeBorder a, double t) {
    if (a is UnderlineInputBorder) {
      return UnderlineInputBorder(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        borderRadius:
            BorderRadius.lerp(a.borderRadius, inputBorder.borderRadius, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder lerpTo(ShapeBorder b, double t) {
    if (b is UnderlineInputBorder) {
      return UnderlineInputBorder(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        borderRadius:
            BorderRadius.lerp(inputBorder.borderRadius, b.borderRadius, t),
      );
    }
    return super.lerpTo(b, t);
  }

  /// Draw a horizontal line at the bottom of [rect].
  ///
  /// The [borderSide] defines the line's color and weight. The `textDirection`
  /// `gap` and `textDirection` parameters are ignored.
  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection textDirection,
  }) {
    inputBorder.paint(canvas, rect,
        gapStart: gapStart,
        gapExtent: gapExtent,
        gapPercentage: gapPercentage,
        textDirection: textDirection);
    // if (inputBorder.borderRadius.bottomLeft != Radius.zero ||
    //     inputBorder.borderRadius.bottomRight != Radius.zero)
    //   canvas.clipPath(getOuterPath(rect, textDirection: textDirection));
    // canvas.drawLine(rect.bottomLeft, rect.bottomRight, borderSide.toPaint());
  }

  @override
  bool operator ==(Object other) {
    return inputBorder == other;
    // if (identical(this, other)) return true;
    // if (other.runtimeType != runtimeType) return false;
    // return other is InputBorder && other.borderSide == borderSide;
  }

  @override
  int get hashCode => inputBorder.borderSide.hashCode;
}
