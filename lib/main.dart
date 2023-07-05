import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'di/app_binding.dart';
import 'ui/auth/splash_screen.dart';
import 'util/pallete.dart';

void main() {
  runApp(const ESportApp());
}

class ESportApp extends StatelessWidget {
  const ESportApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ESports NG',
        initialBinding: AppBinding(),
        theme: ThemeData(
          primarySwatch: Palette.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
        builder: EasyLoading.init(),
        home: const SplashScreen());
  }
}
