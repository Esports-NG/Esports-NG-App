import 'package:e_sport/data/model/account_events_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:number_display/number_display.dart';

class TournamentItem extends StatelessWidget {
  final AccountEventsModel item;
  const TournamentItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final display = createDisplay(
      roundingType: RoundingType.floor,
      length: 15,
      decimal: 10,
    );
    return Container(
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
              Positioned.fill(
                left: Get.height * 0.02,
                bottom: Get.height * 0.16,
                top: Get.height * 0.02,
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: item.genre!.length,
                    separatorBuilder: (context, index) =>
                        Gap(Get.height * 0.01),
                    itemBuilder: (context, index) {
                      var items = item.genre![index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: AppColor().primaryWhite,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColor().primaryColor.withOpacity(0.05),
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: items == 'Ranked'
                              ? Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/images/svg/rank.svg'),
                                    CustomText(
                                      title: items,
                                      color: AppColor().pureBlackColor,
                                      textAlign: TextAlign.center,
                                      size: Get.height * 0.014,
                                      fontFamily: 'GilroyMedium',
                                    ),
                                  ],
                                )
                              : CustomText(
                                  title: items,
                                  color: AppColor().pureBlackColor,
                                  textAlign: TextAlign.center,
                                  size: Get.height * 0.014,
                                  fontFamily: 'GilroyMedium',
                                ),
                        ),
                      );
                    }),
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
                      title: 'Entry: ',
                      subTitle: 'N${display(item.entry)}',
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
              children: [
                textItem(
                  title: 'Game: ',
                  subTitle: item.game!.toUpperCase(),
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Tournament Type: ',
                  subTitle: item.tType!,
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
                  subTitle: item.registrationDate!,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Tournament: ',
                  subTitle: item.tournamentDate!,
                ),
                Gap(Get.height * 0.01),
                Divider(
                  height: 0,
                  color: AppColor().lightItemsColor,
                  thickness: 0.5,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Prize Pool: ',
                  subTitle: 'N${display(item.prizePool)}',
                  color: AppColor().secondaryGreenColor,
                  titleFamily: 'GilroySemiBold',
                  subTitleFamily: 'GilroyBold',
                  titleSize: 14.0,
                  subTitleSize: 16.0,
                ),
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
