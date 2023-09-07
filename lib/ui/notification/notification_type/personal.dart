import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Personal extends StatelessWidget {
  const Personal({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: CustomText(
            title: 'Personal',
            color: AppColor().lightItemsColor,
            textAlign: TextAlign.center,
            fontFamily: 'GilroyRegular',
            size: Get.height * 0.015,
          ),
        ),
        // ListView.separated(
        //     physics: const ScrollPhysics(),
        //     shrinkWrap: true,
        //     padding: EdgeInsets.zero,
        //     itemCount: peoplesCard.length,
        //     separatorBuilder: (context, index) => Gap(Get.height * 0.03),
        //     itemBuilder: (context, index) {
        //       var item = peoplesCard[index];
        //       return InkWell(
        //         onTap: () {
        //           Get.to(() => Inbox(item: item));
        //         },
        //         child: Row(
        //           children: [
        //             Image.asset(
        //               item.image!,
        //               height: Get.height * 0.07,
        //               width: Get.height * 0.07,
        //               fit: BoxFit.cover,
        //             ),
        //             Gap(Get.height * 0.02),
        //             Expanded(
        //               flex: 4,
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   CustomText(
        //                     title: item.postedBy,
        //                     size: Get.height * 0.02,
        //                     weight: FontWeight.w600,
        //                     color: AppColors.hintTextColor,
        //                   ),
        //                   Gap(Get.height * 0.005),
        //                   CustomText(
        //                     title:
        //                         'Hi there! I want to write a project for my finals',
        //                     size: Get.height * 0.016,
        //                     color: AppColors.primary,
        //                     overflow: TextOverflow.ellipsis,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Expanded(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.end,
        //                 children: [
        //                   CustomText(
        //                     title: '31 min',
        //                     size: Get.height * 0.014,
        //                     weight: FontWeight.w500,
        //                     color: AppColors.hintTextColor,
        //                   ),
        //                   Gap(Get.height * 0.005),
        //                   item.reportType == 'Researcher'
        //                       ? Container(
        //                           padding: const EdgeInsets.all(8),
        //                           decoration: const BoxDecoration(
        //                               color: Colors.green,
        //                               shape: BoxShape.circle),
        //                           child: CustomText(
        //                             title: '1',
        //                             size: Get.height * 0.01,
        //                             weight: FontWeight.w500,
        //                             color: AppColors.whiteColor,
        //                           ),
        //                         )
        //                       : Container(),
        //                 ],
        //               ),
        //             )
        //           ],
        //         ),
        //       );
        //     }),
      ),
    );
  }
}
