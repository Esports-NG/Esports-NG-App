import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';

class ProfileSocialLinks extends StatelessWidget {
  final List<SocialLink>? socialLinks;

  const ProfileSocialLinks({
    Key? key,
    this.socialLinks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (socialLinks == null || socialLinks!.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              title: 'Follow my socials:',
              fontFamily: 'InterSemiBold',
              size: 16,
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.02),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                title: 'Follow my socials:',
                fontFamily: 'InterSemiBold',
                size: 16,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.02),
            ],
          ),
          Gap(Get.height * 0.02),
          Row(
            children: socialLinks!.map((link) {
              return Padding(
                padding: EdgeInsets.only(right: Get.height * 0.01),
                child: GestureDetector(
                  onTap: link.onTap,
                  child: SvgPicture.asset(link.iconPath),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class SocialLink {
  final String iconPath;
  final String url;
  final VoidCallback? onTap;

  SocialLink({
    required this.iconPath,
    required this.url,
    this.onTap,
  });
}
