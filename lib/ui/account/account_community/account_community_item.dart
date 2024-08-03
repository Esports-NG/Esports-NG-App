import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:e_sport/ui/account/account_community/edit_community_profile.dart';

class AccountCommunityItem extends StatelessWidget {
  final CommunityModel item;
  const AccountCommunityItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            AppColor().greyGradient.withOpacity(0.5),
            AppColor().primaryBackGroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColor().lightItemsColor.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (item.cover == null)
              ? Container(
                  height: Get.height * 0.08,
                  width: Get.height * 0.08,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/svg/people.svg',
                  ),
                )
              : CachedNetworkImage(
                  height: Get.height * 0.08,
                  width: Get.height * 0.08,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: SizedBox(
                      height: Get.height * 0.02,
                      width: Get.height * 0.02,
                      child: CircularProgressIndicator(
                          color: AppColor().primaryColor,
                          value: progress.progress),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, color: AppColor().primaryColor),
                  imageUrl: item.logo!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColor().primaryWhite, width: 2),
                      image: DecorationImage(
                          image: NetworkImage(item.logo!), fit: BoxFit.cover),
                    ),
                  ),
                ),
          Gap(Get.height * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CustomFillButton(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const EditCommunityPage()));
                        },
                        buttonText: 'Edit',
                        width: 80,
                        height: 40,
                      ),
                    ),
                    Positioned(
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
                            const SizedBox(
                              height: 15,
                            ),
                            Divider(
                              color:
                                  AppColor().lightItemsColor.withOpacity(0.3),
                              height: Get.height * 0.03,
                              thickness: 0.5,
                            ),
                            CustomText(
                              title: item.bio!.toSentenceCase(),
                              size: 12,
                              fontFamily: 'GilroyMedium',
                              textAlign: TextAlign.start,
                              color: AppColor().greySix,
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
