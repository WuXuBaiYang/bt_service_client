import 'package:bt_service_manager/clients/qbittorrent/apis/qb_api.dart';
import 'package:bt_service_manager/model/server_config/qb_config_model.dart';
import 'package:bt_service_manager/net/api.dart';
import 'package:bt_service_manager/tools/alert.dart';
import 'package:bt_service_manager/tools/jimage.dart';
import 'package:bt_service_manager/tools/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
* 登录页面
* @author wuxubaiyang
* @Time 2021/6/17 下午4:41
*/
class QBLoginPage extends StatefulWidget {
  //持有当前登录目标服务器的配置对象
  final QBConfigModel config;

  QBLoginPage({
    @required this.config,
  });

  @override
  State<StatefulWidget> createState() => QBLoginPageState();
}

/*
* 登录页面
* @author wuxubaiyang
* @Time 2021/6/17 下午1:42
*/
class QBLoginPageState extends State<QBLoginPage> {
  //用户名输入框控制器
  final accountEditController = TextEditingController();

  //密码输入框控制器
  final passwordEditController = TextEditingController();

  //表单key
  final formKey = GlobalKey<FormState>();

  //服务器logo尺寸
  final logoSize = 110.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QBittorrent登录"),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () => submitLogin(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            _buildFormContent(),
          ],
        ),
      ),
    );
  }

  //构建图标
  _buildLogo() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: logoSize / 2),
      shape: widget.config.logoCircle
          ? CircleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: SizedBox.fromSize(
        size: Size.square(logoSize),
        child: Padding(
          padding: EdgeInsets.all(3),
          child: widget.config.hasCustomLogo
              ? JImage.file(
                  widget.config.logoPath,
                  // size: serverItemLogoSize,
                  circle: widget.config.logoCircle,
                  radius: 4,
                )
              : JImage.assetsIcon(
                  widget.config.defaultAssetsIcon,
                  // size: serverItemLogoSize,
                  circle: true,
                ),
        ),
      ),
    );
  }

  //密码可视状态
  bool passwordObscure = true;

  //构建表单内容
  _buildFormContent() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: accountEditController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_box_outlined),
                  hintText: "用户名",
                ),
                validator: (v) {
                  if (null == v || v.isEmpty) {
                    return "用户名不能为空";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                obscureText: passwordObscure,
                controller: passwordEditController,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(passwordObscure
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => passwordObscure = !passwordObscure),
                  ),
                  hintText: "密码",
                ),
                validator: (v) {
                  if (null == v || v.isEmpty) {
                    return "密码不能为空";
                  }
                  return null;
                },
                onFieldSubmitted: (v) => submitLogin(),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  //提交登录
  submitLogin() async {
    if (!formKey.currentState.validate()) return;
    var account = accountEditController.text;
    var password = passwordEditController.text;
    JAlert.showLoading();
    try {
      var response = await api
          .getClientApi<QBAPI>(widget.config)
          .auth
          .login(account, password);
      if (response.success) {
        JAlert.hideLoading();
        return RouteTools.pop(true);
      }
      AlertTools.snack(response.message);
    } catch (e) {
      AlertTools.snack("登录失败，请重试");
    }
    JAlert.hideLoading();
  }
}
