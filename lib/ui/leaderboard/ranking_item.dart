import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Rankingitem extends StatelessWidget {
  const Rankingitem({super.key, required this.team, required this.index});
  final int index;
  final AccountTeamsModel team;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          width: 230,
          decoration: BoxDecoration(
              border: Border.all(
                  color: index == 1
                      ? AppColor().primaryYellow
                      : index == 2
                          ? AppColor().primaryGreen
                          : index == 3
                              ? AppColor().purpleColor
                              : index == 4
                                  ? AppColor().primaryColor
                                  : AppColor().mintColor,
                  width: 1.5),
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            CustomText(
              title: team.name,
              color: AppColor().primaryWhite,
              size: 18,
            ),
            const Spacer(),
            CustomText(
              title: "${team.points}",
              color: AppColor().primaryWhite,
              fontFamily: "GilroySemiBold",
              size: 18,
            )
          ]),
        ),
        Positioned(
          top: 10,
          child: Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == 1
                  ? AppColor().primaryYellow
                  : index == 2
                      ? AppColor().primaryGreen
                      : index == 3
                          ? AppColor().purpleColor
                          : index == 4
                              ? AppColor().primaryColor
                              : AppColor().mintColor,
            ),
            child: CustomText(
              title: "$index",
              fontFamily: "",
              size: 16,
              weight: FontWeight.w600,
              color: AppColor().primaryWhite,
            ),
          ),
        )
      ],
    );
  }
}
