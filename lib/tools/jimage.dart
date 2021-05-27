import 'dart:io';

import 'package:bt_service_manager/tools/tools.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

/*
* 图片加载工具
* @author jtechjh
* @Time 2021/5/18 3:01 下午
*/
class JImage {
  //从assets的icons下加载
  static Widget assetsImage(
    String fileName, {
    double size,
    bool circle,
    double radius,
    double borderWidth,
    Color borderColor,
  }) {
    return assets(
      fileName,
      assetsPath: AssetsFile.Images,
      size: size,
      circle: circle,
      radius: radius,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }

  //从assets的icons下加载
  static Widget assetsIcon(
    String fileName, {
    double size,
    bool circle,
    double radius,
    double borderWidth,
    Color borderColor,
  }) {
    return assets(
      fileName,
      assetsPath: AssetsFile.Icons,
      size: size,
      circle: circle,
      radius: radius,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }

  //从assets中加载
  static Widget assets(
    String fileName, {
    @required AssetsFile assetsPath,
    double size,
    double width,
    double height,
    bool circle,
    double radius,
    double borderWidth,
    Color borderColor,
  }) {
    return image(
      image: Image.asset(
        "${assetsPath.path}$fileName",
      ).image,
      size: size,
      width: width,
      height: height,
      circle: circle,
      radius: radius,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }

  //从本地文件中加载
  static Widget file(
    String filePath, {
    double size,
    double width,
    double height,
    bool circle,
    double radius,
    double borderWidth,
    Color borderColor,
  }) {
    return image(
      image: Image.file(File(filePath)).image,
      size: size,
      width: width,
      height: height,
      circle: circle,
      radius: radius,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }

  //图片加载基类
  static Widget image({
    @required ImageProvider image,
    bool circle,
    double radius,
    double borderWidth,
    Color borderColor,
    BoxFit fit = BoxFit.cover,
    double width,
    double height,
    double size,
  }) {
    if (null != size && size >= 0) {
      width = height = size;
    }
    circle ??= false;
    radius ??= 0;
    borderWidth ??= 0;
    borderColor ??= Colors.transparent;
    return OctoImage(
      image: image,
      placeholderBuilder: (_) {
        return _buildImageBody(
          circle,
          radius,
          Container(
            color: Colors.grey[300],
          ),
        );
      },
      errorBuilder: (_, error, __) {
        return _buildImageBody(
          circle,
          radius,
          Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.warning_amber_outlined,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
      imageBuilder: (_, child) {
        return Container(
          child: _buildImageBody(circle, radius, child),
          decoration: BoxDecoration(
            border: Border.all(
              width: borderWidth,
              color: borderColor,
            ),
            borderRadius: !circle ? BorderRadius.circular(radius) : null,
            shape: circle ? BoxShape.circle : BoxShape.rectangle,
          ),
        );
      },
      height: height,
      width: width,
      fit: fit,
    );
  }

  //构建图片底座
  static _buildImageBody(bool circle, double radius, Widget child) {
    return circle
        ? ClipOval(child: child)
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: child,
          );
  }
}
