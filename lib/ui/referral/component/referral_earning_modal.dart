import 'package:e_sport/data/model/other_models.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:number_display/number_display.dart';

class ReferralEarningModal extends StatelessWidget {
  const ReferralEarningModal({super.key});

  @override
  Widget build(BuildContext context) {
    final display = createDisplay(
      roundingType: RoundingType.floor,
      length: 15,
      decimal: 10,
    );
    return Container(
      height: Get.height * 0.35,
      padding: EdgeInsets.only(top: Get.height * 0.005),
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
            height: Get.height * 0.006,
            width: Get.height * 0.09,
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
                      fontFamily: 'InterSemiBold',
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
                Gap(Get.height * 0.05),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: referralEarningsItem.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColor().greyGradient.withOpacity(0.5),
                    height: Get.height * 0.05,
                    thickness: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    var item = referralEarningsItem[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          title: item.title,
                          color: AppColor().greyTwo,
                          fontFamily: 'InterMedium',
                          size: Get.height * 0.020,
                        ),
                        CustomText(
                          title: item.title == 'Total Cash Earned'
                              ? 'N${display(item.price)}'
                              : display(item.price),
                          color: AppColor().greyTwo,
                          fontFamily: 'InterSemiBold',
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
