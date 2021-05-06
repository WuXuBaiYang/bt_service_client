import 'package:bt_service_manager/net/api.dart';
import 'package:flutter/material.dart';

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
  SplashPage() {
    //执行初始化方法
    api
        .getQB("https://www.jtechnas.club:8090/api/v2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: Text("登录"),
                onPressed: () {
                  api
                      .getQB("https://www.jtechnas.club:8090/api/v2")
                      .auth
                      .login("wuxubaiyang", "JTechJh31858530_");
                },
              ),
              TextButton(
                child: Text("注销"),
                onPressed: () {
                  api.getQB("https://www.jtechnas.club:8090/api/v2").auth.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
