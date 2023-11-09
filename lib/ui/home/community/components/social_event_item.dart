import 'package:e_sport/data/model/account_events_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:number_display/number_display.dart';

class SocialEventItem extends StatelessWidget {
  final AccountEventsModel item;
  const SocialEventItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final display = createDisplay(
      roundingType: RoundingType.floor,
      length: 15,
      decimal: 10,
    );
    return Container(
      width: Get.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().lightItemsColor,
          width: 0.5,
        ),
        gradient: LinearGradient(
          colors: [
            AppColor().bgDark,
            AppColor().primaryBackGroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: Get.height * 0.22,
                width: double.infinity,
                padding: EdgeInsets.all(Get.height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: DecorationImage(
                      image: AssetImage(item.image!), fit: BoxFit.cover),
                ),
              ),
              Positioned(
                right: Get.height * 0.02,
                bottom: Get.height * 0.02,
                top: Get.height * 0.16,
                child: Container(
                  padding: EdgeInsets.all(Get.height * 0.005),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColor().secondaryGreenColor,
                    ),
                  ),
                  child: Center(
                    child: textItem(
                      title: 'Free Entry',
                      subTitle: '',
                      color: AppColor().secondaryGreenColor,
                      titleFamily: 'GilroyMedium',
                      subTitleFamily: 'GilroySemiBold',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 0,
            color: AppColor().lightItemsColor,
            thickness: 0.5,
          ),
          Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: item.title,
                  size: 18,
                  fontFamily: 'GilroySemiBold',
                  weight: FontWeight.w400,
                  textAlign: TextAlign.start,
                  color: AppColor().greyTwo,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Game: ',
                  subTitle: item.game!.toUpperCase(),
                ),
                Gap(Get.height * 0.01),
                Divider(
                  height: 0,
                  color: AppColor().lightItemsColor.withOpacity(0.2),
                  thickness: 0.5,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Registration: ',
                  titleSize: 12.0,
                  subTitleSize: 12.0,
                  subTitle: item.registrationDate!,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Tournament: ',
                  titleSize: 12.0,
                  subTitleSize: 12.0,
                  subTitle: item.tournamentDate!,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Time & Venue: ',
                  titleSize: 12.0,
                  subTitleSize: 12.0,
                  subTitle: item.time!,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Event link: ',
                  titleSize: 12.0,
                  subTitleSize: 12.0,
                  subTitle: 'https://spaces.twitter.com/coc...',
                ),
                Gap(Get.height * 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row textItem({
    String? title,
    subTitle,
    titleFamily,
    subTitleFamily,
    Color? color,
    double? titleSize,
    subTitleSize,
  }) {
    return Row(
      children: [
        CustomText(
          title: title,
          size: titleSize ?? 14,
          fontFamily: titleFamily ?? 'GilroyRegular',
          textAlign: TextAlign.start,
          color: color ?? AppColor().greyTwo,
        ),
        CustomText(
          title: subTitle,
          size: subTitleSize ?? 14,
          fontFamily: subTitleFamily ?? 'GilroySemiBold',
          textAlign: TextAlign.start,
          color: color ?? AppColor().greyTwo,
        ),
      ],
    );
  }
}
