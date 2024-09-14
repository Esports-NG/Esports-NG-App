// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/social_event_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/profiles/components/recent_posts.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
  final socialEventController = Get.put(SocialEventRepository());
  final tournamentController = Get.put(TournamentRepository());
  final postController = Get.put(PostRepository());

  List<Map<String, dynamic>>? _communityFollowers;
  List<UserModel>? _participantList;
  bool _isFollowing = false;
  bool _isLoading = true;
  bool _isFetching = true;
  bool _isRegistering = false;
  bool _isRegistered = false;
  EventModel? _eventDetails;

  Future getParticipantList() async {
    setState(() {
      _isRegistering = true;
    });
    var response = await http.get(
        Uri.parse(ApiLink.getEventParticipants(widget.item.id!)),
        headers: {
          "Content-type": "application/json",
          "Authorization": "JWT ${authController.token}"
        });

    log(response.body);
    setState(() {
      _isRegistering = false;
      _participantList = userModelListFromJson(response.body);
      if (userModelListFromJson(response.body)
          .where((e) => e.id! == authController.user!.id!)
          .isNotEmpty) {
        _isRegistered = true;
      }
    });
  }

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

  Future getEventDetails() async {
    var event = await tournamentController.getEventDetails(widget.item.id!);
    setState(() {
      _eventDetails = event;
      _isFetching = false;
    });
  }

  @override
  initState() {
    getEventDetails();
    getCommunityFollowers();
    getParticipantList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _eventDetails == null && _isFetching
          ? const Center(child: ButtonLoader())
          : SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Helpers().showImagePopup(
                        context, "${ApiLink.imageUrl}${_eventDetails!.banner}"),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      clipBehavior: Clip.none,
                      children: [
                        _eventDetails!.banner == null
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
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                          child: SizedBox(
                                            // height: Get.height * 0.2,
                                            // width: Get.height * 0.05,
                                            child: CircularProgressIndicator(
                                                color: AppColor().primaryWhite,
                                                value: progress.progress),
                                          ),
                                        ),
                                errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: AppColor().primaryColor),
                                imageUrl:
                                    '${ApiLink.imageUrl}${_eventDetails!.banner}',
                                imageBuilder: (context, imageProvider) =>
                                    Image.network(
                                      '${ApiLink.imageUrl}${_eventDetails!.banner}',
                                      opacity:
                                          const AlwaysStoppedAnimation(0.5),
                                      fit: BoxFit.cover,
                                    )
                                // Container(
                                //   decoration: BoxDecoration(
                                //     borderRadius: const BorderRadius.only(
                                //         topLeft: Radius.circular(10),
                                //         topRight: Radius.circular(10)),
                                //     image: DecorationImage(
                                //         image: NetworkImage(
                                //             '${ApiLink.imageUrl}${_eventDetails!.banner}'),
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
                                padding:
                                    EdgeInsets.only(right: Get.height * 0.02),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  title: _eventDetails!.name,
                                  size: 24,
                                  fontFamily: 'InterSemiBold',
                                  color: AppColor().primaryWhite),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: AppColor().primaryBackGroundColor),
                                child: CustomText(
                                  title:
                                      "${_participantList?.length} Registered",
                                  color: AppColor().primaryWhite,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(Get.height * 0.03),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: _eventDetails!.description,
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
                          fontFamily: "InterSemiBold",
                          size: 20,
                        ),
                        Gap(Get.height * 0.01),
                        detail(
                            title: "Registration:",
                            value: CustomText(
                              fontFamily: "InterMedium",
                              title:
                                  "${DateFormat.MMMM().format(_eventDetails!.regStart!)} ${_eventDetails!.regStart!.day}, ${_eventDetails!.regStart!.year} - ${DateFormat.MMMM().format(_eventDetails!.regEnd!)} ${_eventDetails!.regEnd!.day}, ${_eventDetails!.regEnd!.year}",
                              color: AppColor().primaryWhite,
                            )),
                        Gap(Get.height * 0.005),
                        detail(
                            title: "Start Date:",
                            value: CustomText(
                              fontFamily: "InterMedium",
                              title:
                                  "${DateFormat.MMMM().format(_eventDetails!.startDate!)} ${_eventDetails!.startDate!.day}, ${_eventDetails!.startDate!.year}",
                              color: AppColor().primaryWhite,
                            )),
                        Gap(Get.height * 0.005),
                        detail(
                            title: "Time and Venue:",
                            value: CustomText(
                              fontFamily: "InterMedium",
                              title: "- ${_eventDetails!.venue}",
                              color: AppColor().primaryWhite,
                            )),
                        Gap(Get.height * 0.005),
                        detail(
                            title: "Event Link:",
                            value: InkWell(
                              onTap: () => launchUrl(
                                  Uri.parse(_eventDetails!.linkForBracket!)),
                              child: CustomText(
                                  title: _eventDetails!.linkForBracket,
                                  size: Get.height * 0.017,
                                  fontFamily: 'InterMedium',
                                  underline: TextDecoration.underline,
                                  decorationColor: AppColor().primaryColor,
                                  color: AppColor().primaryColor),
                            )),
                        Gap(Get.height * 0.02),
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () async {
                            setState(() {
                              _isRegistering = true;
                            });
                            if (_isRegistered) {
                              await tournamentController.unregisterForEvent(
                                  _eventDetails!.id!,
                                  "user",
                                  authController.user!.id!);
                              setState(() {
                                _isRegistered = false;
                              });
                            } else {
                              await socialEventController
                                  .registerForSocialEvent(_eventDetails!.id!);
                              setState(() {
                                _isRegistered = true;
                              });
                            }
                            setState(() {
                              _isRegistering = false;
                            });
                          },
                          child: Container(
                            height: Get.height * 0.06,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: _isRegistering
                                  ? Border.all(
                                      color: AppColor()
                                          .primaryColor
                                          .withOpacity(0.4),
                                      width: 1)
                                  : null,
                              color: _isRegistering
                                  ? Colors.transparent
                                  : AppColor().primaryColor,
                            ),
                            child: Center(
                                child: _isRegistering
                                    ? const ButtonLoader()
                                    : CustomText(
                                        title: _isRegistered
                                            ? "Unregister"
                                            : 'Register Now',
                                        color: AppColor().primaryWhite,
                                        size: Get.height * 0.018,
                                        fontFamily: 'InterMedium',
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
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            title: 'Organising Community',
                            size: Get.height * 0.019,
                            fontFamily: 'InterSemiBold',
                            color: AppColor().primaryWhite),
                        Gap(Get.height * 0.02),
                        GestureDetector(
                          onTap: () => Get.to(AccountCommunityDetail(
                              item: _eventDetails!.community!)),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  _eventDetails!.community!.logo == null
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
                                          image:
                                              _eventDetails!.community!.logo),
                                ],
                              ),
                              Gap(Get.height * 0.015),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      title: _eventDetails!.community!.name!
                                          .toCapitalCase(),
                                      size: Get.height * 0.017,
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
                        ),
                        Gap(Get.height * 0.01),
                        CustomText(
                            title: _eventDetails!.community!.bio != ''
                                ? _eventDetails!.community!.bio!
                                    .toSentenceCase()
                                : 'Bio: Nil',
                            size: Get.height * 0.015,
                            fontFamily: 'Inter',
                            textAlign: TextAlign.left,
                            height: 1.5,
                            color: AppColor().greyEight),
                        Gap(Get.height * 0.02),
                        GestureDetector(
                          onTap: () => Get.to(AccountCommunityDetail(
                              item: _eventDetails!.community!)),
                          child: Center(
                            child: CustomText(
                                title: 'See full profile',
                                size: Get.height * 0.017,
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
                        CustomText(
                            title: 'Partners',
                            size: Get.height * 0.019,
                            fontFamily: 'InterSemiBold',
                            color: AppColor().primaryWhite),
                        Gap(Get.height * 0.02),
                        Row(
                          children: [
                            _eventDetails!.community!.logo == null
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
                                    image: _eventDetails!.community!.logo),
                            Gap(Get.height * 0.015),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                    title: _eventDetails!.community!.name!
                                        .toCapitalCase(),
                                    size: Get.height * 0.017,
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
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  Gap(Get.height * 0.005),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {},
                      title: 'Announcements',
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: SizedBox(
                      width: double.infinity,
                      height: Get.height * 0.46,
                      child: ListView.separated(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              Gap(Get.height * 0.02),
                          itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Get.to(() => PostDetails(
                                    item: postController.forYouPosts[index]));
                              },
                              child: SizedBox(
                                  width: Get.height * 0.35,
                                  child: PostItemForProfile(
                                      item:
                                          postController.forYouPosts[index]))),
                          itemCount: postController.forYouPosts.length),
                    ),
                  ),
                  Gap(Get.height * 0.005),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
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
              size: Get.height * 0.017,
              fontFamily: 'InterMedium',
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
