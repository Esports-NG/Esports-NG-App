import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'referral_earning_modal.dart';
import 'referral_info.dart';
import 'referral_item.dart';

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
        Gap(Get.height * 0.02),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: AppColor().primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Row(children: [
            CustomText(
              title: 'REF12345',
              fontFamily: 'GilroySemibold',
              size: 24,
              color: AppColor().primaryWhite,
            ),
            const Spacer(),
            IntrinsicHeight(
              child: Row(
                children: [
                  Icon(
                    Icons.copy,
                    color: AppColor().primaryWhite,
                  ),
                  const Gap(10),
                  VerticalDivider(
                    color: AppColor().primaryWhite,
                  ),
                  const Gap(10),
                  Icon(
                    Icons.share,
                    color: AppColor().primaryWhite,
                  )
                ],
              ),
            )
          ]),
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
        )
      ],
    );
  }
}
