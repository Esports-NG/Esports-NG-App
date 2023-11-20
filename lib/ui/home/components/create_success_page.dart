import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/home/dashboard.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CreateSuccessPage extends StatefulWidget {
  final String title;
  const CreateSuccessPage({super.key, required this.title});

  @override
  State<CreateSuccessPage> createState() => _CreateSuccessPageState();
}

class _CreateSuccessPageState extends State<CreateSuccessPage> {
  final authController = Get.put(AuthRepository());
  bool userCheck = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Spacer(),
          Center(
            child: Container(
              height: Get.height * 0.3,
              width: Get.height * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor().primaryLightColor,
              ),
              child: Image.asset(
                'assets/images/png/done1.png',
                height: Get.height * 0.17,
                width: Get.height * 0.17,
              ),
            ),
          ),
          Gap(Get.height * 0.04),
          CustomText(
            title: '${widget.title} Created Successfully!!',
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
            fontFamily: 'GilroyBold',
            size: Get.height * 0.04,
          ),
          const Spacer(),
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              height: Get.height * 0.07,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColor().primaryColor,
              ),
              child: Center(
                  child: CustomText(
                title: 'Create Again',
                color: AppColor().primaryWhite,
                weight: FontWeight.w600,
                size: Get.height * 0.016,
              )),
            ),
          ),
          Gap(Get.height * 0.02),
          InkWell(
            onTap: () => Get.off(() => const Dashboard()),
            child: Container(
              height: Get.height * 0.07,
              width: Get.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColor().primaryColor,
                  )),
              child: Center(
                  child: CustomText(
                title: 'Back to Home',
                color: AppColor().primaryColor,
                weight: FontWeight.w600,
                size: Get.height * 0.016,
              )),
            ),
          )
        ]),
      ),
    );
  }
}
