// ignore_for_file: prefer_final_fields, unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/other_models.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_details.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/home/post/components/post_details_on_repost.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

import '../edit_post.dart';
import './comment_tile.dart';
import 'repost_item.dart';

class PostDetails extends StatefulWidget {
  final PostModel item;
  const PostDetails({super.key, required this.item});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  String timeAgo(DateTime itemDate) {
    final now = DateTime.now();
    final difference = now.difference(itemDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isRepostActive = false;
  bool _isLoading = false;
  bool _isFollowing = false;
  PostModel? _postDetails;

  Future<void> getFollowersList() async {
    setState(() {
      _isLoading = true;
    });
    var followersList =
        await authController.getProfileFollowerList(widget.item.author!.id!);
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

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (postController.postStatus != PostStatus.loading) {
      postController.likePost(widget.item.id!);
    }
    return !isLiked;
  }

  Future getPostDetails() async {
    var postDetails = await postController.getPostDetails(widget.item.id!);
    setState(() {
      _postDetails = PostModel.fromJson(postDetails);
    });
  }

  @override
  initState() {
    getPostDetails();
    getFollowersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        elevation: 0,
        leading: GoBackButton(onPressed: () {
          Get.back();
          setState(() {
            isRepostActive = false;
            authController.commentController.clear();
          });
        }),
        centerTitle: true,
        title: CustomText(
          title: 'Post',
          fontFamily: 'InterSemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: _postDetails == null
          ? Center(
              child: CircularProgressIndicator(
                color: AppColor().primaryColor,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await getPostDetails();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isRepostActive == true
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isRepostActive = false;
                                                authController.commentController
                                                    .clear();
                                              });
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: AppColor().primaryWhite,
                                            ),
                                          ),
                                          CustomFillButton(
                                            buttonText: 'Repost',
                                            textSize: Get.height * 0.015,
                                            width: Get.width * 0.25,
                                            height: Get.height * 0.04,
                                            onTap: () {
                                              if (formKey.currentState!
                                                      .validate() &&
                                                  postController.postStatus !=
                                                      PostStatus.loading) {
                                                postController
                                                    .rePost(_postDetails!.id!,
                                                        'quote')
                                                    .then((value) {
                                                  setState(() {
                                                    isRepostActive = false;
                                                    authController
                                                        .commentController
                                                        .clear();
                                                  });
                                                });
                                              }
                                            },
                                            isLoading: false,
                                          ),
                                        ],
                                      ),
                                      Form(
                                        key: formKey,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        child: CustomTextField(
                                          hint: "Add your comment",
                                          textEditingController:
                                              authController.commentController,
                                          fillColor:
                                              AppColor().primaryBackGroundColor,
                                          colors:
                                              AppColor().primaryBackGroundColor,
                                          keyType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 5,
                                          keyAction: TextInputAction.newline,
                                          validate: Validator.isName,
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          _postDetails!.author!.profile!
                                                      .profilePicture ==
                                                  null
                                              ? InkWell(
                                                  onTap: () {
                                                    Get.to(() => UserDetails(
                                                        id: widget
                                                            .item.author!.id!));
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/images/svg/people.svg',
                                                    height: Get.height * 0.05,
                                                    width: Get.height * 0.05,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    widget.item.team != null
                                                        ? Get.to(() =>
                                                            AccountTeamsDetail(
                                                                item: widget
                                                                    .item
                                                                    .team!))
                                                        : widget.item
                                                                    .community !=
                                                                null
                                                            ? Get.to(() =>
                                                                AccountCommunityDetail(
                                                                    item: widget
                                                                        .item
                                                                        .community!))
                                                            : Get.to(() =>
                                                                UserDetails(
                                                                    id: widget
                                                                        .item
                                                                        .author!
                                                                        .id!));
                                                  },
                                                  child: CachedNetworkImage(
                                                    height: Get.height * 0.05,
                                                    width: Get.height * 0.05,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    imageUrl: _postDetails!
                                                        .author!
                                                        .profile!
                                                        .profilePicture!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                              widget.item.community !=
                                                                      null
                                                                  ? widget
                                                                      .item
                                                                      .community!
                                                                      .logo!
                                                                  : widget.item
                                                                              .team !=
                                                                          null
                                                                      ? widget
                                                                          .item
                                                                          .team!
                                                                          .profilePicture!
                                                                      : widget
                                                                          .item
                                                                          .author!
                                                                          .profile!
                                                                          .profilePicture!,
                                                            ),
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          Gap(Get.height * 0.01),
                                          CustomText(
                                            title: widget.item.community != null
                                                ? widget.item.community!.name!
                                                : widget.item.team != null
                                                    ? widget.item.team!.name
                                                    : widget
                                                        .item.author!.userName!,
                                            size: Get.height * 0.015,
                                            fontFamily: 'InterMedium',
                                            textAlign: TextAlign.start,
                                            color: AppColor().lightItemsColor,
                                          ),
                                          Gap(Get.height * 0.005),
                                          const SmallCircle(),
                                          Gap(Get.height * 0.005),
                                          CustomText(
                                            title:
                                                timeAgo(widget.item.createdAt!),
                                            size: Get.height * 0.015,
                                            fontFamily: 'InterMedium',
                                            textAlign: TextAlign.start,
                                            color: AppColor().lightItemsColor,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          if (_postDetails!.author!.fullName !=
                                              authController.user!.fullName)
                                            CustomFillOption(
                                              width: Get.height * 0.12,
                                              height: Get.height * 0.04,
                                              buttonColor: _isLoading
                                                  ? Colors.transparent
                                                  : null,
                                              onTap: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                var message =
                                                    await authController
                                                        .followUser(
                                                            _postDetails!
                                                                .author!.id!);

                                                if (message != "error") {
                                                  setState(() {
                                                    _isFollowing =
                                                        !_isFollowing;
                                                  });
                                                }
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              },
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: _isLoading
                                                      ? [
                                                          SizedBox(
                                                            height: Get.height *
                                                                0.02,
                                                            width: Get.height *
                                                                0.02,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: AppColor()
                                                                  .primaryColor,
                                                              strokeCap:
                                                                  StrokeCap
                                                                      .round,
                                                              strokeWidth: 2,
                                                            ),
                                                          ),
                                                        ]
                                                      : [
                                                          CustomText(
                                                              title: _isFollowing
                                                                  ? "Unfollow"
                                                                  : 'Follow',
                                                              weight: FontWeight
                                                                  .w400,
                                                              size: 12,
                                                              fontFamily:
                                                                  'InterMedium',
                                                              color: AppColor()
                                                                  .primaryWhite),
                                                        ]),
                                            ),
                                          if (authController.user!.id ==
                                              _postDetails!.author!.id)
                                            InkWell(
                                              child: Icon(
                                                Icons.more_vert,
                                                color: AppColor().primaryWhite,
                                              ),
                                              onTap: () => showEditPopup(),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                            if (isRepostActive == false)
                              Gap(Get.height * 0.015),
                            if (isRepostActive == false)
                              CustomText(
                                title: _postDetails!.body,
                                size: Get.height * 0.017,
                                fontFamily: 'InterBold',
                                textAlign: TextAlign.start,
                                color: AppColor().primaryWhite,
                              ),
                            Gap(Get.height * 0.015),
                            (_postDetails!.repost != null)
                                ? InkWell(
                                    onTap: () {
                                      debugPrint('okay');
                                      Get.to(() => PostDetails2(
                                          item: _postDetails!.repost!));
                                    },
                                    child: RepostItem(item: _postDetails!))
                                : GestureDetector(
                                    onTap: () => Helpers().showImagePopup(
                                        context, "${_postDetails!.image}"),
                                    child: Stack(
                                      children: [
                                        _postDetails!.image == null
                                            ? Container()
                                            : CachedNetworkImage(
                                                height: Get.height * 0.25,
                                                width: double.infinity,
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                  child: SizedBox(
                                                    height: Get.height * 0.05,
                                                    width: Get.height * 0.05,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: AppColor()
                                                                .primaryWhite,
                                                            value: progress
                                                                .progress),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error,
                                                            color: AppColor()
                                                                .primaryWhite),
                                                imageUrl: _postDetails!.image!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            _postDetails!
                                                                .image!),
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
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    _postDetails!.tags!.length,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        Gap(Get.height * 0.01),
                                                itemBuilder: (context, index) {
                                                  var items = _postDetails!
                                                      .tags![index];
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: AppColor()
                                                          .primaryDark
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      border: Border.all(
                                                        color: AppColor()
                                                            .primaryColor
                                                            .withOpacity(0.05),
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: CustomText(
                                                        title: items.title,
                                                        color: AppColor()
                                                            .primaryWhite,
                                                        textAlign:
                                                            TextAlign.center,
                                                        size:
                                                            Get.height * 0.014,
                                                        fontFamily: 'InterBold',
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Gap(Get.height * 0.015),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomText(
                                        title: DateFormat.yMMMd().format(
                                            _postDetails!.createdAt!.toLocal()),
                                        size: Get.height * 0.014,
                                        fontFamily: 'InterMedium',
                                        textAlign: TextAlign.start,
                                        color: AppColor().primaryWhite,
                                      ),
                                      Gap(Get.height * 0.005),
                                      const SmallCircle(),
                                      Gap(Get.height * 0.005),
                                      CustomText(
                                        title: DateFormat.jm().format(
                                            _postDetails!.createdAt!.toLocal()),
                                        size: Get.height * 0.014,
                                        fontFamily: 'InterMedium',
                                        textAlign: TextAlign.start,
                                        color: AppColor().primaryWhite,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            title: _postDetails!.viewCount
                                                .toString(),
                                            size: Get.height * 0.014,
                                            fontFamily: 'InterBold',
                                            textAlign: TextAlign.start,
                                            color: AppColor().primaryWhite,
                                          ),
                                          Gap(Get.height * 0.005),
                                          CustomText(
                                            title: 'Views',
                                            size: Get.height * 0.014,
                                            fontFamily: 'Inter',
                                            textAlign: TextAlign.start,
                                            color: AppColor().primaryWhite,
                                          ),
                                        ],
                                      ),
                                      Gap(Get.height * 0.01),
                                      Row(
                                        children: [
                                          CustomText(
                                            title: _postDetails!.repostCount
                                                .toString(),
                                            size: Get.height * 0.014,
                                            fontFamily: 'InterBold',
                                            textAlign: TextAlign.start,
                                            color: AppColor().primaryWhite,
                                          ),
                                          Gap(Get.height * 0.005),
                                          CustomText(
                                            title: 'Repost',
                                            size: Get.height * 0.014,
                                            fontFamily: 'Inter',
                                            textAlign: TextAlign.start,
                                            color: AppColor().primaryWhite,
                                          ),
                                        ],
                                      ),
                                      Gap(Get.height * 0.01),
                                      Row(
                                        children: [
                                          CustomText(
                                            title: _postDetails!.likeCount
                                                .toString(),
                                            size: Get.height * 0.014,
                                            fontFamily: 'InterBold',
                                            textAlign: TextAlign.start,
                                            color: AppColor().primaryWhite,
                                          ),
                                          Gap(Get.height * 0.005),
                                          CustomText(
                                            title: 'Likes',
                                            size: Get.height * 0.014,
                                            fontFamily: 'Inter',
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
                                    return _postDetails!.likes!.any((item) =>
                                            item.id == authController.user!.id)
                                        ? Icon(
                                            isLiked
                                                ? Icons.favorite_outline
                                                : Icons.favorite,
                                            color: AppColor().primaryColor,
                                            size: Get.height * 0.025)
                                        : Icon(
                                            isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: AppColor().primaryWhite,
                                            size: Get.height * 0.025);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.autorenew_outlined,
                                    color: AppColor().primaryWhite,
                                    size: Get.height * 0.03,
                                  ),
                                  onPressed: () {
                                    if (_postDetails!.author!.fullName !=
                                        authController.user!.fullName) {
                                      showModalBottomSheet(
                                          isScrollControlled: false,
                                          backgroundColor:
                                              AppColor().primaryWhite,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: Get.height * 0.2,
                                              padding: EdgeInsets.only(
                                                top: Get.height * 0.005,
                                                left: Get.height * 0.02,
                                                right: Get.height * 0.02,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColor()
                                                    .primaryModalColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                ),
                                              ),
                                              child: Column(children: [
                                                Center(
                                                  child: Container(
                                                    height: Get.height * 0.006,
                                                    width: Get.height * 0.09,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: AppColor()
                                                            .greyGradient),
                                                  ),
                                                ),
                                                Gap(Get.height * 0.03),
                                                ListView.separated(
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      const ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: repostItem.length,
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          Divider(
                                                    color: AppColor()
                                                        .greyGradient
                                                        .withOpacity(0.5),
                                                    height: Get.height * 0.04,
                                                    thickness: 0.5,
                                                  ),
                                                  itemBuilder:
                                                      (context, index) {
                                                    var item =
                                                        repostItem[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        if (index == 0) {
                                                          // Fluttertoast.showToast(
                                                          //     fontSize:
                                                          //         Get.height *
                                                          //             0.015,
                                                          //     msg:
                                                          //         'Not available, try again later!',
                                                          //     toastLength: Toast
                                                          //         .LENGTH_SHORT,
                                                          //     gravity:
                                                          //         ToastGravity
                                                          //             .BOTTOM);
                                                          postController.rePost(
                                                              _postDetails!.id!,
                                                              "repost");
                                                        } else {
                                                          setState(() {
                                                            isRepostActive =
                                                                true;
                                                          });
                                                        }
                                                        Get.back();
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            item.icon,
                                                            color: AppColor()
                                                                .greyTwo,
                                                          ),
                                                          Gap(Get.height *
                                                              0.03),
                                                          CustomText(
                                                            title: item.title,
                                                            color: AppColor()
                                                                .greyTwo,
                                                            weight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'InterMedium',
                                                            size: Get.height *
                                                                0.020,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ]),
                                            );
                                          });
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.sms_outlined,
                                      color: AppColor().primaryWhite,
                                      size: Get.height * 0.025,
                                    ),
                                    Gap(Get.height * 0.005),
                                    CustomText(
                                      title: _postDetails!.comment!.length
                                          .toString(),
                                      size: Get.height * 0.014,
                                      fontFamily: 'InterBold',
                                      textAlign: TextAlign.start,
                                      color: AppColor().primaryWhite,
                                    ),
                                  ],
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
                              fontFamily: 'InterBold',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            Gap(Get.height * 0.02),
                            _postDetails!.comment!.isEmpty
                                ? Center(
                                    child: CustomText(
                                      title: 'No comment',
                                      size: Get.height * 0.016,
                                      fontFamily: 'InterMedium',
                                      textAlign: TextAlign.start,
                                      color: AppColor().lightItemsColor,
                                    ),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.zero,
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _postDetails!.comment!.length,
                                    separatorBuilder: (context, index) =>
                                        Gap(Get.height * 0.025),
                                    itemBuilder: (context, index) {
                                      var item = _postDetails!.comment![index];
                                      return CommentTile(item: item);
                                    },
                                  ),
                            Gap(Get.height * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (isRepostActive == false)
                  Container(
                    padding: EdgeInsets.all(Get.height * 0.02),
                    color: AppColor().chatArea,
                    child: Row(
                      children: [
                        OtherImage(
                          itemSize: Get.height * 0.03,
                          image: authController.user!.profile!.profilePicture,
                        ),
                        Gap(Get.height * 0.01),
                        Expanded(
                            child: ChatCustomTextField(
                          textEditingController: authController.chatController,
                          decoration: InputDecoration(
                            hintText: "Leave your thoughts here...",
                            fillColor: Colors.transparent,
                            filled: true,
                            isDense: true,
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              color: AppColor().primaryWhite,
                              fontSize: 13,
                              fontFamily: 'Inter',
                            ),
                            hintStyle: TextStyle(
                              color: AppColor().primaryWhite,
                              fontSize: 13,
                              fontFamily: 'Inter',
                            ),
                          ),
                        )),
                        Gap(Get.height * 0.01),
                        InkWell(
                          onTap: () {
                            if (authController.chatController.text != '') {
                              postController
                                  .commentOnPost(_postDetails!.id!)
                                  .then((value) {
                                if (postController.postStatus ==
                                    PostStatus.success) {
                                  authController.chatController.clear();
                                }
                              });
                            }
                          },
                          child:
                              Icon(Icons.send, color: AppColor().primaryColor),
                        ),
                        Gap(Get.height * 0.015),
                        CustomText(
                          title: '@',
                          size: 23,
                          fontFamily: "InterSemiBold",
                          textAlign: TextAlign.start,
                          color: AppColor().primaryWhite,
                        ),
                        Gap(Get.height * 0.015),
                        Icon(Icons.photo_camera_outlined,
                            color: AppColor().primaryWhite)
                      ],
                    ),
                  )
              ],
            ),
    );
  }

  void showEditPopup() async {
    String? selectedMenuItem = await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      constraints: const BoxConstraints(),
      color: AppColor().primaryMenu,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          value: 'ScreenA',
          height: 20,
          padding: const EdgeInsets.only(bottom: 20, left: 20, top: 20),
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: AppColor().primaryWhite,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Edit Post',
                size: Get.height * 0.014,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
        ),
      ],
    );

    if (selectedMenuItem != null) {
      Get.to(() => EditPost(item: _postDetails!));
    }
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
                fontFamily: 'Inter',
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
                      fontFamily: 'InterMedium',
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
                    fontFamily: 'Inter',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Reply',
                    size: Get.height * 0.012,
                    fontFamily: 'Inter',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Repost',
                    size: Get.height * 0.012,
                    fontFamily: 'Inter',
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
