import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/screens/nav/root.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
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
    debugPrint(widget.title);
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
            title: '${widget.title} Successfully!!',
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
            fontFamily: 'InterBold',
            size: Get.height * 0.04,
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: Get.height * 0.07,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColor().primaryColor,
              ),
              child: Center(
                  child: CustomText(
                title: (widget.title == 'Post Deleted' ||
                        widget.title == 'Post Updated')
                    ? 'My Posts'
                    : widget.title == 'Profile Updated'
                        ? 'My Profile'
                        : 'Create Again',
                color: AppColor().primaryWhite,
                fontFamily: "InterSemiBold",
                size: Get.height * 0.016,
              )),
            ),
          ),
          Gap(Get.height * 0.02),
          InkWell(
            onTap: () => Get.offAll(() => const RootDashboard()),
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
                fontFamily: "InterSemiBold",
                size: Get.height * 0.016,
              )),
            ),
          )
        ]),
      ),
    );
  }
}
