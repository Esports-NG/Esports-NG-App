import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ContributorItem extends StatelessWidget {
  const ContributorItem(
      {super.key, required this.contributor, this.isOnContributorsPage});
  final Player contributor;
  final bool? isOnContributorsPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.02),
      width: Get.width * 0.45,
      decoration: BoxDecoration(
          color: AppColor().bgDark,
          border: Border.all(color: AppColor().darkGrey),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
          mainAxisAlignment: isOnContributorsPage != null
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: isOnContributorsPage != null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Expanded(
              child: contributor.profile!.profilePicture == null
                  ? Container(
                      width: isOnContributorsPage != null
                          ? null
                          : Get.height * 0.07,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/svg/people.svg',
                      ),
                    )
                  : CachedNetworkImage(
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
                      imageUrl: contributor.profile!.profilePicture!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColor().primaryWhite, width: 2),
                          image: DecorationImage(
                              image: NetworkImage(
                                  contributor.profile!.profilePicture!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
            ),
            Gap(Get.height * 0.02),
            Column(
                crossAxisAlignment: isOnContributorsPage != null
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: contributor.fullName,
                    color: AppColor().primaryWhite,
                    fontFamily: "GilroySemiBold",
                  ),
                  Gap(Get.height * 0.005),
                  CustomText(
                    title: "Contributor",
                    color: AppColor().greyFour,
                  ),
                ])
          ]),
    );
  }
}
