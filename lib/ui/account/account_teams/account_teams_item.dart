import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountTeamsItem extends StatelessWidget {
  final AccountTeamsModel item;
  const AccountTeamsItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColor().lightItemsColor.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: Get.height * 0.07,
            width: Get.height * 0.07,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage(item.image!), fit: BoxFit.fitWidth)),
          ),
          Gap(Get.height * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: item.name,
                  size: 16,
                  fontFamily: 'GilroyBold',
                  textAlign: TextAlign.start,
                  color: AppColor().greyOne,
                ),
                Gap(Get.height * 0.01),
                CustomText(
                  title: item.members,
                  size: 12,
                  fontFamily: 'GilroyRegular',
                  textAlign: TextAlign.start,
                  color: AppColor().greySix,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: item.details,
                  size: 12,
                  fontFamily: 'GilroyMedium',
                  textAlign: TextAlign.start,
                  color: AppColor().greySix,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
