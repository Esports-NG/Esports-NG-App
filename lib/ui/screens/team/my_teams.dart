import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/team/account_team_widget.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTeams extends StatefulWidget {
  const MyTeams({super.key});

  @override
  State<MyTeams> createState() => _MyTeamsState();
}

class _MyTeamsState extends State<MyTeams> {
  final teamController = Get.put(TeamRepository());
  bool _loading = true;

  Future getMyTeams() async {
    await teamController.getMyTeam(false);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomText(
            title: "My Teams",
            fontFamily: 'InterSemiBold',
            size: 18,
            color: AppColor().primaryWhite,
          ),
          leading: GoBackButton(onPressed: () => Get.back()),
        ),
        body: _loading
            ? const LoadingWidget()
            : teamController.myTeam.isEmpty
                ? Center(
                    child: CustomText(
                      title: "You don't have any teams yet",
                      fontFamily: 'InterMedium',
                      size: 16,
                      color: AppColor().primaryWhite,
                    ),
                  )
                : AccountTeamsWidget());
  }
}
