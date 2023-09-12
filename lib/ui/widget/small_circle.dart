import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class SmallCircle extends StatelessWidget {
  final Color? color;
  final double? size;
  const SmallCircle({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size ?? 3,
      width: size ?? 3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? AppColor().lightItemsColor,
      ),
    );
  }
}
