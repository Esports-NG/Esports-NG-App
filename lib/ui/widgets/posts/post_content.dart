import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/posts/post_tags_list.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostContent extends StatelessWidget {
  final PostModel post;

  const PostContent({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: post.body,
          size: 14,
          fontFamily: 'InterMedium',
          textAlign: TextAlign.start,
          color: AppColor().primaryWhite,
        ),
        Gap(Get.height * 0.015),
        if (post.image != null) _buildPostImage(context),
      ],
    );
  }

  Widget _buildPostImage(BuildContext context) {
    return GestureDetector(
      onTap: () => Helpers().showImagePopup(context, "${post.image}"),
      child: Stack(
        children: [
          CachedNetworkImage(
            height: Get.height * 0.35,
            width: double.infinity,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: SizedBox(
                height: Get.height * 0.05,
                width: Get.height * 0.05,
                child: CircularProgressIndicator(
                    color: AppColor().primaryWhite, value: progress.progress),
              ),
            ),
            errorWidget: (context, url, error) =>
                Icon(Icons.error, color: AppColor().primaryWhite),
            imageUrl: post.image!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(post.image!), fit: BoxFit.cover),
              ),
            ),
          ),
          if (post.tags != null && post.tags!.isNotEmpty)
            Positioned.fill(
              left: Get.height * 0.02,
              bottom: Get.height * 0.02,
              top: Get.height * 0.34,
              child: PostTagsList(tags: post.tags!),
            ),
        ],
      ),
    );
  }
}
