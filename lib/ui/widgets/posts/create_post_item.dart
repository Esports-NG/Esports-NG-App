import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateMenu extends StatelessWidget {
  final CategoryItem? item;
  final int? selectedItem, index;
  const CreateMenu({
    super.key,
    this.item,
    this.index,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.025),
      decoration: BoxDecoration(
        color: selectedItem == index
            ? AppColor().primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColor().primaryColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            title: item!.title,
            size: Get.height * 0.016,
            fontFamily: 'InterMedium',
            textAlign: TextAlign.start,
            color: AppColor().primaryWhite,
          ),
          const Spacer(),
          SmallCircle(
            size: Get.height * 0.015,
            color: AppColor().primaryWhite,
            bColor: AppColor().primaryColor,
          )
        ],
      ),
    );
  }
}
