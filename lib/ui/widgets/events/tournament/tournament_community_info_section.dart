import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentCommunityInfoSection extends StatelessWidget {
  final EventModel eventDetails;

  const TournamentCommunityInfoSection({
    Key? key,
    required this.eventDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Organizing Community
          CustomText(
              title: 'Organising Community',
              size: 20,
              fontFamily: 'InterSemiBold',
              color: AppColor().primaryWhite),
          Gap(Get.height * 0.02),
          _buildCommunityInfo(),
          Gap(Get.height * 0.01),
          CustomText(
              title: eventDetails.community!.bio != ''
                  ? eventDetails.community!.bio!.toSentenceCase()
                  : 'Bio: Nil',
              size: Get.height * 0.015,
              fontFamily: 'Inter',
              textAlign: TextAlign.left,
              height: 1.5,
              color: AppColor().greyEight),
          Gap(Get.height * 0.02),
          GestureDetector(
            onTap: () =>
                Get.to(AccountCommunityDetail(item: eventDetails.community!)),
            child: Center(
              child: CustomText(
                  title: 'See full profile',
                  size: 14,
                  fontFamily: 'InterMedium',
                  underline: TextDecoration.underline,
                  color: AppColor().primaryColor),
            ),
          ),

          Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 0.5,
          ),

          // Partners
          CustomText(
              title: 'Partners',
              size: 20,
              fontFamily: 'InterSemiBold',
              color: AppColor().primaryWhite),
          Gap(Get.height * 0.02),
          _buildPartnerInfo(),
        ],
      ),
    );
  }

  Widget _buildCommunityInfo() {
    return GestureDetector(
      onTap: () =>
          Get.to(AccountCommunityDetail(item: eventDetails.community!)),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              eventDetails.community!.logo == null
                  ? Container(
                      height: Get.height * 0.04,
                      width: Get.height * 0.04,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/svg/people.svg',
                      ),
                    )
                  : OtherImage(
                      itemSize: Get.height * 0.04,
                      image: eventDetails.community!.logo),
              if (eventDetails.community!.isVerified!)
                SvgPicture.asset("assets/images/svg/check_badge.svg",
                    width: Get.height * 0.015),
            ],
          ),
          Gap(Get.height * 0.015),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  title: eventDetails.community!.name!.toCapitalCase(),
                  size: 14,
                  fontFamily: 'InterMedium',
                  color: AppColor().primaryWhite),
              Gap(Get.height * 0.005),
              CustomText(
                  title: 'No members',
                  size: Get.height * 0.015,
                  fontFamily: 'Inter',
                  textAlign: TextAlign.left,
                  height: 1.5,
                  color: AppColor().greyEight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerInfo() {
    // Using the community info for now as partner data
    return Row(
      children: [
        eventDetails.community!.logo == null
            ? Container(
                height: Get.height * 0.04,
                width: Get.height * 0.04,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/images/svg/people.svg',
                ),
              )
            : OtherImage(
                itemSize: Get.height * 0.04,
                image: eventDetails.community!.logo),
        Gap(Get.height * 0.015),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                title: eventDetails.community!.name!.toCapitalCase(),
                size: 14,
                fontFamily: 'InterMedium',
                color: AppColor().primaryWhite),
            Gap(Get.height * 0.005),
            CustomText(
                title: 'No members',
                size: Get.height * 0.015,
                fontFamily: 'Inter',
                textAlign: TextAlign.left,
                height: 1.5,
                color: AppColor().greyEight),
          ],
        ),
      ],
    );
  }
}
