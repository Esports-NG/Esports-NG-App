import 'package:e_sport/data/model/referral_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReferralEarningModal extends StatelessWidget {
  const ReferralEarningModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor().primaryModalColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Center(
              child: Container(
            height: Get.height * 0.008,
            width: Get.height * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor().greyGradient),
          )),
          Padding(
            padding: EdgeInsets.all(Get.height * 0.04),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Referral Earnings',
                      color: AppColor().greyOne,
                      weight: FontWeight.w400,
                      fontFamily: 'GilroySemiBold',
                      size: Get.height * 0.022,
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.close,
                          color: AppColor().greyOne,
                        ))
                  ],
                ),
                Gap(Get.height * 0.02),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: referralEarningsItem.length,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                  itemBuilder: (context, index) {
                    var item = referralEarningsItem[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          title: item.title,
                          color: AppColor().greyOne,
                          weight: FontWeight.w400,
                          fontFamily: 'GilroySemiBold',
                          size: Get.height * 0.022,
                        ),
                        CustomText(
                          title: 'Referral Earnings',
                          color: AppColor().greyOne,
                          weight: FontWeight.w400,
                          fontFamily: 'GilroySemiBold',
                          size: Get.height * 0.022,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
