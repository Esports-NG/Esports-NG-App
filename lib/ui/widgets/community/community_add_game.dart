import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/game/game_list_dropdown.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommunityAddGame extends StatefulWidget {
  const CommunityAddGame({super.key, required this.community});
  final CommunityModel community;

  @override
  State<CommunityAddGame> createState() => _CommunityAddGameState();
}

class _CommunityAddGameState extends State<CommunityAddGame> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final communityController = Get.put(CommunityRepository());
  bool _isAdding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: 'Add Game To Community',
          fontFamily: 'InterSemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: GoBackButton(onPressed: () => Get.back()),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.settings,
        //       color: AppColor().primaryWhite,
        //     ),
        //   ),
        // ],
      ),
      body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            decoration: BoxDecoration(
                color: AppColor().primaryBackGroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Game to be covered *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              GameDropdown(
                enableFill: true,
                gameValue: communityController.addToGamesPlayedValue,
              ),
              Gap(Get.height * 0.02),
              InkWell(
                onTap: () async {
                  setState(() {
                    _isAdding = true;
                  });
                  await communityController
                      .addGameToCommunity(widget.community.id!);
                  setState(() {
                    _isAdding = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      color: _isAdding
                          ? Colors.transparent
                          : AppColor().primaryColor,
                      borderRadius: BorderRadius.circular(90),
                      border: _isAdding
                          ? Border.all(
                              color: AppColor().primaryColor.withOpacity(0.4))
                          : null),
                  child: _isAdding
                      ? const Center(child: ButtonLoader())
                      : Center(
                          child: CustomText(
                              title: "Add Game",
                              fontFamily: "InterSemiBold",
                              color: AppColor().primaryWhite),
                        ),
                ),
              )
            ]),
          )),
    );
  }
}
