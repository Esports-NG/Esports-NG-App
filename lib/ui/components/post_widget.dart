import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/home/post/post_details.dart';
import 'package:e_sport/ui/home/post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: postItem.length,
      separatorBuilder: (context, index) => Gap(Get.height * 0.02),
      itemBuilder: (context, index) {
        var item = postItem[index];
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
  }
}
