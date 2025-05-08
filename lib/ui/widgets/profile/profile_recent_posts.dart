import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/screens/post/post_details.dart';
import 'package:e_sport/ui/widgets/profile/recent_posts.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/util/colors.dart';

class ProfileRecentPosts extends StatelessWidget {
  final List<PostModel> posts;
  final bool isLoading;

  const ProfileRecentPosts({
    Key? key,
    required this.posts,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
      child: SizedBox(
        width: double.infinity,
        height: Get.height * 0.46,
        child: isLoading
            ? const Center(child: ButtonLoader())
            : posts.isEmpty
                ? Center(
                    child: CustomText(
                        title: "No posts", color: AppColor().primaryWhite))
                : ListView.separated(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        Gap(Get.height * 0.02),
                    itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Get.to(() => PostDetails(
                              item: posts.reversed.toList()[index]));
                        },
                        child: SizedBox(
                            width: Get.height * 0.35,
                            child: PostItemForProfile(
                                item: posts.reversed.toList()[index]))),
                    itemCount: posts.length),
      ),
    );
  }
}
