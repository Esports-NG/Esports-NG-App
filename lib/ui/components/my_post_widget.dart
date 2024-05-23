import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/home/post/components/post_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'error_page.dart';
import 'no_item_page.dart';

class MyPostWidget extends StatelessWidget {
  const MyPostWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostRepository());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: 'Posts',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: GoBackButton(onPressed: () => Get.back()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: AppColor().primaryWhite,
            ),
          ),
        ],
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 2), () {
            postController.getMyPost(false);
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Obx(() {
              if (postController.getPostStatus == GetPostStatus.loading) {
                return Center(
                    child: LoadingWidget(color: AppColor().primaryColor));
              } else if (postController.getPostStatus ==
                  GetPostStatus.available) {
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postController.myPost.length,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                  itemBuilder: (context, index) {
                    var item = postController.myPost[index];
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
              } else if (postController.getPostStatus == GetPostStatus.empty) {
                return const NoItemPage(title: 'Post');
              } else {
                return const ErrorPage();
              }
            }),
          ),
        ),
      ),
    );
  }
}
