import 'dart:io';

import 'package:bt_service_manager/tools/route.dart';
import 'package:file_picker/file_picker.dart';
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

/*
* 自定义通用弹出窗口
* @author jtechjh
* @Time 2021/5/26 3:32 下午
*/
class JAlert {
  //文件类型参数
  static final Map<JFileType, dynamic> _fileTypeParams = {
    JFileType.TakeImage: {
      "text": "拍摄图片",
      "icon": Icons.add_a_photo_outlined,
    },
    JFileType.RecordVideo: {
      "text": "录制视频",
      "icon": Icons.video_call_outlined,
    },
    JFileType.RecordAudio: {
      "text": "录制音频",
      "icon": Icons.record_voice_over_outlined,
    },
    JFileType.Image: {
      "text": "选择图片",
      "icon": Icons.add_photo_alternate_outlined,
    },
    JFileType.Video: {
      "text": "选择视频",
      "icon": Icons.video_library_outlined,
    },
    JFileType.Audio: {
      "text": "选择音频",
      "icon": Icons.audiotrack_outlined,
    },
  };

  //弹出文件选择
  static Future<List<File>> pickFilesSheet({
    List<JFileType> filterTypes = const [
      JFileType.Image,
      JFileType.TakeImage,
    ],
    bool compress = true,
    List<String> customExtensions = const [],
    String customText = "",
    IconData customIcon,
    int maxCount = 1,
  }) {
    return AlertTools.bottomSheet<List<File>>(
      content: Column(
        children: filterTypes.map<Widget>((item) {
          IconData icon;
          String text;
          Future future;
          if (item == JFileType.TakeImage) {
          } else if (item == JFileType.RecordVideo) {
          } else if (item == JFileType.RecordAudio) {
          } else {
            if (item == JFileType.Custom) {
              icon = customIcon;
              text = customText;
            } else {
              var params = _fileTypeParams[item];
              icon = params["icon"];
              text = params["text"];
            }
            future = FilePicker.platform.pickFiles(
              type: item.type,
              allowCompression: compress,
              allowedExtensions: customExtensions,
              allowMultiple: maxCount > 1,
            );
          }
          return ListTile(
            leading: Icon(icon),
            title: Text(text),
            onTap: () async {
              List<File> files = [];
              var result = await future;
              if (result is FilePickerResult) {
                for (PlatformFile it in result.files) {
                  if (files.length >= maxCount) break;
                  files.add(File(it.path));
                }
              }else{

              }
              RouteTools.pop(files);
            },
          );
        }).toList(),
      ),
    );
  }
}

/*
* 文件选取的枚举类型
* @author jtechjh
* @Time 2021/5/26 3:40 下午
*/
enum JFileType {
  Image,
  TakeImage,
  Video,
  RecordVideo,
  Audio,
  RecordAudio,
  Custom,
}

/*
* 扩展文件选取枚举类型方法
* @author jtechjh
* @Time 2021/5/26 3:41 下午
*/
extension JFileTypeExtension on JFileType {
  //判断是否为自定义
  bool get isCustom => this == JFileType.Custom;

  //转换为文件选择框架的文件类型
  FileType get type {
    switch (this) {
      case JFileType.Image:
        return FileType.image;
      case JFileType.Video:
        return FileType.video;
      case JFileType.Audio:
        return FileType.audio;
      case JFileType.Custom:
        return FileType.custom;
      case JFileType.TakeImage:
        break;
      case JFileType.RecordVideo:
        break;
      case JFileType.RecordAudio:
        break;
    }
    return FileType.any;
  }
}
