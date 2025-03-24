import 'dart:async';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/home/root.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'first_screen.dart';

// final shorebirdCodePush = ShorebirdCodePush();

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authController = Get.put(AuthRepository());
  Timer? timer;
  bool displaySwitch = true;

  // Future<void> _checkForUpdates() async {
  //
  //   final isUpdateAvailable =
  //       await shorebirdCodePush.isNewPatchAvailableForDownload();

  //   if (isUpdateAvailable) {
  //
  //     await shorebirdCodePush.downloadUpdateIfAvailable();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    startTime();
    display();
  }

  startTime() async {
    // await _checkForUpdates();
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
    if (authController.authStatus == AuthStatus.isFirstTime) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FirstScreen()));
      //Get.off(() => const FirstScreen());
    } else if (authController.authStatus == AuthStatus.authenticated) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RootDashboard()));
      //Get.off(() => const RootDashboard());
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FirstScreen()));
      //Get.off(() => const FirstScreen());
    }
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
              height: Get.height * 0.08,
            ),
          ),
        ],
      ),
    );
  }
}
