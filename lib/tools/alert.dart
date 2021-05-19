import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
* 通知/弹出框等工具方法
* @author jtechjh
* @Time 2021/5/11 4:08 下午
*/
class AlertTools {
  //显示snackBar
  static snack<T>(String message, {String title = "", TextButton button}) =>
      Get.snackbar<T>(
        title,
        message,
        mainButton: button,
      );

  //显示提示弹窗
  static Future<T> alertDialog<T>(
    String content, {
    String title = "",
    String confirm,
    VoidCallback onConfirm,
    String cancel,
    VoidCallback onCancel,
    String custom,
    VoidCallback onCustom,
  }) =>
      Get.defaultDialog<T>(
        title: title,
        content: Text(content),
        textConfirm: confirm,
        onConfirm: onConfirm,
        textCancel: cancel,
        onCancel: onCancel,
        textCustom: custom,
        onCustom: onCustom,
      );

  //底部弹出sheet
  static Future<T> bottomSheet<T>({@required Widget content}) =>
      Get.bottomSheet(
        Card(
          margin: EdgeInsets.zero,
          child: content,
        ),
      );
}
