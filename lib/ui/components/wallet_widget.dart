import 'package:e_sport/data/model/transaction_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'transaction_history_item.dart';

class WalletWidget extends StatelessWidget {
  const WalletWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SvgPicture.asset(
              'assets/images/svg/walletBg.svg',
              height: Get.height * 0.25,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              right: Get.height * 0.09,
              bottom: Get.height * 0.06,
              child: Image.asset(
                'assets/images/png/walletImage2.png',
                opacity: const AlwaysStoppedAnimation(0.5),
              ),
            ),
            Positioned(
              right: Get.height * 0.02,
              bottom: Get.height * 0.02,
              child: Image.asset(
                'assets/images/png/walletImage1.png',
                opacity: const AlwaysStoppedAnimation(0.5),
              ),
            ),
            Positioned(
              top: Get.height * 0.07,
              left: Get.height * 0.06,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: ' Your Balance',
                    color: AppColor().greyEight,
                    weight: FontWeight.w400,
                    size: Get.height * 0.014,
                    fontFamily: 'GilroySemiBold',
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'N4,790.35',
                    color: AppColor().primaryWhite,
                    weight: FontWeight.w400,
                    size: Get.height * 0.028,
                    fontFamily: 'GilroySemiBold',
                  ),
                  Gap(Get.height * 0.05),
                  Row(
                    children: [
                      SmallCircle(color: AppColor().greyTwo),
                      Gap(Get.height * 0.002),
                      SmallCircle(color: AppColor().greyTwo),
                      Gap(Get.height * 0.002),
                      CustomText(
                        title: 'realmischaxyz',
                        color: AppColor().greyTwo,
                        weight: FontWeight.w400,
                        size: Get.height * 0.014,
                        fontFamily: 'GilroySemiBold',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Gap(Get.height * 0.02),
        Row(
          children: [
            options(
              title: 'Deposit',
              color: AppColor().primaryColor,
            ),
            Gap(Get.height * 0.02),
            options(
              title: 'Withdraw',
              color: AppColor().primaryBackGroundColor,
              border: Border.all(
                color: AppColor().primaryColor,
                width: 0.5,
              ),
            ),
            Gap(Get.height * 0.02),
            options(
              title: 'Transfer',
              color: AppColor().primaryBackGroundColor,
              border: Border.all(
                color: AppColor().primaryColor,
                width: 0.5,
              ),
            ),
          ],
        ),
        Gap(Get.height * 0.07),
        CustomText(
          title: 'Transaction History',
          color: AppColor().greyTwo,
          weight: FontWeight.w400,
          size: Get.height * 0.016,
          fontFamily: 'GilroySemiBold',
        ),
        Gap(Get.height * 0.02),
        ListView.separated(
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: transactionHistory.length,
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          itemBuilder: (context, index) {
            var item = transactionHistory[index];
            return InkWell(
              onTap: () {
                // Get.to(
                //   () => PostDetails(
                //     item: item,
                //   ),
                // );
              },
              child: TransactionHistoryItem(item: item),
            );
          },
        ),
      ],
    );
  }

  Expanded options({String? title, Color? color, BoxBorder? border}) {
    return Expanded(
      child: Container(
        height: Get.height * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: color,
            border: border ?? Border.all()),
        child: Center(
          child: CustomText(
            title: title,
            color:
                border != null ? AppColor().primaryColor : AppColor().greyTwo,
            weight: FontWeight.w400,
            size: Get.height * 0.016,
            fontFamily: 'GilroySemiBold',
          ),
        ),
      ),
    );
  }
}
