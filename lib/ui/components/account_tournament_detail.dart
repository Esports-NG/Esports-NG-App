import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountTournamentDetail extends StatefulWidget {
  final EventModel item;
  const AccountTournamentDetail({super.key, required this.item});

  @override
  State<AccountTournamentDetail> createState() =>
      _AccountTournamentDetailState();
}

class _AccountTournamentDetailState extends State<AccountTournamentDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: Get.height * 0.15,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/png/account_header.png'),
                        opacity: 0.2),
                  ),
                ),
                Positioned(
                  top: Get.height * 0.1,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      OtherImage(
                          itemSize: Get.height * 0.13,
                          image: '${ApiLink.imageUrl}${widget.item.profile}'),
                      Positioned(
                        child: SvgPicture.asset(
                          'assets/images/svg/check_badge.svg',
                          height: Get.height * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GoBackButton(onPressed: () => Get.back()),
                      Padding(
                        padding: EdgeInsets.only(right: Get.height * 0.02),
                        child: InkWell(
                          child: Icon(
                            Icons.settings,
                            color: AppColor().primaryWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(Get.height * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Column(
                children: [
                  CustomText(
                      title: widget.item.name,
                      weight: FontWeight.w500,
                      size: Get.height * 0.02,
                      fontFamily: 'GilroyBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.02),
                  AccountEventsItem(item: widget.item),
                  Gap(Get.height * 0.05),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: Get.height * 0.06,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColor().primaryColor,
                      ),
                      child:
                          // (authController.signInStatus == SignInStatus.loading)
                          //     ? const LoadingWidget()
                          //     :
                          Center(
                              child: CustomText(
                        title: 'Register Now',
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.018,
                        fontFamily: 'GilroyMedium',
                      )),
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Gap(Get.height * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
