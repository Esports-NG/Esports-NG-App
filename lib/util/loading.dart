import 'dart:io';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color? color;
  final double? size;
  const LoadingWidget({Key? key, this.color = Colors.white, this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 20,
      height: size ?? 20,
      child: Center(
          heightFactor: 1,
          widthFactor: 1,
          child: Platform.isIOS
              ? CupertinoActivityIndicator(
                  color: color ?? Colors.white,
                )
              : CircularProgressIndicator(
                  color: color ?? Colors.white,
                )),
    );
  }
}

class ProgressLoader extends StatelessWidget {
  final Color? color;
  final double? size;
  const ProgressLoader({Key? key, this.color = Colors.white, this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: SizedBox(
          width: size ?? 20,
          height: size ?? 20,
          child: CircularProgressIndicator(
            color: AppColor().primaryColor,
          )),
    );
  }
}
