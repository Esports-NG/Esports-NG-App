import 'dart:async';
import 'package:e_sport/ui/home/dashboard.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'first_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final authController = Get.put(AuthRepository());
  Timer? timer;
  bool displaySwitch = true;

  @override
  void initState() {
    super.initState();
    startTime();
    display();
  }

  startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }

  display() async {
    return Timer(const Duration(seconds: 3), () {
      setState(() {
        displaySwitch = false;
      });
    });
  }

  route() async {
    // if (authController.authStatus == AuthStatus.isFirstTime) {
    //   Get.off(() => const FirstScreen());
    // } else if (authController.authStatus == AuthStatus.authenticated) {
    //   Get.off(() => const Dashboard());
    // } else {
    //   Get.off(() => const FirstScreen());
    // }
    Get.off(() => const Dashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              displaySwitch
                  ? "assets/images/svg/esport.svg"
                  : "assets/images/svg/esport1.svg",
              height: Get.height * 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
