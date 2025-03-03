import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TrendingTeamsItem extends StatefulWidget {
  final TeamModel item;
  final bool? onFilterPage;
  const TrendingTeamsItem({super.key, required this.item, this.onFilterPage});

  @override
  State<TrendingTeamsItem> createState() => _TrendingTeamsItemState();
}

class _TrendingTeamsItemState extends State<TrendingTeamsItem> {
  final teamController = Get.put(TeamRepository());
  final authController = Get.put(AuthRepository());

  List<Map<String, dynamic>>? _teamFollowers;
  bool _isFollowing = false;
  bool _isLoading = true;

  Future getTeamFollowers() async {
    var followers = await teamController.getTeamFollowers(widget.item.id!);
    setState(() {
      _teamFollowers = followers;
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
    getTeamFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.4,
      width: Get.width * 0.55,
      decoration: BoxDecoration(
        color: AppColor().bgDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().darkGrey,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (widget.item.cover == null)
                  ? Container(
                      height: Get.height * 0.12,
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
                      height: Get.height * 0.12,
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
                      imageUrl: widget.item.cover!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.item.cover!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Column(
                  children: [
                    CustomText(
                      title: widget.item.name!,
                      size: 14,
                      fontFamily: 'InterSemiBold',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(Get.height * 0.005),
                    Visibility(
                      visible: widget.onFilterPage == null,
                      child: CustomText(
                        title: widget.item.members!.isEmpty
                            ? 'No Member'
                            : widget.item.members!.length == 1
                                ? '1 Member'
                                : '${widget.item.members!.length.toString()} Members',
                        size: 12,
                        fontFamily: 'Inter',
                        color: AppColor().greyFour,
                      ),
                    ),
                    Gap(Get.height * 0.01),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        var message =
                            await authController.followTeam(widget.item.id!);
                        print(message);

                        setState(() {
                          if (message == "unfollowed") {
                            _isFollowing = false;
                          } else if (message == "followed") {
                            _isFollowing = true;
                          }
                          _isLoading = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(Get.height * 0.015),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _isFollowing || _isLoading
                              ? null
                              : AppColor().primaryColor,
                          borderRadius: BorderRadius.circular(40),
                          border: _isFollowing
                              ? Border.all(
                                  color: AppColor().primaryColor,
                                )
                              : null,
                        ),
                        child: Center(
                            child: _isLoading
                                ? const ButtonLoader()
                                : CustomText(
                                    title: _isFollowing ? "Unfollow" : 'Follow',
                                    size: 14,
                                    fontFamily: 'InterMedium',
                                    color: _isFollowing
                                        ? AppColor().primaryColor
                                        : AppColor().primaryWhite,
                                  )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: Get.height * 0.065,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                (widget.item.profilePicture == null)
                    ? Container(
                        height: Get.height * 0.08,
                        width: Get.height * 0.08,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor().primaryWhite)),
                        child: SvgPicture.asset(
                          'assets/images/svg/people.svg',
                        ),
                      )
                    : Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                          CachedNetworkImage(
                            height: Get.height * 0.08,
                            width: Get.height * 0.08,
                            progressIndicatorBuilder: (context, url, progress) =>
                                Center(
                              child: SizedBox(
                                height: Get.height * 0.02,
                                width: Get.height * 0.02,
                                child: CircularProgressIndicator(
                                    color: AppColor().primaryColor,
                                    value: progress.progress),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error, color: AppColor().primaryColor),
                            imageUrl: widget.item.profilePicture!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColor().primaryWhite),
                                image: DecorationImage(
                                    image:
                                        NetworkImage(widget.item.profilePicture!),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          if(widget.item.isVerified == true) SvgPicture.asset("assets/images/svg/check_badge.svg", height: Get.height * 0.025,)
                        ],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
