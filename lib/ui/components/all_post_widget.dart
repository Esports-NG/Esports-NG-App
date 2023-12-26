import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/home/post/components/post_item.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'error_page.dart';
import 'no_item_page.dart';

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
            return PostItem(item: item);
          },
        );
      } else if (postController.postStatus == PostStatus.empty) {
        return const NoItemPage(title: 'Post');
      } else {
        return const ErrorPage();
      }
    });
  }
}
