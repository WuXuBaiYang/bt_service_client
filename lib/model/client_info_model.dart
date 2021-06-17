/*
* 平台客户端汇总信息对象
* @author wuxubaiyang
* @Time 2021/6/17 上午10:45
*/
class ClientInfoModel {
  //下行速度
  double downSpeed;

  //上行速度
  double upSpeed;

  //总任务数量
  int taskCount;

  ClientInfoModel({
    this.downSpeed,
    this.upSpeed,
    this.taskCount,
  });
}
