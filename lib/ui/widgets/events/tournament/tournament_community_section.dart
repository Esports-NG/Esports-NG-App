import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:change_case/change_case.dart';

class TournamentCommunitySection extends StatelessWidget {
  final EventModel eventDetails;

  const TournamentCommunitySection({
    Key? key,
    required this.eventDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: 'Organising Community',
          size: 20,
          fontFamily: 'InterSemiBold',
          color: AppColor().primaryWhite,
        ),
        Gap(Get.height * 0.02),
        GestureDetector(
          onTap: () => Get.to(AccountCommunityDetail(
            item: eventDetails.community!,
          )),
          child: Row(
            children: [
              Stack(
                children: [
                  eventDetails.community!.logo == null
                      ? Container(
                          height: Get.height * 0.06,
                          width: Get.height * 0.06,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/svg/people.svg',
                          ),
                        )
                      : OtherImage(
                          itemSize: Get.height * 0.06,
                          image: eventDetails.community!.logo,
                        ),
                ],
              ),
              Gap(Get.height * 0.015),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: eventDetails.community!.name,
                    size: 16,
                    fontFamily: 'InterMedium',
                    color: AppColor().primaryWhite,
                  ),
                  Gap(Get.height * 0.005),
                  CustomText(
                    title: 'No members',
                    size: Get.height * 0.015,
                    fontFamily: 'Inter',
                    textAlign: TextAlign.left,
                    height: 1.5,
                    color: AppColor().greyEight,
                  ),
                ],
              ),
            ],
          ),
        ),
        Gap(Get.height * 0.01),
        CustomText(
          title: eventDetails.community!.bio != ''
              ? eventDetails.community!.bio!.toSentenceCase()
              : 'Bio: Nil',
          size: Get.height * 0.015,
          fontFamily: 'Inter',
          textAlign: TextAlign.left,
          height: 1.5,
          color: AppColor().greyEight,
        ),
        Gap(Get.height * 0.02),
        GestureDetector(
          onTap: () => Get.to(AccountCommunityDetail(
            item: eventDetails.community!,
          )),
          child: Center(
            child: CustomText(
              title: 'See full profile',
              size: 14,
              fontFamily: 'InterMedium',
              underline: TextDecoration.underline,
              color: AppColor().primaryColor,
            ),
          ),
        ),
        Divider(
          color: AppColor().lightItemsColor.withOpacity(0.3),
          height: Get.height * 0.05,
          thickness: 0.5,
        ),
        _buildPartnersSection(),
      ],
    );
  }

  Widget _buildPartnersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: 'Partners',
          size: 20,
          fontFamily: 'InterSemiBold',
          color: AppColor().primaryWhite,
        ),
        Gap(Get.height * 0.02),
        Row(
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
                    image: eventDetails.community!.logo,
                  ),
            Gap(Get.height * 0.015),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: eventDetails.community!.name,
                  size: 14,
                  fontFamily: 'InterMedium',
                  color: AppColor().primaryWhite,
                ),
                Gap(Get.height * 0.005),
                CustomText(
                  title: 'No members',
                  size: Get.height * 0.015,
                  fontFamily: 'Inter',
                  textAlign: TextAlign.left,
                  height: 1.5,
                  color: AppColor().greyEight,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
