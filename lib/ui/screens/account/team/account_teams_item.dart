import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/ui/screens/account/team/edit_team_profile.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
          (item.profilePicture == null)
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
              : Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CachedNetworkImage(
                      height: Get.height * 0.08,
                      width: Get.height * 0.08,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
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
                      imageUrl: item.profilePicture!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(color: AppColor().primaryWhite),
                          image: DecorationImage(
                              image: NetworkImage(item.profilePicture!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    if (item.isVerified == true)
                      SvgPicture.asset(
                        "assets/images/svg/check_badge.svg",
                        height: Get.height * 0.025,
                      )
                  ],
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
                                  builder: (ctx) => EditTeamPage(team: item)));
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
                            fontFamily: 'InterBold',
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
                            fontFamily: 'Inter',
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
                            fontFamily: 'InterMedium',
                            textAlign: TextAlign.start,
                            color: AppColor().greySix,
                          ),
                        ],
                      ),
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
