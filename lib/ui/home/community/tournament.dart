import 'package:e_sport/data/model/account_events_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'components/tournament_item.dart';

class Tournament extends StatelessWidget {
  const Tournament({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          title: 'Tournament',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.separated(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.03),
                  itemCount: tournamentItem.take(1).length,
                  itemBuilder: (context, index) {
                    var item = tournamentItem[index];
                    return TournamentItem(item: item);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
