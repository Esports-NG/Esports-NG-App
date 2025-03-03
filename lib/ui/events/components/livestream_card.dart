import 'package:e_sport/data/model/fixture_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LivestreamCard extends StatefulWidget {
  const LivestreamCard(
      {super.key, required this.backgroundColor, required this.livestream});

  final LinearGradient backgroundColor;
  final LivestreamModel livestream;

  @override
  State<LivestreamCard> createState() => _LivestreamCardState();
}

class _LivestreamCardState extends State<LivestreamCard> {
  bool dateHasPassed(DateTime itemDate) {
    final now = DateTime.now();
    final difference = now.difference(itemDate);

    if (difference.inDays > 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var formattedTime =
        "${int.parse(widget.livestream.time!.split(":")[0]) > 12 ? (int.parse(widget.livestream.time!.split(":")[0]) - 12).toString().padLeft(2, "0") : widget.livestream.time!.split(":")[0]}:${widget.livestream.time!.split(":")[1]} ${TimeOfDay(hour: int.parse(widget.livestream.time!.split(":")[0]), minute: int.parse(widget.livestream.time!.split(":")[1])).period.name.toUpperCase()}";
    return Container(
      width: Get.width * 0.9,
      decoration: BoxDecoration(
        gradient: widget.backgroundColor,
        image: DecorationImage(
            image: const AssetImage('assets/images/png/Fixture-zigzag.png'),
            alignment: Alignment(Get.width * -0.01, 0)),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().bgDark,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Get.height * 0.02, Get.height * 0.02,
            Get.height * 0.02, Get.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.livestream.user != null)
                        SizedBox(
                          child: CustomText(
                            title:
                                "${widget.livestream.user!.userName!.capitalizeFirst}'s Livestream ",
                            color: AppColor().primaryWhite,
                            fontFamily: 'Inter',
                            //textAlign: TextAlign.center,
                            size: 14,
                          ),
                        ),
                      Gap(Get.height * 0.002),
                      SizedBox(
                        child: CustomText(
                          title: widget.livestream.title!.toUpperCase(),
                          color: AppColor().primaryWhite,
                          fontFamily: 'InterSemiBold',
                          //textAlign: TextAlign.center,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      title: 'Livestream',
                    ),
                    Gap(Get.height * 0.0025),
                    dateHasPassed(widget.livestream.date!) == false
                        ? Stack(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColor().primaryWhite,
                                size: Get.height * 0.036,
                              ),
                              Positioned(
                                  top: Get.height * 0.006,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Icon(
                                    Icons.add,
                                    color: AppColor().primaryWhite,
                                    size: Get.height * 0.012,
                                    weight: 1000,
                                  )),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
            Gap(Get.height * 0.015),
            Center(
              child: GestureDetector(
                onTap: () => Helpers().showImagePopup(
                    context, widget.livestream.banner!),
                child: OtherImage(
                    width: 60,
                    height: 60,
                    image: widget.livestream.banner != null
                        ? widget.livestream.banner
                        : widget.livestream.banner),
              ),
            ),
            Gap(Get.height * 0.02),
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title:
                    "${DateFormat.yMMMEd().format(widget.livestream.date!)}, $formattedTime",
                color: AppColor().primaryWhite,
                fontFamily: 'InterSemiBold',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Gap(Get.height * 0.02),
            Divider(
              height: 0,
              color: AppColor().lightItemsColor,
              thickness: 0.2,
            ),
            Gap(Get.height * 0.01),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.24, vertical: Get.width * 0.0001),
                width: Get.width * 0.7,
                child: InkWell(
                  onTap: () => launchUrl(Uri.parse(widget.livestream.link!)),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcATop,
                    ),
                    child: Image.network(
                      '${widget.livestream.platform!.secondaryImage}',
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
