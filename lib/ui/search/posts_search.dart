import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/home/post/components/post_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostsSearch extends StatefulWidget {
  const PostsSearch({super.key});

  @override
  State<PostsSearch> createState() => _PostsSearchState();
}

class _PostsSearchState extends State<PostsSearch> {
  final postController = Get.put(PostRepository());
  final authController = Get.put(AuthRepository());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: authController.searchLoading.value
              ? const Center(child: ButtonLoader())
              : postController.searchedPosts.isEmpty
                  ? Center(
                      child: CustomText(
                        title: "No post found.",
                        color: AppColor().primaryWhite,
                      ),
                    )
                  : Column(
                      children: [
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: postController.searchedPosts.length,
                          separatorBuilder: (context, index) =>
                              Gap(Get.height * 0.02),
                          itemBuilder: (context, index) {
                            var item = postController.searchedPosts[index];
                            return InkWell(
                                onTap: () =>
                                    Get.to(() => PostDetails(item: item)),
                                child: PostItem(item: item));
                          },
                        )
                      ],
                    ),
        ),
      ),
    );
  }
}
