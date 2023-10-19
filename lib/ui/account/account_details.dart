import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/components/account_event_widget.dart';
import 'package:e_sport/ui/components/account_team_widget.dart';
import 'package:e_sport/ui/components/games_played_widget.dart';
import 'package:e_sport/ui/components/post_widget.dart';
import 'package:e_sport/ui/components/wallet_widget.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountDetails extends StatefulWidget {
  final String title;
  const AccountDetails({super.key, required this.title});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final authController = Get.put(AuthRepository());
  int? accountTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: widget.title,
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
        actions: [
          IconButton(
            onPressed: () => authController.logout(),
            icon: Icon(
              Icons.settings,
              color: AppColor().primaryWhite,
            ),
          ),
        ],
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      floatingActionButton:
          (widget.title == 'Wallet' || widget.title == 'Referrals')
              ? null
              : FloatingActionButton(
                  backgroundColor: AppColor().primaryColor,
                  onPressed: () {},
                  child: Icon(
                    Icons.add,
                    color: AppColor().primaryWhite,
                  ),
                ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title == 'Posts') ...[
                const PostWidget()
              ] else if (widget.title == 'Player Profile') ...[
                CustomText(
                  title: 'Games played',
                  size: 14,
                  fontFamily: 'GilroyMedium',
                  textAlign: TextAlign.start,
                  color: AppColor().greyTwo,
                ),
                Gap(Get.height * 0.01),
                const GamesPlayedWidget()
              ] else if (widget.title == 'Teams' ||
                  widget.title == 'Communities') ...[
                const AccountTeamsWidget()
              ] else if (widget.title == 'Events') ...[
                const AccountEventsWidget()
              ] else if (widget.title == 'Wallet') ...[
                const WalletWidget()
              ]
            ],
          ),
        ),
      ),
    );
  }
}
