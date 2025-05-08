import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/notification_service.dart';
import 'package:e_sport/router.dart';
import 'package:e_sport/ui/widgets/utils/no_internet.dart';
import 'package:e_sport/util/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'di/app_binding.dart';
import 'firebase_options.dart';
import 'ui/screens/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notificationService = NotificationService();
  await notificationService.initialize();
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
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  bool isCurrentlyOnNoInternet = false;
  final router = goRouter();

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
      if (e.contains(ConnectivityResult.none)) {
        debugPrint('not connected');
        isCurrentlyOnNoInternet = true;
        authController.mNetworkAvailable.value = true;
        Get.to(() => const NoInternetScreen());
      } else if (e.contains(ConnectivityResult.wifi) ||
          e.contains(ConnectivityResult.mobile)) {
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
    return ScreenUtilInit(
        designSize: Size(390, 781),
        minTextAdapt: true,
        builder: (_, child) {
          return GetMaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'ENGY',
            initialBinding: AppBinding(),
            theme: ThemeData(
              textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: AppColor().primaryWhite,
                  displayColor: AppColor().primaryWhite,
                  fontFamily: "Inter"),
              fontFamily: "InterMedium",
              appBarTheme: AppBarTheme(
                backgroundColor: AppColor().primaryBackGroundColor,
              ),
              scaffoldBackgroundColor: AppColor().primaryBackGroundColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            builder: EasyLoading.init(),
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            routerDelegate: router.routerDelegate,
            // home: const SplashScreen()
          );
        });
  }
}
