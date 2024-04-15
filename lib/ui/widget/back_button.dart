import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoBackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.arrow_back,
        color: AppColor().primaryWhite,
      ),
    );
  }
}
