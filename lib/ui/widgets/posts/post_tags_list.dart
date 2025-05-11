import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostTagsList extends StatelessWidget {
  final List<Tag> tags;

  const PostTagsList({
    Key? key,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.03,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.01),
        itemBuilder: (context, index) {
          var item = tags[index];
          return Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColor().primaryDark.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColor().primaryColor.withOpacity(0.05),
                width: 0.5,
              ),
            ),
            child: Center(
              child: CustomText(
                title: item.title,
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                size: 12,
                fontFamily: 'InterBold',
              ),
            ),
          );
        },
      ),
    );
  }
}
