import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().pureBlackColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Gap(Get.height * 0.05),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/png/account.png',
                      height: Get.height * 0.05,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SvgPicture.asset(
                      'assets/images/svg/chat.svg',
                      height: Get.height * 0.025,
                    ),
                    Gap(Get.height * 0.04),
                    SvgPicture.asset(
                      'assets/images/svg/chart.svg',
                      height: Get.height * 0.025,
                    ),
                    Gap(Get.height * 0.04),
                    SvgPicture.asset(
                      'assets/images/svg/notification.svg',
                      height: Get.height * 0.025,
                    ),
                  ],
                ),
              ],
            ),
            Gap(Get.height * 0.05),
            CustomTextField(
              hint: "Search for gaming news, competitions...",
              // textEditingController: authController.emailController,
              onChanged: (text) {},
            ),
          ],
        ),
      )),
    );
  }
}
