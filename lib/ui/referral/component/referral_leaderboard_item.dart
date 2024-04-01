import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ReferralLeaderboardItem extends StatelessWidget {
  const ReferralLeaderboardItem(
      {super.key, required this.item, required this.index});

  final AccountTeamsModel item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Get.height * 0.02, vertical: Get.height * 0.015),
      color: index == 0
          ? AppColor().goldColor
          : index == 1
              ? AppColor().silverColor
              : index == 2
                  ? AppColor().bronzeColor
                  : null,
      child: Row(
        children: [
          Expanded(
              child: CustomText(
            title: '${index + 1}',
            fontFamily: "GilroySemiBold",
            color: [0, 1, 2].contains(index)
                ? AppColor().pureBlackColor
                : AppColor().primaryWhite,
            size: 16,
          )),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: [0, 1, 2].contains(index)
                      ? SvgPicture.asset(
                          "assets/images/svg/trophy.svg",
                          height: 15,
                        )
                      : const SmallCircle(
                          size: 10,
                        ))),
          Expanded(
              flex: 3,
              child: CustomText(
                title: item.name,
                fontFamily: "GilroySemiBold",
                color: [0, 1, 2].contains(index)
                    ? AppColor().pureBlackColor
                    : AppColor().primaryWhite,
                size: 16,
              )),
          Expanded(
            flex: 2,
            child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  title: "${item.points! ~/ 10}",
                  fontFamily: "GilroySemiBold",
                  color: [0, 1, 2].contains(index)
                      ? AppColor().pureBlackColor
                      : AppColor().primaryWhite,
                )),
          )
        ],
      ),
    );
  }
}
