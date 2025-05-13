// ignore_for_file: prefer_final_fields, unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/screens/account/team/account_teams_details.dart';
import 'package:e_sport/ui/screens/account/user_details.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/widgets/posts/post_comment_input.dart';
import 'package:e_sport/ui/widgets/posts/post_content.dart';
import 'package:e_sport/ui/widgets/posts/post_interaction_buttons.dart';
import 'package:e_sport/ui/widgets/posts/post_statistics.dart';
import 'package:e_sport/ui/widgets/posts/repost_form.dart';
import 'package:e_sport/ui/widgets/posts/repost_item.dart';
import 'package:e_sport/ui/widgets/posts/comment_tile.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/ui/widgets/utils/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'edit_post.dart';

class PostDetails extends StatefulWidget {
  final PostModel item;
  const PostDetails({super.key, required this.item});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isRepostActive = false;
  bool _isLoading = false;
  bool _isFollowing = false;
  PostModel? _postDetails;

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

  Future<void> getFollowersList() async {
    setState(() {
      _isLoading = true;
    });
    var followersList =
        await authController.getProfileFollowerList(widget.item.author!.slug!);
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

  Future getPostDetails() async {
    var postDetails = await postController.getPostDetails(widget.item.slug!);
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
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await getPostDetails();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display repost form or author info
                              isRepostActive
                                  ? RepostForm(
                                      slug: _postDetails!.slug!,
                                      authController: authController,
                                      postController: postController,
                                      formKey: formKey,
                                      onCancel: () {
                                        setState(() {
                                          isRepostActive = false;
                                          authController.commentController
                                              .clear();
                                        });
                                      },
                                    )
                                  : _buildAuthorInfo(),

                              if (isRepostActive == false)
                                Gap(Get.height * 0.015),

                              // Post content and image
                              if (isRepostActive == false)
                                (_postDetails!.repost != null)
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(() => PostDetails(
                                              item: _postDetails!.repost!));
                                        },
                                        child: RepostItem(item: _postDetails!))
                                    : PostContent(post: _postDetails!),

                              Gap(Get.height * 0.015),

                              // Post statistics
                              if (!isRepostActive)
                                PostStatistics(
                                  createdAt: _postDetails!.createdAt,
                                  viewCount: _postDetails!.viewCount,
                                  repostCount: _postDetails!.repostCount,
                                  likeCount: _postDetails!.likeCount,
                                ),
                              // Post interaction buttons
                              if (!isRepostActive)
                                PostInteractionButtons(
                                  post: _postDetails!,
                                  authController: authController,
                                  postController: postController,
                                  isAuthor: _postDetails!.author!.fullName ==
                                      authController.user!.fullName,
                                  onRepostActive: () {
                                    setState(() {
                                      isRepostActive = true;
                                    });
                                  },
                                ),
                              // Comments section
                              Gap(Get.height * 0.01),
                              CustomText(
                                title: 'Comments',
                                size: 14,
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
                                        var item =
                                            _postDetails!.comment![index];
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

                  // Comment input field
                  if (isRepostActive == false)
                    PostCommentInput(
                      slug: _postDetails!.slug!,
                      authController: authController,
                      postController: postController,
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildAuthorInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _postDetails!.author!.profile!.profilePicture == null
                ? InkWell(
                    onTap: () {
                      Get.to(
                          () => UserDetails(slug: widget.item.author!.slug!));
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
                          ? Get.to(
                              () => AccountTeamsDetail(item: widget.item.team!))
                          : widget.item.community != null
                              ? Get.to(() => AccountCommunityDetail(
                                  item: widget.item.community!))
                              : Get.to(() =>
                                  UserDetails(slug: widget.item.author!.slug!));
                    },
                    child: CachedNetworkImage(
                      height: Get.height * 0.05,
                      width: Get.height * 0.05,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: _postDetails!.author!.profile!.profilePicture!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                widget.item.community != null
                                    ? widget.item.community!.logo!
                                    : widget.item.team != null
                                        ? widget.item.team!.profilePicture!
                                        : widget.item.author!.profile!
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
                      : widget.item.author!.userName!,
              size: Get.height * 0.015,
              fontFamily: 'InterMedium',
              textAlign: TextAlign.start,
              color: AppColor().lightItemsColor,
            ),
            Gap(Get.height * 0.005),
            const SmallCircle(),
            Gap(Get.height * 0.005),
            CustomText(
              title: timeAgo(widget.item.createdAt!),
              size: Get.height * 0.015,
              fontFamily: 'InterMedium',
              textAlign: TextAlign.start,
              color: AppColor().lightItemsColor,
            ),
          ],
        ),
        Row(
          children: [
            if (_postDetails!.author!.fullName != authController.user!.fullName)
              CustomFillOption(
                width: Get.height * 0.12,
                height: Get.height * 0.04,
                buttonColor: _isLoading ? Colors.transparent : null,
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  var message = await authController
                      .followUser(_postDetails!.author!.slug!);

                  if (message != "error") {
                    setState(() {
                      _isFollowing = !_isFollowing;
                    });
                  }
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _isLoading
                        ? [
                            SizedBox(
                              height: Get.height * 0.02,
                              width: Get.height * 0.02,
                              child: CircularProgressIndicator(
                                color: AppColor().primaryColor,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 2,
                              ),
                            ),
                          ]
                        : [
                            CustomText(
                                title: _isFollowing ? "Unfollow" : 'Follow',
                                weight: FontWeight.w400,
                                size: 12,
                                fontFamily: 'InterMedium',
                                color: AppColor().primaryWhite),
                          ]),
              ),
            if (authController.user!.id == _postDetails!.author!.id)
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
                size: 12,
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
}
