import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class ButtonLoader extends StatelessWidget {
  const ButtonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: AppColor().primaryColor,
        strokeCap: StrokeCap.round,
        strokeWidth: 2,
      ),
    );
  }
}
