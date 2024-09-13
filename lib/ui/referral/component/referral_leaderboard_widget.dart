import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/ui/referral/component/referral_leaderboard_item.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReferralLeaderboardWidget extends StatelessWidget {
  const ReferralLeaderboardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(Get.height * 0.01),
          Center(
            child: CustomText(
              color: AppColor().primaryWhite,
              title: "Top Referring Users",
              fontFamily: "InterSemiBold",
              size: 20,
            ),
          ),
          Gap(Get.height * 0.015),
          Center(
            child: CustomText(
              title:
                  "Top 3 Monthly Referees win \$25, \$15 and \$10 respectively",
              color: AppColor().greySix,
              size: 16,
              textAlign: TextAlign.center,
            ),
          ),
          Gap(Get.height * 0.02),
          Container(
            decoration: BoxDecoration(
                color: AppColor().bgDark,
                border: Border.all(color: AppColor().greyEight),
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                    repeat: ImageRepeat.repeat,
                    image: AssetImage("assets/images/png/leaderboard_bg.png"))),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Get.height * 0.04,
                    right: Get.height * 0.04,
                    bottom: Get.height * 0.02,
                    top: Get.height * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColor().greySix),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            CustomText(
                              title: "November",
                              color: AppColor().primaryWhite,
                              fontFamily: "InterMedium",
                              size: 18,
                            ),
                            const Spacer(),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColor().primaryWhite,
                              size: 25,
                            )
                          ],
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor().greySix),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          CustomText(
                            title: "2023",
                            color: AppColor().primaryWhite,
                            fontFamily: "InterMedium",
                            size: 18,
                          ),
                          Gap(Get.height * 0.01),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColor().primaryWhite,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColor().greyEight,
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomText(
                      title: "Rank",
                      color: AppColor().primaryWhite,
                      fontFamily: "InterSemiBold",
                      size: 16,
                    )),
                    Expanded(
                      child: CustomText(
                        title: '',
                        size: 16,
                        fontFamily: 'InterSemiBold',
                        textAlign: TextAlign.start,
                        color: AppColor().primaryWhite,
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: CustomText(
                          title: "Users",
                          color: AppColor().primaryWhite,
                          fontFamily: "InterSemiBold",
                          size: 16,
                        )),
                    Expanded(
                        flex: 2,
                        child: CustomText(
                          title: "Referrals",
                          textAlign: TextAlign.end,
                          color: AppColor().primaryWhite,
                          fontFamily: "InterSemiBold",
                          size: 16,
                        )),
                  ],
                ),
              ),
              // Gap(Get.height * 0.02),
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = teamRankItem[index];
                    return ReferralLeaderboardItem(item: item, index: index);
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: [0, 1, 2].contains(index)
                            ? Colors.transparent
                            : AppColor().greyEight,
                        height: 0,
                        thickness: 0.5,
                      ),
                  itemCount: 12)
            ]),
          )
        ],
      ),
    );
  }
}
