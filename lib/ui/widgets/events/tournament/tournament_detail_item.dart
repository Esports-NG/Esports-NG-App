import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TournamentDetailItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const TournamentDetailItem({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              title: title,
              size: 14,
              fontFamily: 'InterMedium',
              color: AppColor().greySix,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor().primaryColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
