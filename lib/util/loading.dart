import 'dart:io';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  const ProgressLoader({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.05,
      width: Get.height * 0.05,
      decoration: BoxDecoration(
          color: AppColor().primaryBackGroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        heightFactor: 1,
        widthFactor: 1,
        child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: AppColor().primaryColor,
            )),
      ),
    );
  }
}
