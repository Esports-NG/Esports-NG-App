import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AccountEventsItem extends StatefulWidget {
  final EventModel item;
  final bool? onDetailsPage;
  const AccountEventsItem({super.key, required this.item, this.onDetailsPage});

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
        border: Border.all(color: AppColor().greyEight, width: 0.5),
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
            onTap: () => Helpers().showImagePopup(
                context, "${ApiLink.imageUrl}${widget.item.banner}"),
            child: Stack(
              children: [
                (widget.item.banner == null)
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
                widget.item.type == "tournament"
                    ? Positioned(
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
                                  color:
                                      AppColor().primaryColor.withOpacity(0.05),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/svg/rank.svg'),
                                  CustomText(
                                    title: widget.item.type!.capitalize,
                                    color: AppColor().pureBlackColor,
                                    textAlign: TextAlign.center,
                                    size: Get.height * 0.014,
                                    fontFamily: 'InterMedium',
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
                                  color:
                                      AppColor().primaryColor.withOpacity(0.05),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/svg/rank.svg'),
                                  CustomText(
                                    title: 'Ongoing registration',
                                    color: AppColor().pureBlackColor,
                                    textAlign: TextAlign.center,
                                    size: Get.height * 0.014,
                                    fontFamily: 'InterMedium',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                widget.item.type == "social"
                    ? Positioned(
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
                                  color:
                                      AppColor().primaryColor.withOpacity(0.05),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/svg/rank.svg'),
                                  CustomText(
                                    title:
                                        "${widget.item.type} Event".capitalize,
                                    color: AppColor().pureBlackColor,
                                    textAlign: TextAlign.center,
                                    size: Get.height * 0.014,
                                    fontFamily: 'InterMedium',
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
                                  color:
                                      AppColor().primaryColor.withOpacity(0.05),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/svg/rank.svg'),
                                  CustomText(
                                    title: 'Ongoing registration',
                                    color: AppColor().pureBlackColor,
                                    textAlign: TextAlign.center,
                                    size: Get.height * 0.014,
                                    fontFamily: 'InterMedium',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                //Entry Fee Widget
                widget.item.type == "tournament"
                    ? Positioned(
                        right: Get.height * 0.02,
                        bottom: Get.height * 0.02,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:
                                AppColor().secondaryGreenColor.withOpacity(0.8),
                          ),
                          child: Center(
                            child: CustomText(
                              title: 'Entry Fee: ${widget.item.entryFee}',
                              color: AppColor().primaryBackGroundColor,
                              textAlign: TextAlign.center,
                              size: 13,
                              fontFamily: "InterBold",
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
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
                widget.item.type == "tournament"
                    ? textItem(
                        title: 'Game: ',
                        subTitle: widget.item.games!.length != 0
                            ? widget.item.games![0].name!
                            : "",
                      )
                    : const SizedBox(),
                widget.item.type == "tournament"
                    ? Visibility(
                        visible: widget.onDetailsPage == null,
                        child: Column(
                          children: [
                            Gap(Get.height * 0.01),
                            textItem(
                              title: 'Tournament Name: ',
                              subTitle: widget.item.name,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                widget.item.type == "social"
                    ? CustomText(
                        title: widget.item.name,
                        color: AppColor().primaryWhite,
                        fontFamily: "InterSemiBold",
                        size: 18,
                      )
                    : const SizedBox(),
                widget.item.type == "tournament"
                    ? Gap(Get.height * 0.01)
                    : const SizedBox(),
                widget.item.type == "tournament"
                    ? textItem(
                        title: 'Tournament type: ',
                        subTitle: widget.item.tournamentType == ''
                            ? 'Teams'
                            : widget.item.tournamentType!.capitalize,
                      )
                    : const SizedBox(),
                Visibility(
                  visible: widget.item.type == "tournament",
                  child: Column(
                    children: [
                      Gap(Get.height * 0.01),
                      textItem(
                        title: 'Registration Date: ',
                        subTitle:
                            "${DateFormat.MMM().format(widget.item.regStart!)} ${widget.item.regStart!.day}, ${widget.item.regStart!.year} - ${DateFormat.MMM().format(widget.item.regEnd!)} ${widget.item.regEnd!.day}, ${widget.item.regEnd!.year}",
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.onDetailsPage != null,
                  child: Column(
                    children: [
                      Gap(Get.height * 0.01),
                      textItem(
                        title: 'Tournament Date: ',
                        subTitle:
                            "${DateFormat.MMM().format(widget.item.startDate!)} ${widget.item.startDate!.day}, ${widget.item.startDate!.year} - ${DateFormat.MMM().format(widget.item.endDate!)} ${widget.item.endDate!.day}, ${widget.item.endDate!.year}",
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.onDetailsPage != null,
                  child: Column(
                    children: [
                      Gap(Get.height * 0.01),
                      textItem(
                        title: 'Game Modes: ',
                        subTitle:
                            widget.item.gameMode.toString(),
                      ),
                    ],
                  ),
                ),
                Gap(Get.height * 0.01),
                Divider(
                  height: 0,
                  color: AppColor().lightItemsColor.withOpacity(0.2),
                  thickness: 0.5,
                ),
                Gap(Get.height * 0.01),
                Visibility(
                  visible: widget.item.type == "tournament",
                  child: textItem(
                    title: 'Prize Pool: ',
                    subTitle: '${widget.item.prizePool}',
                    color: AppColor().secondaryGreenColor,
                    titleFamily: 'InterSemiBold',
                    subTitleFamily: 'InterSemiBold',
                    titleSize: 14.0,
                    subTitleSize: 16.0,
                  ),
                ),
                widget.item.type == "social"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textItem(
                            title: 'Date: ',
                            subTitle:
                                "${DateFormat.MMM().format(widget.item.startDate!)} ${widget.item.startDate!.day}, ${widget.item.startDate!.year}",
                          ),
                          Visibility(
                            child: Column(
                              children: [
                                Gap(Get.height * 0.01),
                                textItem(
                                  title: 'Registration: ',
                                  subTitle:
                                      "${DateFormat.MMM().format(widget.item.regStart!)} ${widget.item.regStart!.day}, ${widget.item.regStart!.year} - ${DateFormat.MMM().format(widget.item.regEnd!)} ${widget.item.regEnd!.day}, ${widget.item.regEnd!.year}",
                                ),
                              ],
                            ),
                          ),
                          Gap(Get.height * 0.01),
                          textItem(
                            title: 'Venue: ',
                            subTitle: widget.item.venue!,
                          ),
                          Gap(Get.height * 0.01),
                          textItem(
                            title: 'Event link: ',
                            subTitle: widget.item.linkForBracket,
                          ),
                          Gap(Get.height * 0.01),
                        ],
                      )
                    : const SizedBox(),
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
        Flexible(
          child: CustomText(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            title: subTitle,
            size: subTitleSize ?? 14,
            fontFamily: subTitleFamily ?? 'InterSemiBold',
            textAlign: TextAlign.start,
            color: color ?? AppColor().greyTwo,
          ),
        ),
      ],
    );
  }
}
