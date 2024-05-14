import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/no_internet.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'di/app_binding.dart';
import 'ui/auth/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const ESportApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
}

class ESportApp extends StatefulWidget {
  const ESportApp({super.key});

  @override
  State<ESportApp> createState() => _ESportAppState();
}

class _ESportAppState extends State<ESportApp> {
  final authController = Get.put(AuthRepository());
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  bool isCurrentlyOnNoInternet = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    connectivitySubscription.cancel();
  }

  void init() async {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        debugPrint('not connected');
        isCurrentlyOnNoInternet = true;
        authController.mNetworkAvailable.value = true;
        Get.to(() => const NoInternetScreen());
      } else if (e == ConnectivityResult.wifi ||
          e == ConnectivityResult.mobile) {
        if (isCurrentlyOnNoInternet) {
          Get.back();
          isCurrentlyOnNoInternet = false;
          authController.mNetworkAvailable.value = false;
        }
        debugPrint('connected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ESports NG',
        initialBinding: AppBinding(),
        theme: ThemeData(
          fontFamily: "GilroyMedium",
          appBarTheme: AppBarTheme(
            backgroundColor: AppColor().primaryBackGroundColor,
          ),
          scaffoldBackgroundColor: AppColor().primaryBackGroundColor,
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
