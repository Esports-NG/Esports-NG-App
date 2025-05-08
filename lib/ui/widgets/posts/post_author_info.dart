import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/screens/account/team/account_teams_details.dart';
import 'package:e_sport/ui/screens/account/user_details.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/ui/widgets/utils/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostAuthorInfo extends StatelessWidget {
  final PostModel post;
  final String timeAgo;
  final bool isRepost;

  const PostAuthorInfo({
    Key? key,
    required this.post,
    required this.timeAgo,
    this.isRepost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final author = isRepost ? post.repost!.author! : post.author!;
    final team = isRepost ? post.repost!.team : post.team;
    final community = isRepost ? post.repost!.community : post.community;
    final createdAt = isRepost ? post.repost!.createdAt! : post.createdAt!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfilePicture(author, team, community),
        Gap(Get.height * 0.01),
        CustomText(
          title: community != null
              ? community.name!
              : team != null
                  ? team.name
                  : author.userName!,
          size: Get.height * 0.015,
          fontFamily: 'InterMedium',
          textAlign: TextAlign.start,
          color: AppColor().lightItemsColor,
        ),
        Gap(Get.height * 0.005),
        const SmallCircle(),
        Gap(Get.height * 0.005),
        CustomText(
          title: timeAgo,
          size: Get.height * 0.015,
          fontFamily: 'InterMedium',
          textAlign: TextAlign.start,
          color: AppColor().lightItemsColor,
        ),
      ],
    );
  }

  Widget _buildProfilePicture(author, team, community) {
    if (author.profile!.profilePicture == null && !isRepost) {
      return InkWell(
        onTap: () {
          team != null
              ? Get.to(() => AccountTeamsDetail(item: team))
              : community != null
                  ? Get.to(() => AccountCommunityDetail(item: community))
                  : Get.to(() => UserDetails(slug: author.slug!));
        },
        child: SvgPicture.asset(
          'assets/images/svg/people.svg',
          height: Get.height * 0.035,
          width: Get.height * 0.035,
        ),
      );
    }

    return InkWell(
      onTap: () {
        team != null
            ? Get.to(() => AccountTeamsDetail(item: team))
            : community != null
                ? Get.to(() => AccountCommunityDetail(item: community))
                : Get.to(() => UserDetails(slug: author.slug!));
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          isRepost
              ? CachedNetworkImage(
                  height: Get.height * 0.035,
                  width: Get.height * 0.035,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: community != null
                      ? community.logo
                      : team != null
                          ? team.profilePicture
                          : author.profile!.profilePicture,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          community != null
                              ? community.logo
                              : team != null
                                  ? team.profilePicture
                                  : author.profile!.profilePicture,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : OtherImage(
                  image: community != null
                      ? community.logo
                      : team != null
                          ? team.profilePicture
                          : author.profile!.profilePicture,
                  height: Get.height * 0.035,
                  width: Get.height * 0.035,
                ),
          if ((community != null
              ? community.isVerified!
              : team != null
                  ? team.isVerified!
                  : author.isVerified!))
            SvgPicture.asset("assets/images/svg/check_badge.svg",
                width: Get.height * 0.015)
        ],
      ),
    );
  }
}
