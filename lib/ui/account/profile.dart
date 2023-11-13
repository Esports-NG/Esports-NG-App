import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final authController = Get.put(AuthRepository());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: Get.height * 0.15,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/png/account_header.png'),
                      opacity: 0.2),
                ),
              ),
              Positioned(
                top: Get.height * 0.1,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: Get.height * 0.15,
                      width: Get.height * 0.15,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/png/account2.png'),
                        ),
                      ),
                    ),
                    Positioned(
                      right: Get.height * 0.01,
                      bottom: Get.height * 0.015,
                      child: SvgPicture.asset(
                        'assets/images/svg/check_badge.svg',
                        height: Get.height * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: Get.height * 0.03,
                bottom: Get.height * 0.05,
                child: Icon(
                  Icons.settings,
                  size: 25,
                  color: AppColor().primaryWhite,
                ),
              ),
            ],
          ),
          Gap(Get.height * 0.1),
        ],
      ),
    );
  }
}
