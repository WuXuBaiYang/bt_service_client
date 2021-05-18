import 'package:get/get.dart';

/*
* 服务器状态/列表控制器
* @author jtechjh
* @Time 2021/5/18 4:08 下午
*/
class ServerController extends GetxController {
  //全局下载速度
  var totalDownloadSpeed = 0.0.obs;

  //全局上传速度
  var totalUploadSpeed = 0.0;

  //更新汇总信息
  void updateTotalInfo(num downSpeed, num upSpeed) {
    this.totalDownloadSpeed.value = downSpeed;
    this.totalUploadSpeed = upSpeed;
  }
}
