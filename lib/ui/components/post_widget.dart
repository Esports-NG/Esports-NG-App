import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/home/post/post_details.dart';
import 'package:e_sport/ui/home/post/post_item.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
      } else if (postController.postStatus == PostStatus.success) {
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
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColor().primaryColor,
              size: Get.height * 0.1,
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Error occurred, try again!',
              size: 15,
              color: AppColor().primaryWhite,
            ),
          ],
        );
      }
    });
  }
}
