import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().pureBlackColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(Get.height * 0.06),
              SvgPicture.asset(
                'assets/images/svg/splashTest.svg',
                height: Get.height * 0.15,
              ),
              Gap(Get.height * 0.02),
              Center(
                child: CustomText(
                  title:
                      'Esports NG is your all in one social\nnetworking platform for Gaming',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyLight',
                  size: Get.height * 0.017,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
