import 'package:e_sport/data/model/games_played_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GamesPlayedItem extends StatelessWidget {
  final GamesPlayed item;
  const GamesPlayedItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().lightItemsColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Get.height * 0.15,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage(item.image!), fit: BoxFit.fitWidth)),
          ),
          Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Column(
              children: [
                textItem(
                  title: 'Call of Duty: ',
                  subTitle: item.name!,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Game ID: ',
                  subTitle: item.id!,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'IGN: ',
                  subTitle: item.ign!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row textItem({String? title, subTitle}) {
    return Row(
      children: [
        CustomText(
          title: title,
          size: 12,
          fontFamily: 'GilroyRegular',
          textAlign: TextAlign.start,
          color: AppColor().greyTwo,
        ),
        CustomText(
          title: subTitle,
          size: 12,
          fontFamily: 'GilroySemiBold',
          textAlign: TextAlign.start,
          color: AppColor().greyTwo,
        ),
      ],
    );
  }
}
