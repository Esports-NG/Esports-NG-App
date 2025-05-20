import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/game/games_played_widget.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPlayerProfile extends StatefulWidget {
  const MyPlayerProfile({super.key});

  @override
  State<MyPlayerProfile> createState() => _MyPlayerProfileState();
}

class _MyPlayerProfileState extends State<MyPlayerProfile> {
  final playerController = Get.put(PlayerRepository());
  bool _loading = true;

  Future getMyPlayer() async {
    await playerController.getMyPlayer();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getMyPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: "Player Profile",
          fontFamily: 'InterSemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: GoBackButton(onPressed: () => Get.back()),
      ),
      body: _loading
          ? LoadingWidget(
              color: AppColor().primaryColor,
            )
          : GamesPlayedWidget(),
    );
  }
}
