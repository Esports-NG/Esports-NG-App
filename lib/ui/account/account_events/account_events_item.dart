import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountEventsItem extends StatefulWidget {
  final EventModel item;
  const AccountEventsItem({super.key, required this.item});

  @override
  State<AccountEventsItem> createState() => _AccountEventsItemState();
}

class _AccountEventsItemState extends State<AccountEventsItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor().lightItemsColor, width: 0.5),
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
              (widget.item.banner == null)
                  ? Container(
                      height: Get.height * 0.22,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/png/placeholder.png'),
                            fit: BoxFit.cover),
                      ),
                    )
                  : CachedNetworkImage(
                      height: Get.height * 0.22,
                      width: double.infinity,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: SizedBox(
                          height: Get.height * 0.05,
                          width: Get.height * 0.05,
                          child: CircularProgressIndicator(
                              color: AppColor().primaryWhite,
                              value: progress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: AppColor().primaryColor),
                      imageUrl: '${ApiLink.imageUrl}${widget.item.banner}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${ApiLink.imageUrl}${widget.item.banner}'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              Positioned(
                left: Get.height * 0.02,
                top: Get.height * 0.02,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColor().primaryWhite,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColor().primaryColor.withOpacity(0.05),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/images/svg/rank.svg'),
                          CustomText(
                            title: widget.item.rankType,
                            color: AppColor().pureBlackColor,
                            textAlign: TextAlign.center,
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyMedium',
                          ),
                        ],
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColor().primaryWhite,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColor().primaryColor.withOpacity(0.05),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/images/svg/rank.svg'),
                          CustomText(
                            title: 'Ongoing registration',
                            color: AppColor().pureBlackColor,
                            textAlign: TextAlign.center,
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyMedium',
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      title: 'Entry: ',
                      subTitle: 'N${widget.item.entryFee}',
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
                  subTitle: widget.item.name!.toUpperCase(),
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Tournament Name: ',
                  subTitle: widget.item.gameMode!.toCapitalCase(),
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Tournament Type: ',
                  subTitle: widget.item.tournamentType == ''
                      ? 'Teams'
                      : widget.item.tournamentType!,
                ),
                Gap(Get.height * 0.01),
                Divider(
                  height: 0,
                  color: AppColor().lightItemsColor.withOpacity(0.2),
                  thickness: 0.5,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Prize Pool: ',
                  subTitle: 'N${widget.item.prizePool}',
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
