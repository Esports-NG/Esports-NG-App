import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator(this.pageCount, this.index, this.height, this.width,
      {Key? key})
      : super(key: key);

  final int pageCount;
  final int index;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: pageCount < index
            ? AppColor().primaryDark
            : AppColor().primaryWhite,
        borderRadius: BorderRadius.circular(
          6,
        ),
      ),
    );
  }
}
