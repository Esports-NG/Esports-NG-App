import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostMedia extends StatelessWidget {
  final PostModel post;
  final bool isRepost;

  const PostMedia({
    Key? key,
    required this.post,
    this.isRepost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = isRepost ? post.repost?.image : post.image;

    if (imageUrl == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () => Helpers().showImagePopup(context, imageUrl),
          child: CachedNetworkImage(
            height: Get.height * 0.35,
            width: double.infinity,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: SizedBox(
                height: Get.height * 0.05,
                width: Get.height * 0.05,
                child: CircularProgressIndicator(
                  color: AppColor().primaryWhite,
                  value: progress.progress,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: AppColor().primaryWhite,
            ),
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if (post.tags != null && post.tags!.isNotEmpty)
          Positioned.fill(
            left: Get.height * 0.02,
            bottom: Get.height * 0.02,
            top: Get.height * 0.34,
            child: SizedBox(
              height: Get.height * 0.03,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: post.tags!.length,
                separatorBuilder: (context, index) => Gap(Get.height * 0.01),
                itemBuilder: (context, index) {
                  var tag = post.tags![index];
                  return Container(
                    padding: EdgeInsets.all(Get.height * 0.005),
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
                        title: tag.title,
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        size: 12,
                        fontFamily: 'InterBold',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
