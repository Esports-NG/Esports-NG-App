// ignore_for_file: prefer_final_fields, unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class PostDetails extends StatefulWidget {
  final PostModel item;
  const PostDetails({super.key, required this.item});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  int _selectedIndex = 0;

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    postController.likePost(widget.item.id!);
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        elevation: 0,
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(Get.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.item.author!.profile!.profilePicture == null
                          ? SvgPicture.asset(
                              'assets/images/svg/people.svg',
                              height: Get.height * 0.05,
                              width: Get.height * 0.05,
                            )
                          : CachedNetworkImage(
                              height: Get.height * 0.05,
                              width: Get.height * 0.05,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              imageUrl:
                                  widget.item.author!.profile!.profilePicture,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.item.author!
                                          .profile!.profilePicture),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                      Gap(Get.height * 0.01),
                      CustomText(
                        title: widget.item.author!.fullName!.toCapitalCase(),
                        size: Get.height * 0.015,
                        fontFamily: 'GilroyMedium',
                        textAlign: TextAlign.start,
                        color: AppColor().lightItemsColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomFillButton(
                        buttonText: 'Follow',
                        textSize: Get.height * 0.015,
                        width: Get.width * 0.25,
                        height: Get.height * 0.04,
                        onTap: () {},
                        isLoading: false,
                      ),
                      Gap(Get.height * 0.01),
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: AppColor().primaryWhite,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(Get.height * 0.015),
              CustomText(
                title: widget.item.title,
                size: Get.height * 0.018,
                fontFamily: 'GilroyBold',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.015),
              CustomText(
                title: widget.item.body,
                size: Get.height * 0.015,
                fontFamily: 'GilroyRegular',
                weight: FontWeight.w500,
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.015),
              Stack(
                children: [
                  widget.item.image == null
                      ? Container(
                          height: Get.height * 0.25,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/png/placeholder.png'),
                                fit: BoxFit.cover),
                          ),
                        )
                      : CachedNetworkImage(
                          height: Get.height * 0.25,
                          width: double.infinity,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: SizedBox(
                              height: Get.height * 0.05,
                              width: Get.height * 0.05,
                              child: CircularProgressIndicator(
                                  color: AppColor().primaryWhite,
                                  value: progress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: AppColor().primaryWhite),
                          imageUrl:
                              'http://res.cloudinary.com/dkykwpryb/${widget.item.image!}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'http://res.cloudinary.com/dkykwpryb/${widget.item.image!}'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                  Positioned.fill(
                    left: Get.height * 0.02,
                    bottom: Get.height * 0.02,
                    top: Get.height * 0.19,
                    child: SizedBox(
                      height: Get.height * 0.03,
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.item.tags!.length,
                          separatorBuilder: (context, index) =>
                              Gap(Get.height * 0.01),
                          itemBuilder: (context, index) {
                            var items = widget.item.tags![index];
                            return Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColor().primaryDark.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      AppColor().primaryColor.withOpacity(0.05),
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: CustomText(
                                  title: items.title,
                                  color: AppColor().primaryWhite,
                                  textAlign: TextAlign.center,
                                  size: Get.height * 0.014,
                                  fontFamily: 'GilroyBold',
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
              Gap(Get.height * 0.015),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          title: DateFormat.yMMMd()
                              .format(widget.item.createdAt!.toLocal()),
                          size: Get.height * 0.014,
                          fontFamily: 'GilroyMedium',
                          textAlign: TextAlign.start,
                          color: AppColor().primaryWhite,
                        ),
                        Gap(Get.height * 0.005),
                        const SmallCircle(),
                        Gap(Get.height * 0.005),
                        CustomText(
                          title: DateFormat.jm()
                              .format(widget.item.createdAt!.toLocal()),
                          size: Get.height * 0.014,
                          fontFamily: 'GilroyMedium',
                          textAlign: TextAlign.start,
                          color: AppColor().primaryWhite,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              title: widget.item.viewers!.length.toString(),
                              size: Get.height * 0.014,
                              fontFamily: 'GilroyBold',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            Gap(Get.height * 0.005),
                            CustomText(
                              title: 'Views',
                              size: Get.height * 0.014,
                              fontFamily: 'GilroyRegular',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                          ],
                        ),
                        Gap(Get.height * 0.01),
                        Row(
                          children: [
                            CustomText(
                              title: widget.item.comment!.length.toString(),
                              size: Get.height * 0.014,
                              fontFamily: 'GilroyBold',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            Gap(Get.height * 0.005),
                            CustomText(
                              title: 'Repost',
                              size: Get.height * 0.014,
                              fontFamily: 'GilroyRegular',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                          ],
                        ),
                        Gap(Get.height * 0.01),
                        Row(
                          children: [
                            CustomText(
                              title: widget.item.likeCount.toString(),
                              size: Get.height * 0.014,
                              fontFamily: 'GilroyBold',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            Gap(Get.height * 0.005),
                            CustomText(
                              title: 'Likes',
                              size: Get.height * 0.014,
                              fontFamily: 'GilroyRegular',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.4,
                color: AppColor().lightItemsColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LikeButton(
                        size: Get.height * 0.025,
                        onTap: onLikeButtonTapped,
                        circleColor: CircleColor(
                            start: AppColor().primaryColor,
                            end: AppColor().primaryColor),
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: AppColor().primaryColor,
                          dotSecondaryColor: AppColor().primaryColor,
                        ),
                        likeBuilder: (bool isLiked) {
                          return widget.item.likes!
                                  .contains(authController.user!.id)
                              ? Icon(
                                  isLiked
                                      ? Icons.favorite_outline
                                      : Icons.favorite,
                                  color: AppColor().primaryWhite,
                                  size: Get.height * 0.025)
                              : Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: AppColor().primaryWhite,
                                  size: Get.height * 0.025);
                        },
                        likeCount: widget.item.likes!.length,
                        countBuilder: (int? count, bool isLiked, String text) {
                          var color = AppColor().primaryWhite;
                          Widget result;
                          if (count == 0) {
                            result = CustomText(
                                title: '0',
                                size: Get.height * 0.014,
                                fontFamily: 'GilroyBold',
                                textAlign: TextAlign.start,
                                color: color);
                          } else if (count == 1) {
                            result = CustomText(
                                title: '$text like',
                                size: Get.height * 0.014,
                                fontFamily: 'GilroyBold',
                                textAlign: TextAlign.start,
                                color: color);
                          } else {
                            result = CustomText(
                                title: '$text likes',
                                size: Get.height * 0.014,
                                fontFamily: 'GilroyBold',
                                textAlign: TextAlign.start,
                                color: color);
                          }
                          return result;
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.autorenew_outlined,
                      color: AppColor().primaryWhite,
                      size: Get.height * 0.03,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.sms_outlined,
                      color: AppColor().primaryWhite,
                      size: Get.height * 0.03,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: AppColor().primaryWhite,
                      size: Get.height * 0.03,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Divider(
                thickness: 0.4,
                color: AppColor().lightItemsColor,
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Comments',
                size: Get.height * 0.018,
                fontFamily: 'GilroyBold',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.02),
              Center(
                child: CustomText(
                  title: 'No comment',
                  size: Get.height * 0.016,
                  fontFamily: 'GilroyMedium',
                  textAlign: TextAlign.start,
                  color: AppColor().lightItemsColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row commentItem({String? comment, like, IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: Get.height * 0.05,
            width: Get.height * 0.05,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/png/postImage1.png',
                  ),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Gap(Get.height * 0.01),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: 'Southpark #2234',
                size: Get.height * 0.014,
                fontFamily: 'GilroyRegular',
                textAlign: TextAlign.start,
                color: AppColor().lightItemsColor,
              ),
              Gap(Get.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomText(
                      title: comment,
                      size: Get.height * 0.016,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                  Gap(Get.height * 0.01),
                  IconButton(
                    alignment: Alignment.bottomRight,
                    icon: Icon(
                      icon,
                      color: AppColor().primaryColor,
                      size: Get.height * 0.02,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Gap(Get.height * 0.01),
              Row(
                children: [
                  CustomText(
                    title: like,
                    size: Get.height * 0.012,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Reply',
                    size: Get.height * 0.012,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Repost',
                    size: Get.height * 0.012,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
