import 'package:e_sport/data/model/transaction_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:number_display/number_display.dart';

class TransactionHistoryItem extends StatelessWidget {
  final TransactionModel item;
  const TransactionHistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final display = createDisplay(
      roundingType: RoundingType.floor,
      length: 15,
      decimal: 10,
    );
    return Container(
      padding: EdgeInsets.all(Get.height * 0.02),
      decoration: BoxDecoration(
        color: AppColor().referral,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: item.title,
                size: 12,
                fontFamily: 'GilroySemiBold',
                textAlign: TextAlign.start,
                color: AppColor().greyTwo,
              ),
              Gap(Get.height * 0.01),
              CustomText(
                title: item.date,
                size: 12,
                fontFamily: 'GilroyMedium',
                textAlign: TextAlign.start,
                color: AppColor().greySix,
              ),
            ],
          ),
          CustomText(
            title: 'N${display(item.price)}',
            size: 14,
            fontFamily: 'GilroySemiBold',
            textAlign: TextAlign.start,
            color: item.type == 'in'
                ? AppColor().transactGreen
                : AppColor().transactOrange,
          ),
        ],
      ),
    );
  }
}
