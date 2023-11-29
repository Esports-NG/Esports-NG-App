import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/home/post/post_details.dart';
import 'package:e_sport/ui/home/post/post_item.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'error_page.dart';
import 'no_post_page.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostRepository());
    return Obx(() {
      if (postController.postStatus == PostStatus.loading) {
        return LoadingWidget(color: AppColor().primaryColor);
      } else if (postController.postStatus == PostStatus.available) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: postController.allPost.length,
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          itemBuilder: (context, index) {
            var item = postController.allPost[index];
            return InkWell(
              onTap: () {
                Get.to(
                  () => PostDetails(
                    item: item,
                  ),
                );
              },
              child: PostItem(item: item),
            );
          },
        );
      } else if (postController.postStatus == PostStatus.empty) {
        return const NoPostPage();
      } else {
        return const ErrorPage();
      }
    });
  }
}
