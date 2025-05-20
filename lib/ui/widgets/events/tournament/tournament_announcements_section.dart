import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/screens/post/post_details.dart';
import 'package:e_sport/ui/widgets/profile/recent_posts.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentAnnouncementsSection extends StatelessWidget {
  final List<PostModel> posts;
  final bool isFetchingPosts;

  const TournamentAnnouncementsSection({
    Key? key,
    required this.posts,
    required this.isFetchingPosts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: isFetchingPosts || posts.isEmpty ? 50 : 390,
      child: isFetchingPosts
          ? const Center(child: ButtonLoader())
          : posts.isEmpty
              ? Center(
                  child: CustomText(
                    title: "No posts",
                    size: 16,
                    fontFamily: "InterMedium",
                    color: AppColor().lightItemsColor,
                  ),
                )
              : ListView.separated(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Get.to(() => PostDetails(item: posts[index]));
                    },
                    child: SizedBox(
                      width: Get.height * 0.35,
                      child: PostItemForProfile(item: posts[index]),
                    ),
                  ),
                  itemCount: posts.length,
                ),
    );
  }
}
