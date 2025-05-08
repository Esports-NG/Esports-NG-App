import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_icons/line_icons.dart';

class Rankingitem extends StatelessWidget {
  const Rankingitem({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane:
          ActionPane(extentRatio: 0.1, motion: const BehindMotion(), children: [
        SlidableAction(
          padding: EdgeInsets.all(0),
          onPressed: (context) {},
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
          backgroundColor: AppColor().primaryColor,
          icon: LineIcons.edit,
        )
      ]),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                title: "Ninja Warriors",
                color: index == 1
                    ? AppColor().primaryYellow
                    : index == 2
                        ? AppColor().primaryGreen
                        : index == 3
                            ? AppColor().purpleColor
                            : index == 4
                                ? AppColor().primaryColor
                                : AppColor().mintColor,
                size: 12,
                letterSpacing: -0.36,
              ),
              const Spacer(),
              CustomText(
                title: "500",
                color: index == 1
                    ? AppColor().primaryYellow
                    : index == 2
                        ? AppColor().primaryGreen
                        : index == 3
                            ? AppColor().purpleColor
                            : index == 4
                                ? AppColor().primaryColor
                                : AppColor().mintColor,
                fontFamily: "InterSemiBold",
                size: 12,
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
                size: 16,
                fontFamily: "InterSemiBold",
                color: AppColor().primaryWhite,
              ),
            ),
          )
        ],
      ),
    );
  }
}
