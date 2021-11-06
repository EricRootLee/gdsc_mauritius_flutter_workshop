import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension StringExtensions on String {
  String operator &(String? other) => '$this $other';
}

extension NavigationExtensions on BuildContext {
  Future<dynamic> appNavigatorPush(dynamic path) => Navigator.push(
      this, CupertinoPageRoute(builder: (BuildContext context) => path));

  Future<dynamic> appNavigatorReplacement(dynamic path) =>
      Navigator.pushReplacement(
          this, CupertinoPageRoute(builder: (BuildContext context) => path));

  Future<dynamic> appNavigatorPushRemoveUntil(dynamic path) =>
      Navigator.pushAndRemoveUntil(
          this,
          CupertinoPageRoute(builder: (context) => path),
          (Route<dynamic> route) => false);

  void back<T extends Object>([T? params]) {
    Navigator.of(this).pop([params]);
  }
}

extension AppSizeExtensions on BuildContext {
  appHeight() => MediaQuery.of(this).size.height;
  appWidth() => MediaQuery.of(this).size.width;
}

extension CacheImageExtensions on BuildContext {
  Widget cacheImage(
          {required String imgeUrl,
          required double width,
          required double height,
          BoxShape? shape,
          BorderRadiusGeometry? borderRadius}) =>
      CachedNetworkImage(
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
            borderRadius: borderRadius,
            shape: shape ?? BoxShape.rectangle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        fit: BoxFit.cover,
        fadeInCurve: Curves.easeInQuart,
        fadeInDuration: Duration(milliseconds: 100),
        fadeOutCurve: Curves.easeOutQuart,
        fadeOutDuration: Duration(milliseconds: 100),
        imageUrl: imgeUrl,
        useOldImageOnUrlChange: true,
        placeholder: (context, url) => FlutterLogo(size: 20),
        errorWidget: (context, url, error) => FlutterLogo(size: 20),
      );
}
