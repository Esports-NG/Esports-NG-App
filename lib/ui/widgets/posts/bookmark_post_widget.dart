import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/screens/extra/no_item_page.dart';
import 'package:e_sport/ui/screens/post/post_details.dart';
import 'package:e_sport/ui/widgets/posts/post_item.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BookMarkWidget extends StatefulWidget {
  const BookMarkWidget({
    super.key,
  });

  @override
  State<BookMarkWidget> createState() => _BookMarkWidgetState();
}

class _BookMarkWidgetState extends State<BookMarkWidget> {
  final postController = Get.put(PostRepository());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (postController.bookmarkedPost.isEmpty)
          const NoItemPage(title: 'Post')
        else if (postController.bookmarkedPost.isNotEmpty)
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: postController.bookmarkedPost.length,
            separatorBuilder: (context, index) => Gap(Get.height * 0.02),
            itemBuilder: (context, index) {
              var item = postController.bookmarkedPost[index];
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
