import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SuggestedProfileItem extends StatefulWidget {
  final UserModel item;
  final bool? onFilterPage;
  const SuggestedProfileItem({
    super.key,
    required this.item,
    this.onFilterPage,
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
        decoration: BoxDecoration(
            color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (widget.item.profile!.profilePicture == null)
                  ? Container(
                      height: widget.onFilterPage == true
                          ? Get.height * 0.1
                          : Get.height * 0.11,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/png/placeholder.png'),
                            fit: BoxFit.cover),
                      ),
                    )
                  : CachedNetworkImage(
                      height: widget.onFilterPage == true
                          ? Get.height * 0.1
                          : Get.height * 0.11,
                      width: double.infinity,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: SizedBox(
                          height: Get.height * 0.05,
                          width: Get.height * 0.05,
                          child: CircularProgressIndicator(
                              color: AppColor().primaryColor,
                              value: progress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: AppColor().primaryColor),
                      imageUrl: widget.item.profile!.profilePicture,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(widget.item.profile!.profilePicture),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              const Spacer(),
                Gap(Get.height * 0.01),
                Padding(
                  padding: EdgeInsets.all(Get.height * 0.02),
                  child: Column(
                    children: [
                    CustomText(
                  title: widget.item.fullName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  color: AppColor().primaryWhite,
                  fontFamily: "GilroySemiBold",
                  size: 14,
                ),
                const Gap(2),
                CustomText(
                  title: "@${widget.item.userName}",
                  color: AppColor().greyFour,
                  fontFamily: "GilroyRegular",
                  size: 12,
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
                                    size: 12,
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
              ],
            ),
            Positioned(
              top: Get.height * 0.065,
              left: Get.width * 0.13,
              child: widget.item.profile!.profilePicture != null
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
            ),
          ],
        ),
      ),
    );
  }
}





class SuggestedProfileList extends StatefulWidget {
  final UserModel item;
  final bool? onFilterPage;
  const SuggestedProfileList({
    super.key,
    required this.item,
    this.onFilterPage,
  });

  @override
  State<SuggestedProfileList> createState() => _SuggestedProfileListState();
}

class _SuggestedProfileListState extends State<SuggestedProfileList> {
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
        height: Get.height * 0.4,
        width: Get.width * 0.55,
        //padding: EdgeInsets.all(Get.height * 0.02),
        decoration: BoxDecoration(
            color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (widget.item.profile!.profilePicture == null)
                  ? Container(
                      height: widget.onFilterPage == true
                          ? Get.height * 0.1
                          : Get.height * 0.12,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/png/placeholder.png'),
                            fit: BoxFit.cover),
                      ),
                    )
                  : CachedNetworkImage(
                      height: widget.onFilterPage == true
                          ? Get.height * 0.1
                          : Get.height * 0.12,
                      width: double.infinity,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: SizedBox(
                          height: Get.height * 0.05,
                          width: Get.height * 0.05,
                          child: CircularProgressIndicator(
                              color: AppColor().primaryColor,
                              value: progress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: AppColor().primaryColor),
                      imageUrl: widget.item.profile!.profilePicture,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(widget.item.profile!.profilePicture),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              const Spacer(),
                Gap(Get.height * 0.01),
                Padding(
                  padding: EdgeInsets.all(Get.height * 0.02),
                  child: Column(
                    children: [
                      CustomText(
                    title: widget.item.fullName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    color: AppColor().primaryWhite,
                    fontFamily: "GilroySemiBold",
                    size: 14,
                  ),
                  const Gap(2),
                  CustomText(
                    title: "@${widget.item.userName}",
                    color: AppColor().greyFour,
                    fontFamily: "GilroyRegular",
                    size: 14,
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
                                      size: 14,
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
              ],
            ),
            Positioned(
              top: Get.height * 0.065,
              left: Get.width * 0.19,
              child: widget.item.profile!.profilePicture != null
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
            ),
          ],
        ),
      ),
    );
  }
}