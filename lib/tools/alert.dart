import 'dart:io';

import 'package:bt_service_manager/tools/route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/*
* 通知/弹出框等工具方法
* @author jtechjh
* @Time 2021/5/11 4:08 下午
*/
class AlertTools {
  //显示snackBar
  static Future<T> snack<T>(
    String message, {
    String title,
    TextButton button,
    Widget icon,
    Function onOpen,
    Function onOpening,
    Function onClosed,
    Function onClosing,
    Duration duration = const Duration(seconds: 3),
  }) =>
      Get.showSnackbar<T>(GetBar(
        title: title,
        message: message,
        mainButton: button,
        icon: icon,
        isDismissible: true,
        duration: duration,
        snackbarStatus: (status) {
          switch (status) {
            case SnackbarStatus.OPEN:
              return onOpen?.call();
            case SnackbarStatus.OPENING:
              return onOpening?.call();
            case SnackbarStatus.CLOSED:
              return onClosed?.call();
            case SnackbarStatus.CLOSING:
              return onClosing?.call();
          }
        },
      ));

  //显示提示弹窗
  static Future<T> alertDialog<T>({
    String title,
    Widget titleIcon,
    String content,
    Widget child,
    String confirm,
    EdgeInsets contentPadding = EdgeInsets.zero,
    Future<T> Function() onConfirm,
    String cancel,
    Future<T> Function() onCancel,
    String custom,
    Future<T> Function() onCustom,
  }) =>
      customDialog<T>(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: titleIcon,
                      ),
                      visible: null != titleIcon,
                    ),
                    Text(
                      title ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              visible: null != title || null != titleIcon,
            ),
            Visibility(
              child: Container(
                padding: contentPadding,
                child: child ?? Text("\t\t${content ?? ""}"),
              ),
              visible: null != content || null != child,
            ),
            Row(
              children: [
                Visibility(
                  child: TextButton(
                    child: Text(custom ?? ""),
                    onPressed: () async {
                      var result = await onCustom?.call();
                      RouteTools.pop(result);
                    },
                  ),
                  visible: null != custom,
                ),
                Expanded(child: Container()),
                Visibility(
                  child: TextButton(
                    child: Text(cancel ?? ""),
                    onPressed: () async {
                      var result = await onCancel?.call();
                      RouteTools.pop(result);
                    },
                  ),
                  visible: null != cancel,
                ),
                Visibility(
                  child: TextButton(
                    child: Text(confirm ?? ""),
                    onPressed: () async {
                      var result = await onConfirm?.call();
                      RouteTools.pop(result);
                    },
                  ),
                  visible: null != confirm,
                ),
              ],
            ),
          ],
        ),
      );

  //自定义弹窗
  static Future<T> customDialog<T>(
    Widget content, {
    bool barrierDismissible = true,
    double size,
    double width,
    double height,
  }) {
    return Get.dialog<T>(
      Material(
        color: Colors.transparent,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Container(
                child: content,
                width: size ?? width,
                height: size ?? height,
                constraints: BoxConstraints(
                  maxWidth: Get.width / 5 * 4,
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
      useSafeArea: true,
    );
  }

  //底部弹出sheet
  static Future<T> bottomSheet<T>({@required Widget content}) =>
      Get.bottomSheet<T>(
        Card(
          margin: EdgeInsets.zero,
          child: content,
        ),
      );
}

/*
* 自定义通用弹出窗口
* @author jtechjh
* @Time 2021/5/26 3:32 下午
*/
class JAlert {
  //展示调色板
  static Future<Color> showColorPicker({
    @required Color selectColor,
    String title,
    ValueChanged<Color> onColorChanged,
  }) {
    Color tempColor = selectColor;
    return AlertTools.alertDialog<Color>(
      title: title,
      child: Container(
        padding: EdgeInsets.only(top: 8),
        child: ColorPicker(
          pickerColor: selectColor,
          onColorChanged: (value) {
            onColorChanged?.call(value);
            tempColor = value;
          },
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      cancel: "取消",
      confirm: "选择",
      onConfirm: () async => tempColor,
    );
  }

  //弹出单张图片选择
  static Future<File> pickSingleImage({
    bool takeImage = true,
    bool compress = true,
  }) async {
    var result =
        await pickImages(takeImage: takeImage, maxCount: 1, compress: compress);
    return result?.isNotEmpty ?? false ? result.first : null;
  }

  //弹出图片选择
  static Future<List<File>> pickImages({
    bool takeImage = true,
    int maxCount = 9,
    bool compress = true,
  }) {
    return showBottomSheetMenu<List<File>>(
      items: [
        BottomSheetMenuItem<List<File>>(
          title: "相册",
          leading: Icon(Icons.photo_library_outlined),
          onTap: (i) async {
            var result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowCompression: compress,
              allowMultiple: maxCount > 1,
            );
            if (result.files.length <= 0) return [];
            var endIndex =
                result.files.length > maxCount ? maxCount : result.files.length;
            return result.files
                .map<File>((it) => File(it.path))
                .toList()
                .sublist(0, endIndex);
          },
        ),
      ]..addAll(takeImage
          ? [
              BottomSheetMenuItem<List<File>>(
                title: "拍照",
                leading: Icon(Icons.photo_camera_outlined),
                onTap: (i) async {
                  var result = await ImagePicker().getImage(
                    source: ImageSource.camera,
                    imageQuality: compress ? 65 : 100,
                  );
                  return [File(result.path)];
                },
              ),
            ]
          : []),
    );
  }

  //底部弹出菜单
  static Future<T> showBottomSheetMenu<T>({
    @required List<BottomSheetMenuItem<T>> items,
    bool expanded = false,
  }) {
    return AlertTools.bottomSheet<T>(
      content: StatefulBuilder(
        builder: (_, setState) => ListView.builder(
          shrinkWrap: true,
          physics: expanded ? NeverScrollableScrollPhysics() : null,
          itemCount: items.length,
          itemBuilder: (_, i) {
            BottomSheetMenuItem item = items[i];
            return ListTile(
              leading: item.leading,
              title: null != item.title ? Text(item.title) : null,
              subtitle: null != item.subTitle ? Text(item.subTitle) : null,
              onTap: () async {
                var result = await item.onTap?.call(i);
                RouteTools.pop(result);
              },
            );
          },
        ),
      ),
    );
  }

  //记录等待弹窗状态
  static Future _loadingFuture;

  //展示等待弹窗
  static Future<void> showLoading() {
    if (null == _loadingFuture) {
      _loadingFuture = AlertTools.customDialog(
        WillPopScope(
          child: Container(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
          onWillPop: () async => true,
        ),
        size: 55,
      )..whenComplete(() => _loadingFuture = null);
    }
    return _loadingFuture;
  }

  //关闭等待弹窗
  static hideLoading() {
    if (null != _loadingFuture) {
      RouteTools.pop();
      _loadingFuture = null;
    }
  }
}

/*
* 底部弹出菜单数据对象
* @author jtechjh
* @Time 2021/5/27 9:28 上午
*/
class BottomSheetMenuItem<T> {
  //名称
  String title;

  //子标题
  String subTitle;

  //头部图标
  Widget leading;

  //异步点击事件
  Future<T> Function(int i) onTap;

  BottomSheetMenuItem({
    this.title,
    this.subTitle,
    this.leading,
    this.onTap,
  });
}
