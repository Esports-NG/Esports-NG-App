import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChooseTeamDialog extends StatefulWidget {
  const ChooseTeamDialog({super.key, required this.id});
  final int id;

  @override
  State<ChooseTeamDialog> createState() => _ChooseTeamDialogState();
}

class _ChooseTeamDialogState extends State<ChooseTeamDialog> {
  final teamController = Get.put(TeamRepository());
  final tournamentController = Get.put(TournamentRepository());

  bool _isRegisterLoading = false;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        backgroundColor: AppColor().primaryDark,
        title: Row(
          children: [
            Text(
              "Select Team",
              style: TextStyle(
                  color: AppColor().primaryWhite, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Visibility(visible: _isRegisterLoading, child: const ButtonLoader())
          ],
        ),
        children: teamController.myTeam
            .map((e) => SimpleDialogOption(
                  onPressed: () async {
                    setState(() {
                      _isRegisterLoading = true;
                    });
                    await tournamentController.registerForTeamTournament(
                        widget.id, e.id!);
                    setState(() {
                      _isRegisterLoading = false;
                    });
                  },
                  child: Row(
                    children: [
                      OtherImage(
                          itemSize: Get.height * 0.05,
                          image: '${ApiLink.imageUrl}${e.cover}'),
                      const Gap(10),
                      CustomText(
                        title: e.name,
                        color: AppColor().primaryWhite,
                        size: 16,
                        fontFamily: "GilroyMedium",
                      ),
                    ],
                  ),
                ))
            .toList());
  }
}
