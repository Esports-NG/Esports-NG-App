import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SuggestedProfileItem extends StatefulWidget {
  final UserModel item;
  const SuggestedProfileItem({
    super.key,
    required this.item,
  });

  @override
  State<SuggestedProfileItem> createState() => _SuggestedProfileItemState();
}

class _SuggestedProfileItemState extends State<SuggestedProfileItem> {
  final authController = Get.put(AuthRepository());
  bool _isLoading = true;
  bool _isFollowing = false;

  Future<void> getFollowersList() async {
    setState(() {
      _isLoading = true;
    });
    var followersList =
        await authController.getProfileFollowerList(widget.item.id!);
    setState(() {
      if (followersList.any(
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
    getFollowersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(UserDetails(id: widget.item.id!)),
      child: Container(
        width: Get.height * 0.23,
        padding: EdgeInsets.all(Get.height * 0.02),
        decoration: BoxDecoration(
            color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.item.profile!.profilePicture != null
                ? CachedNetworkImage(
                    imageUrl: widget.item.profile!.profilePicture,
                    width: Get.height * 0.08,
                    height: Get.height * 0.08,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor().greyEight),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                  )
                : Container(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/svg/people.svg',
                    ),
                  ),
            Gap(Get.height * 0.02),
            CustomText(
              title: widget.item.fullName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              color: AppColor().primaryWhite,
              fontFamily: "GilroySemiBold",
              size: 16,
            ),
            const Gap(2),
            CustomText(
              title: "@${widget.item.userName}",
              color: AppColor().greyFour,
              fontFamily: "GilroyRegular",
              size: 15,
            ),
            Gap(Get.height * 0.015),
            widget.item.id == authController.user!.id
                ? Container()
                : InkWell(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      var message =
                          await authController.followUser(widget.item.id!);

                      if (message != "error") {
                        setState(() {
                          _isFollowing = !_isFollowing;
                        });
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: _isFollowing || _isLoading
                              ? null
                              : AppColor().primaryColor,
                          borderRadius: BorderRadius.circular(99),
                          border: _isFollowing || _isLoading
                              ? Border.all(color: AppColor().primaryColor)
                              : null),
                      child: Center(
                        child: _isLoading
                            ? const ButtonLoader()
                            : CustomText(
                                title: _isFollowing ? "Unfollow" : "Follow",
                                fontFamily: "GilroySemiBold",
                                size: 16,
                                color: _isFollowing || _isLoading
                                    ? AppColor().primaryColor
                                    : AppColor().primaryWhite,
                              ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
