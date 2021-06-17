import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 登录页面
* @author wuxubaiyang
* @Time 2021/6/17 下午1:42
*/
class LoginPage extends StatelessWidget {
  //表单key
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QBittorrent登录"),
      ),
      body: Form(
        key: formKey,
        child: _buildFormItems(),
      ),
    );
  }

  //构建表单子项
  _buildFormItems() {}
}
