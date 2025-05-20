import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';

class SocialLinksSection extends StatelessWidget {
  const SocialLinksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                title: 'Join our Community:',
                fontFamily: 'InterSemiBold',
                size: 16,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.02),
            ],
          ),
        ),
        Gap(Get.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
          child: Row(
            children: [
              SvgPicture.asset('assets/images/svg/discord.svg'),
              Gap(Get.height * 0.01),
              SvgPicture.asset('assets/images/svg/twitter.svg'),
              Gap(Get.height * 0.01),
              SvgPicture.asset('assets/images/svg/telegram.svg'),
              Gap(Get.height * 0.01),
              SvgPicture.asset('assets/images/svg/meduim.svg'),
            ],
          ),
        ),
      ],
    );
  }
}
