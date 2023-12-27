import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/team_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountTeamsItem extends StatelessWidget {
  final TeamModel item;
  const AccountTeamsItem({super.key, required this.item});

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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColor().primaryWhite, width: 2),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/png/placeholder.png'),
                        fit: BoxFit.cover),
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
                  imageUrl: '${ApiLink.imageUrl}${item.cover}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColor().primaryWhite, width: 2),
                      image: DecorationImage(
                          image:
                              NetworkImage('${ApiLink.imageUrl}${item.cover}'),
                          fit: BoxFit.cover),
                    ),
                  ),
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
                  title: item.members!.isEmpty
                      ? 'No member'
                      : item.membersCount == '1'
                          ? '${item.membersCount} member'
                          : '${item.membersCount} members',
                  size: 12,
                  fontFamily: 'GilroyRegular',
                  textAlign: TextAlign.start,
                  color: AppColor().greySix,
                ),
                Divider(
                  color: AppColor().lightItemsColor.withOpacity(0.3),
                  height: Get.height * 0.03,
                  thickness: 0.5,
                ),
                CustomText(
                  title: item.bio,
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
