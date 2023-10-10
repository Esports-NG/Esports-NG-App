import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final authController = Get.put(AuthRepository());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().pureBlackColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            children: [
              Gap(Get.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => authController.logout(),
                      icon: Icon(
                        Icons.settings,
                        color: AppColor().primaryWhite,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
