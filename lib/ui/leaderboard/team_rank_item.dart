import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TeamRankItem extends StatelessWidget {
  final AccountTeamsModel item;
  final int index;
  const TeamRankItem({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            title: '${index + 1}',
            size: 14,
            fontFamily: 'InterSemiBold',
            textAlign: TextAlign.start,
            color: AppColor().primaryWhite,
          ),
        ),
        Expanded(
          child: Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset('assets/images/svg/${item.details}.svg')),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Image.asset(
                'assets/images/png/lImage1.png',
                height: Get.height * 0.03,
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: item.name,
                size: 12,
                fontFamily: 'InterSemiBold',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: CustomText(
              title: item.points.toString(),
              size: 14,
              fontFamily: 'InterSemiBold',
              textAlign: TextAlign.start,
              color: AppColor().primaryWhite,
            ),
          ),
        ),
      ],
    );
  }
}
