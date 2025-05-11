import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SocialEventItem extends StatelessWidget {
  final EventModel item;
  final bool? onDetailsPage;
  const SocialEventItem({super.key, required this.item, this.onDetailsPage});

  @override
  Widget build(BuildContext context) {
    // final display = createDisplay(
    //   roundingType: RoundingType.floor,
    //   length: 15,
    //   decimal: 10,
    // );
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
          GestureDetector(
            onTap: () => Helpers().showImagePopup(context, item.banner!),
            child: Stack(
              children: [
                (item.banner == null)
                    ? Container(
                        height: Get.height * 0.22,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/png/placeholder.png'),
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
                        imageUrl: item.banner!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
                                image: NetworkImage(item.banner!),
                                fit: BoxFit.cover),
                          ),
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
                        titleFamily: 'InterMedium',
                        subTitleFamily: 'InterSemiBold',
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                  title: item.name,
                  size: 18,
                  fontFamily: 'InterSemiBold',
                  textAlign: TextAlign.start,
                  color: AppColor().greyTwo,
                ),
                Gap(Get.height * 0.01),
                Divider(
                  height: 0,
                  color: AppColor().lightItemsColor.withOpacity(0.2),
                  thickness: 0.5,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Date: ',
                  subTitle:
                      "${DateFormat.MMM().format(item.startDate!)} ${item.startDate!.day}, ${item.startDate!.year}",
                ),
                Visibility(
                  visible: onDetailsPage != null,
                  child: Column(
                    children: [
                      Gap(Get.height * 0.01),
                      textItem(
                        title: 'Registration: ',
                        subTitle:
                            "${DateFormat.MMM().format(item.regStart!)} ${item.regStart!.day}, ${item.regStart!.year} - ${DateFormat.MMM().format(item.regEnd!)} ${item.regEnd!.day}, ${item.regEnd!.year}",
                      ),
                    ],
                  ),
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Venue: ',
                  subTitle: item.venue!,
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Event link: ',
                  subTitle: item.linkForBracket,
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
          fontFamily: titleFamily ?? 'Inter',
          textAlign: TextAlign.start,
          color: color ?? AppColor().greyTwo,
        ),
        CustomText(
          title: subTitle,
          size: subTitleSize ?? 14,
          fontFamily: subTitleFamily ?? 'InterSemiBold',
          textAlign: TextAlign.start,
          color: color ?? AppColor().greyTwo,
        ),
      ],
    );
  }
}
