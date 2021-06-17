import 'package:bt_service_manager/clients/qbittorrent/pages/login_page.dart';
import 'package:bt_service_manager/manage/routes/page_manage.dart';
import 'package:bt_service_manager/model/server_config/qb_config_model.dart';

/*
* QBittorrent页面路由
* @author wuxubaiyang
* @Time 2021/6/17 下午2:36
*/
class QBPageRoute extends BasePageRoute {
  //跳转到登录页面
  goLogin(QBConfigModel config) => go(QBLoginPage(config: config));
}
