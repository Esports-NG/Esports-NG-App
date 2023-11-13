import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'referral_earning_modal.dart';
import 'referral_info.dart';
import 'referral_item.dart';
import 'referral_option.dart';

class ReferralCodeWidget extends StatelessWidget {
  const ReferralCodeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReferralInfo(),
        ReferralOption(
          title: 'Copy Referral Code',
          icon: Icons.copy,
          color: AppColor().primaryColor,
        ),
        Gap(Get.height * 0.02),
        ReferralOption(
          title: 'Share Code',
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
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: false,
                backgroundColor: AppColor().primaryWhite,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                context: context,
                builder: (context) {
                  return const ReferralEarningModal();
                });
          },
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
