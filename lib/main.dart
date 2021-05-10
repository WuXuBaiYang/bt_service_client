import 'package:bt_service_manager/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BT服务管理",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}

/*
* 启动页
* @author jtechjh
* @Time 2021/4/29 4:06 PM
*/
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        child: Text("跳转"),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        },
      )),
    );
  }
}
