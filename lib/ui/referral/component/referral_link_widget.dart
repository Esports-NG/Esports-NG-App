import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'referral_info.dart';
import 'referral_item.dart';
import 'referral_option.dart';

class ReferralLinkWidget extends StatelessWidget {
  const ReferralLinkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReferralInfo(),
        ReferralOption(
          title: 'Copy Referral Link',
          icon: Icons.copy,
          color: AppColor().primaryColor,
        ),
        Gap(Get.height * 0.02),
        ReferralOption(
          title: 'Share Link',
          icon: Icons.share,
          color: AppColor().primaryBackGroundColor,
          textColor: AppColor().primaryColor,
          border: Border.all(
            color: AppColor().primaryColor,
            width: 0.5,
          ),
        ),
        Gap(Get.height * 0.04),
        ReferralItem(
          title: 'View Referral Earnings',
          onTap: () {},
        ),
        Gap(Get.height * 0.03),
        ReferralItem(
          title: 'View Referral Leader board',
          onTap: () {},
        ),
      ],
    );
  }
}
