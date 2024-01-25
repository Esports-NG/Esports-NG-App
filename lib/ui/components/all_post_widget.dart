import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/home/post/components/post_item.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'error_page.dart';
import 'no_item_page.dart';

class PostWidget extends StatelessWidget {
  final List<PostModel>? posts;
  const PostWidget({
    super.key,
    this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (posts!.isEmpty)
          const NoItemPage(title: 'Post')
        else if (posts!.isNotEmpty)
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts!.length,
            separatorBuilder: (context, index) => Gap(Get.height * 0.02),
            itemBuilder: (context, index) {
              var item = posts![index];
              return InkWell(
                  onTap: () => Get.to(() => PostDetails(item: item)),
                  child: PostItem(item: item));
            },
          )
        else
          LoadingWidget(color: AppColor().primaryColor)
      ],
    );
  }
}
