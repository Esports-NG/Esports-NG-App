import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class ButtonLoader extends StatelessWidget {
  const ButtonLoader({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: color ?? AppColor().primaryColor,
        strokeCap: StrokeCap.round,
        strokeWidth: 2,
      ),
    );
  }
}
