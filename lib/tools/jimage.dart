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
  }) {
    return assets(
      fileName,
      assetsPath: AssetsFile.Images,
      size: size,
    );
  }

  //从assets的icons下加载
  static Widget assetsIcon(
    String fileName, {
    double size,
  }) {
    return assets(
      fileName,
      assetsPath: AssetsFile.Icons,
      size: size,
    );
  }

  //从assets中加载
  static Widget assets(
    String fileName, {
    @required AssetsFile assetsPath,
    double size,
  }) {
    return image(
      image: Image.asset(
        "${assetsPath.path}$fileName",
      ).image,
      size: size,
    );
  }

  //图片加载基类
  static Widget image({
    @required ImageProvider image,
    BoxFit fit,
    double width,
    double height,
    double size,
    OctoPlaceholderBuilder placeholderBuilder,
    OctoErrorBuilder errorBuilder,
  }) {
    if (null != size && size >= 0) {
      width = height = size;
    }
    return OctoImage(
      image: image,
      placeholderBuilder: placeholderBuilder ?? _placeholderBuilder,
      errorBuilder: errorBuilder ?? _errorBuilder,
      height: height,
      width: width,
      fit: fit,
    );
  }

  //默认占位视图
  static get _placeholderBuilder => (_) {
        return Container(
          color: Colors.grey[300],
        );
      };

  //默认错误视图
  static get _errorBuilder => (_, error, __) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Icon(
              Icons.warning_amber_outlined,
              color: Colors.white,
            ),
          ),
        );
      };
}
