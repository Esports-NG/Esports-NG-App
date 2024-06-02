import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
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
        await communityController.getCommunityFollowers(widget.item.id!);
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
                fontFamily: 'GilroySemiBold',
                weight: FontWeight.w400,
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
              ),
              Gap(Get.height * 0.01),
              CustomText(
                title: widget.item.bio,
                size: 12,
                fontFamily: 'GilroyRegular',
                weight: FontWeight.w400,
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
                              fontFamily: 'GilroyMedium',
                              weight: FontWeight.w400,
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
            (widget.item.logo == null)
                ? SvgPicture.asset(
                    'assets/images/svg/people.svg',
                    height: Get.height * 0.07,
                    width: Get.height * 0.07,
                  )
                : CachedNetworkImage(
                    height: Get.height * 0.07,
                    width: Get.height * 0.07,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: widget.item.logo!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(widget.item.logo!),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
