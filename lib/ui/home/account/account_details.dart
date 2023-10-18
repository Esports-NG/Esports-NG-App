import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/home/components/games_played_widget.dart';
import 'package:e_sport/ui/home/components/post_widget.dart';
import 'package:e_sport/ui/home/post/post_details.dart';
import 'package:e_sport/ui/home/post/post_item.dart';
import 'package:e_sport/ui/notification/notification_type/posts.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            children: [
              if (widget.title == 'Posts') ...[
                const PostWidget()
              ] else if (widget.title == 'Player Profile') ...[
                const GamesPlayedWidget()
              ]
            ],
          ),
        ),
      ),
    );
  }
}
