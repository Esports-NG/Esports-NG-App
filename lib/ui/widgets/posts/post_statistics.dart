import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostStatistics extends StatelessWidget {
  final DateTime? createdAt;
  final int? viewCount;
  final int? repostCount;
  final int? likeCount;

  const PostStatistics({
    Key? key,
    required this.createdAt,
    required this.viewCount,
    required this.repostCount,
    required this.likeCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime safeCreatedAt = createdAt ?? DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomText(
                title: DateFormat.yMMMd().format(safeCreatedAt.toLocal()),
                size: 12,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.005),
              const SmallCircle(),
              Gap(Get.height * 0.005),
              CustomText(
                title: DateFormat.jm().format(safeCreatedAt.toLocal()),
                size: 12,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem((viewCount ?? 0).toString(), 'Views'),
              Gap(Get.height * 0.01),
              _buildStatItem((repostCount ?? 0).toString(), 'Repost'),
              Gap(Get.height * 0.01),
              _buildStatItem((likeCount ?? 0).toString(), 'Likes'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Row(
      children: [
        CustomText(
          title: count,
          size: 12,
          fontFamily: 'InterBold',
          textAlign: TextAlign.start,
          color: AppColor().primaryWhite,
        ),
        Gap(Get.height * 0.005),
        CustomText(
          title: label,
          size: 12,
          fontFamily: 'Inter',
          textAlign: TextAlign.start,
          color: AppColor().primaryWhite,
        ),
      ],
    );
  }
}
