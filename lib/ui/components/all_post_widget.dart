import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/home/post/components/post_item.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'no_item_page.dart';

class PostWidget extends StatefulWidget {
  final List<PostModel>? posts;
  const PostWidget({
    super.key,
    this.posts,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(bottom: Get.height * 0.04),
        child: Column(
          children: [
            if (widget.posts!.isEmpty)
              const NoItemPage(title: 'Post')
            else if (widget.posts!.isNotEmpty)
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.posts!.length,
                separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                itemBuilder: (context, index) {
                  var item = widget.posts![index];
                  return InkWell(
                      onTap: () => Get.to(() => PostDetails(item: item)),
                      child: PostItem(item: item));
                },
              )
            else
              LoadingWidget(color: AppColor().primaryColor)
          ],
        ),
      ),
    );
  }
}
