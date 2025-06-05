import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/posts/news_widget.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({super.key});
  final postController = Get.put(PostRepository());
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(onPressed: () => Get.back()),
        title: CustomText(
          title: "Esports News",
          size: 16,
          weight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: NewsWidget(posts: widget.postController.news))),
    );
  }
}
