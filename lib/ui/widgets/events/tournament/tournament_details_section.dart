import 'package:e_sport/util/colors.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentDetailsSection extends StatelessWidget {
  final Function({String? title, VoidCallback? onTap}) buildDetailItem;

  const TournamentDetailsSection({
    Key? key,
    required this.buildDetailItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: 'Tournament Details',
          fontFamily: 'InterSemiBold',
          size: 16,
          color: AppColor().primaryWhite,
        ),
        Gap(Get.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
          child: Column(
            children: [
              buildDetailItem(title: 'Participants List'),
              Divider(
                color: AppColor().lightItemsColor.withOpacity(0.3),
                thickness: 0.5,
              ),
              buildDetailItem(title: 'Tournament Structure'),
              Divider(
                color: AppColor().lightItemsColor.withOpacity(0.3),
                thickness: 0.5,
              ),
              buildDetailItem(title: 'Rules and regulations'),
              Divider(
                color: AppColor().lightItemsColor.withOpacity(0.3),
                thickness: 0.5,
              ),
              buildDetailItem(title: 'Tournament Requirements'),
              Gap(Get.height * 0.01),
            ],
          ),
        ),
      ],
    );
  }
}
