// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialEventDetails extends StatefulWidget {
  final EventModel item;
  const SocialEventDetails({super.key, required this.item});

  @override
  State<SocialEventDetails> createState() => _SocialEventDetailsState();
}

class _SocialEventDetailsState extends State<SocialEventDetails> {
  final authController = Get.put(AuthRepository());
  final communityController = Get.put(CommunityRepository());

  List<Map<String, dynamic>>? _communityFollowers;
  bool _isFollowing = false;
  bool _isLoading = true;

  Future getCommunityFollowers() async {
    var followers = await communityController
        .getCommunityFollowers(widget.item.community!.id!);
    setState(() {
      _communityFollowers = followers;
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
  initState() {
    print(widget.item.toJson());
    getCommunityFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Helpers().showImagePopup(context,
                                  "${ApiLink.imageUrl}${widget.item.banner}"),
              child: Stack(
                alignment: Alignment.bottomLeft,
                clipBehavior: Clip.none,
                children: [
                  widget.item.banner == null
                      ? Container(
                          height: Get.height * 0.2,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/png/tournament_cover.png'),
                                fit: BoxFit.cover,
                                opacity: 0.2),
                          ),
                        )
                      : CachedNetworkImage(
                          // height: Get.height * 0.15,
                          width: double.infinity,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                                child: SizedBox(
                                  // height: Get.height * 0.2,
                                  // width: Get.height * 0.05,
                                  child: CircularProgressIndicator(
                                      color: AppColor().primaryWhite,
                                      value: progress.progress),
                                ),
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: AppColor().primaryColor),
                          imageUrl: '${ApiLink.imageUrl}${widget.item.banner}',
                          imageBuilder: (context, imageProvider) => Image.network(
                                '${ApiLink.imageUrl}${widget.item.banner}',
                                opacity: const AlwaysStoppedAnimation(0.5),
                                fit: BoxFit.cover,
                              )
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: const BorderRadius.only(
                          //         topLeft: Radius.circular(10),
                          //         topRight: Radius.circular(10)),
                          //     image: DecorationImage(
                          //         image: NetworkImage(
                          //             '${ApiLink.imageUrl}${widget.item.banner}'),
                          //         fit: BoxFit.cover,
                          //         opacity: 0.6),
                          //   ),
                          // ),
                          ),
                  Positioned(
                    top: Get.height * 0.04,
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GoBackButton(onPressed: () => Get.back()),
                        Padding(
                          padding: EdgeInsets.only(right: Get.height * 0.02),
                          child: InkWell(
                            child: Icon(
                              Icons.settings,
                              color: AppColor().primaryWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            title: widget.item.name,
                            weight: FontWeight.w500,
                            size: 24,
                            fontFamily: 'GilroySemiBold',
                            color: AppColor().primaryWhite),
                        CustomText(
                          title: "2000 Registered",
                          color: AppColor().primaryWhite,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Gap(Get.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: widget.item.description,
                    maxLines: 5,
                    size: 12,
                    height: 1.3,
                    overflow: TextOverflow.ellipsis,
                    color: AppColor().primaryWhite.withOpacity(0.6),
                  ),
                  Gap(Get.height * 0.02),
                  CustomText(
                    title: "Event Details",
                    color: AppColor().primaryWhite,
                    fontFamily: "GilroyBold",
                    size: 20,
                  ),
                  Gap(Get.height * 0.01),
                  detail(
                      title: "Registration:",
                      value: CustomText(
                        fontFamily: "GilroyMedium",
                        title:
                            "${DateFormat.MMMM().format(widget.item.regStart!)} ${widget.item.regStart!.day}, ${widget.item.regStart!.year} - ${DateFormat.MMMM().format(widget.item.regEnd!)} ${widget.item.regEnd!.day}, ${widget.item.regEnd!.year}",
                        color: AppColor().primaryWhite,
                      )),
                  Gap(Get.height * 0.005),
                  detail(
                      title: "Start Date:",
                      value: CustomText(
                        fontFamily: "GilroyMedium",
                        title:
                            "${DateFormat.MMMM().format(widget.item.startDate!)} ${widget.item.startDate!.day}, ${widget.item.startDate!.year}",
                        color: AppColor().primaryWhite,
                      )),
                  Gap(Get.height * 0.005),
                  detail(
                      title: "Time and Venue:",
                      value: CustomText(
                        fontFamily: "GilroyMedium",
                        title: "- ${widget.item.venue}",
                        color: AppColor().primaryWhite,
                      )),
                  Gap(Get.height * 0.005),
                  detail(
                      title: "Event Link:",
                      value: InkWell(
                        onTap: () =>
                            launchUrl(Uri.parse(widget.item.linkForBracket!)),
                        child: CustomText(
                            title: widget.item.linkForBracket,
                            weight: FontWeight.w400,
                            size: Get.height * 0.017,
                            fontFamily: 'GilroyMedium',
                            underline: TextDecoration.underline,
                            decorationColor: AppColor().primaryColor,
                            color: AppColor().primaryColor),
                      )),
                  Gap(Get.height * 0.02),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {},
                    child: Container(
                      height: Get.height * 0.06,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColor().primaryColor,
                      ),
                      child:
                          // (authController.signInStatus == SignInStatus.loading)
                          //     ? const LoadingWidget()
                          //     :
                          Center(
                              child: CustomText(
                        title: 'Register Now',
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.018,
                        fontFamily: 'GilroyMedium',
                      )),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColor().lightItemsColor.withOpacity(0.3),
              height: Get.height * 0.05,
              thickness: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      title: 'Organising Community',
                      weight: FontWeight.w400,
                      size: Get.height * 0.019,
                      fontFamily: 'GilroySemiBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.02),
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          widget.item.community!.logo == null
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
                              : InkWell(
                                onTap: () => Get.to(()),
                                child: OtherImage(
                                    itemSize: Get.height * 0.04,
                                    image: widget.item.community!.logo),
                              ),
                        ],
                      ),
                      Gap(Get.height * 0.015),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              title:
                                  widget.item.community!.name!.toCapitalCase(),
                              weight: FontWeight.w400,
                              size: Get.height * 0.017,
                              fontFamily: 'GilroyMedium',
                              color: AppColor().primaryWhite),
                          Gap(Get.height * 0.005),
                          CustomText(
                              title: 'No members',
                              weight: FontWeight.w400,
                              size: Get.height * 0.015,
                              fontFamily: 'GilroyRegular',
                              textAlign: TextAlign.left,
                              height: 1.5,
                              color: AppColor().greyEight),
                        ],
                      ),
                    ],
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: widget.item.community!.bio != ''
                          ? widget.item.community!.bio!.toSentenceCase()
                          : 'Bio: Nil',
                      weight: FontWeight.w400,
                      size: Get.height * 0.015,
                      fontFamily: 'GilroyRegular',
                      textAlign: TextAlign.left,
                      height: 1.5,
                      color: AppColor().greyEight),
                  Gap(Get.height * 0.02),
                  InkWell(
                    child: Center(
                      child: CustomText(
                          title: 'See full profile',
                          weight: FontWeight.w400,
                          size: Get.height * 0.017,
                          fontFamily: 'GilroyMedium',
                          underline: TextDecoration.underline,
                          color: AppColor().primaryColor),
                    ),
                  ),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 0.5,
                  ),
                  CustomText(
                      title: 'Partners',
                      weight: FontWeight.w400,
                      size: Get.height * 0.019,
                      fontFamily: 'GilroySemiBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.02),
                  Row(
                    children: [
                      widget.item.community!.logo == null
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
                              image: widget.item.community!.logo),
                      Gap(Get.height * 0.015),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              title:
                                  widget.item.community!.name!.toCapitalCase(),
                              weight: FontWeight.w400,
                              size: Get.height * 0.017,
                              fontFamily: 'GilroyMedium',
                              color: AppColor().primaryWhite),
                          Gap(Get.height * 0.005),
                          CustomText(
                              title: 'No members',
                              weight: FontWeight.w400,
                              size: Get.height * 0.015,
                              fontFamily: 'GilroyRegular',
                              textAlign: TextAlign.left,
                              height: 1.5,
                              color: AppColor().greyEight),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColor().lightItemsColor.withOpacity(0.3),
              height: Get.height * 0.05,
              thickness: 4,
            ),
            Gap(Get.height * 0.02),
          ],
        ),
      ),
    );
  }

  tournamentDetails({String? title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
              title: title,
              weight: FontWeight.w400,
              size: Get.height * 0.017,
              fontFamily: 'GilroyMedium',
              underline: TextDecoration.underline,
              color: AppColor().greySix),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColor().primaryColor,
            size: Get.height * 0.018,
          ),
        ],
      ),
    );
  }

  detail({String? title, required Widget value}) {
    return Row(
      children: [
        CustomText(
          title: title,
          color: AppColor().primaryWhite.withOpacity(0.75),
        ),
        const Gap(2),
        value
      ],
    );
  }
}
