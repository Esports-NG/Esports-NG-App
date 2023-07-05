import 'dart:async';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final authController = Get.put(AuthRepository());
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }

  route() async {
    // if (authController.authStatus == AuthStatus.isFirstTime) {
    //   Get.off(() => const FirstScreen());
    // } else if (authController.authStatus == AuthStatus.authenticated) {
    //   Get.off(() => const Dashboard());
    // } else {
    //   Get.off(() => const FirstScreen());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryDark,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Get.height * 0.2,
            decoration: BoxDecoration(
                color: AppColor().primaryWhite,
                shape: BoxShape.circle,
                image: const DecorationImage(
                    image: AssetImage(
                  "assets/images/png/esport.png",
                ))),
            // child: Image.asset(
            //   "assets/images/pngs/farmerdomainappicon.png",
            //   height: Get.height * 0.2,
            // ),
          ),
        ],
      ),
    );
  }
}
