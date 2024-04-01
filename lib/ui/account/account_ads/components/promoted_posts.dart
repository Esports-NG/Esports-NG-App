import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/account_ads/components/post_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PromotedPosts extends StatefulWidget {
  const PromotedPosts({super.key});

  @override
  State<PromotedPosts> createState() => _PromotedPostsState();
}

class _PromotedPostsState extends State<PromotedPosts> {
  final postController = Get.put(PostRepository());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(seconds: 2), () {
              postController.getAllPost(false);
            }),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Column(children: [
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      AdsPostItem(item: postController.allPost[index]),
                  separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                  itemCount: 4)
            ]),
          ),
        ));
  }
}
