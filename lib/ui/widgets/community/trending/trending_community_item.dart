import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommunityItem extends StatefulWidget {
  final CommunityModel item;
  const CommunityItem({
    super.key,
    required this.item,
  });

  @override
  State<CommunityItem> createState() => _CommunityItemState();
}

class _CommunityItemState extends State<CommunityItem> {
  final communityController = Get.put(CommunityRepository());
  final authController = Get.put(AuthRepository());
  bool _isFollowing = false;
  bool _isLoading = true;

  Future getCommunityFollowers() async {
    print(widget.item.id);
    var followers =
        await communityController.getCommunityFollowers(widget.item.slug!);
    setState(() {
      if (followers.any(
          (element) => element["user_id"]["id"] == authController.user!.id)) {
        _isFollowing = true;
      } else {
        _isFollowing = false;
      }
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getCommunityFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: Get.height * 0.4,
          width: Get.width * 0.55,
          decoration: BoxDecoration(
            color: AppColor().bgDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColor().greyEight,
            ),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: Get.height * 0.1,
                width: Get.width * 0.55,
                decoration: BoxDecoration(
                  color: AppColor().bgDark,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/png/placeholder.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              Gap(Get.height * 0.01),
              CustomText(
                title: widget.item.name,
                size: 14,
                fontFamily: 'InterSemiBold',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
              ),
              Gap(Get.height * 0.01),
              CustomText(
                title: widget.item.bio,
                size: 12,
                fontFamily: 'Inter',
                color: AppColor().greySix,
              ),
              Gap(Get.height * 0.02),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.all(Get.height * 0.015),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: AppColor().primaryColor,
                      ),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const ButtonLoader()
                          : CustomText(
                              title: 'Follow',
                              size: 14,
                              fontFamily: 'InterMedium',
                              color: AppColor().primaryColor,
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                OtherImage(
                    image: widget.item.logo,
                    height: Get.height * 0.07,
                    width: Get.width * 0.07),
                if (widget.item.isVerified == true)
                  SvgPicture.asset(
                    "assets/images/svg/check_badge.svg",
                    height: Get.height * 0.025,
                  )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
