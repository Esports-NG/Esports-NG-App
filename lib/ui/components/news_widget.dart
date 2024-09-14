import 'package:e_sport/data/model/news_model.dart';
import 'package:e_sport/ui/components/news_item.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'no_item_page.dart';

class NewsWidget extends StatefulWidget {
  final List<NewsModel>? posts;
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
                      onTap: () => launchUrl(Uri.parse(item.link!)),
                      child: NewsItem(item: item));
                },
              )
            else
              LoadingWidget(color: AppColor().primaryColor),
            Gap(Get.height * 0.05),
            CustomText(
              title: 'For more news, reports and articles,',
              size: Get.height * 0.015,
              fontFamily: 'InterMedium',
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
                  fontFamily: 'InterMedium',
                  textAlign: TextAlign.start,
                  color: AppColor().primaryWhite,
                ),
                GestureDetector(
                  onTap: () => launchUrl(Uri.parse("https://nexalgaming.co")),
                  child: CustomText(
                    title: 'https://nexalgaming.co',
                    size: Get.height * 0.015,
                    fontFamily: 'InterMedium',
                    textAlign: TextAlign.start,
                    color: AppColor().primaryColor,
                  ),
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
