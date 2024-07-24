import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/components/news_item.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/home/post/components/post_item.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'no_item_page.dart';

class NewsWidget extends StatefulWidget {
  final List<PostModel>? posts;
  const NewsWidget({
    super.key,
    this.posts,
  });

  @override
  State<NewsWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<NewsWidget> {
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
                      child: NewsItem(item: item));
                },
              )
            else
              LoadingWidget(color: AppColor().primaryColor),
            Gap(Get.height * 0.05),
            CustomText(
              title: 'For more news, reports and articles,',
              size: Get.height * 0.015,
              fontFamily: 'GilroyMedium',
              textAlign: TextAlign.start,
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  title: 'visit ',
                  size: Get.height * 0.015,
                  fontFamily: 'GilroyMedium',
                  textAlign: TextAlign.start,
                  color: AppColor().primaryWhite,
                ),
                CustomText(
                  title: 'https://nexalgaming.co',
                  size: Get.height * 0.015,
                  fontFamily: 'GilroyMedium',
                  textAlign: TextAlign.start,
                  color: AppColor().primaryColor,
                ),
              ],
            ),
            Gap(Get.height * 0.05),
          ],
        ),
      ),
    );
  }
}
